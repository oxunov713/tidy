import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tidy_client/features/addresses/presentation/address_providers.dart';
import 'package:tidy_client/features/auth/presentation/auth_providers.dart';
import 'package:tidy_client/features/booking_wizard/presentation/booking_wizard_state.dart';
import 'package:tidy_client/features/bookings/presentation/bookings_providers.dart';
import 'package:tidy_core/tidy_core.dart';

part 'booking_wizard_controller.g.dart';

/// How long to wait after the last change before asking for a new price, so
/// tapping a stepper five times sends one request.
@Riverpod(keepAlive: true)
Duration quoteDebounce(Ref ref) => const Duration(milliseconds: 350);

@Riverpod(keepAlive: true)
class BookingWizard extends _$BookingWizard {
  Timer? _debounce;
  int _quoteTicket = 0;
  int _slotsTicket = 0;

  @override
  BookingWizardState build() {
    ref
      ..watch(currentUserIdProvider)
      ..onDispose(() => _debounce?.cancel());
    return const BookingWizardState();
  }

  /// Begins a new booking of [service]. [from] pre-fills the choices of an
  /// earlier booking ("Book again").
  void start(Service service, {Booking? from}) {
    _debounce?.cancel();
    _quoteTicket++;
    _slotsTicket++;
    final address = ref.read(currentAddressProvider);
    state = BookingWizardState(
      service: service,
      bedrooms: from?.bedrooms ?? 2,
      bathrooms: from?.bathrooms ?? 1,
      extraIds: {...?from?.extras.map((e) => e.id)},
      frequency: from?.frequency ?? Frequency.once,
      cleanerId: from?.cleanerId,
      date: _today(),
      address: address,
      accessNotes: address?.accessNotes ?? '',
    );
    _refreshQuote(debounced: false);
  }

  void setBedrooms(int value) {
    final next = value.clamp(1, maxRooms);
    if (next == state.bedrooms) return;
    state = state.copyWith(bedrooms: next);
    _configChanged();
  }

  void setBathrooms(int value) {
    final next = value.clamp(1, maxRooms);
    if (next == state.bathrooms) return;
    state = state.copyWith(bathrooms: next);
    _configChanged();
  }

  void toggleExtra(String id) {
    final extras = {...state.extraIds};
    if (!extras.remove(id)) extras.add(id);
    state = state.copyWith(extraIds: extras);
    _configChanged();
  }

  void setFrequency(Frequency value) {
    if (value == state.frequency) return;
    state = state.copyWith(frequency: value);
    // Frequency changes the price but not how long the visit takes, so the
    // slots stay valid.
    _refreshQuote();
  }

  void setAddress(Address address) {
    if (address.id == state.address?.id) return;
    state = state.copyWith(address: address, accessNotes: address.accessNotes);
  }

  void setAccessNotes(String value) =>
      state = state.copyWith(accessNotes: value);

  /// Picks a cleaner, or null for "any available cleaner". Availability
  /// depends on the cleaner, so the times are reloaded.
  Future<void> selectCleaner(String? cleanerId) {
    if (cleanerId == state.cleanerId) return Future.value();
    state = state.copyWith(cleanerId: cleanerId, slot: null);
    return loadSlots();
  }

  Future<void> selectDate(DateTime day) {
    state = state.copyWith(
      date: DateTime(day.year, day.month, day.day),
      slot: null,
    );
    return loadSlots();
  }

  void selectSlot(DateTime start) {
    final slot = state.slots.where((s) => s.start == start).firstOrNull;
    if (slot == null || !slot.available) return;
    state = state.copyWith(slot: start);
  }

  /// Fetches the start times for the chosen day.
  Future<void> loadSlots() async {
    final s = state;
    final service = s.service;
    final address = s.address;
    final date = s.date;
    if (service == null || address == null || date == null) return;

    final ticket = ++_slotsTicket;
    state = s.copyWith(slotsLoading: true, slotsError: null);
    try {
      final response = await ref
          .read(bookingRepositoryProvider)
          .slots(
            serviceId: service.id,
            bedrooms: s.bedrooms,
            bathrooms: s.bathrooms,
            extraIds: s.extraIds.toList()..sort(),
            date: date,
            addressId: address.id,
            cleanerId: s.cleanerId,
          );
      if (ticket != _slotsTicket) return;
      final stillFree =
          state.slot != null &&
          response.slots.any((x) => x.start == state.slot && x.available);
      state = state.copyWith(
        slots: response.slots,
        slotsLoading: false,
        slot: stillFree ? state.slot : null,
      );
    } on Object catch (error) {
      if (ticket != _slotsTicket) return;
      state = state.copyWith(slotsLoading: false, slotsError: error);
    }
  }

  /// Retries after a failed price request.
  void retryQuote() => _refreshQuote(debounced: false);

  /// Creates the booking. The result tells the screen where to go next.
  Future<BookingSubmitResult> submit() async {
    final s = state;
    final service = s.service;
    var address = s.address;
    final slot = s.slot;
    if (s.submitting || service == null || address == null || slot == null) {
      return BookingSubmitFailed(StateError('Booking is incomplete'));
    }
    state = s.copyWith(submitting: true);
    try {
      // The API has no way to edit an address, so changed access notes are
      // saved as a new address with the same pin.
      final notes = s.accessNotes.trim();
      if (notes != address.accessNotes.trim()) {
        address = await ref
            .read(addressesProvider.notifier)
            .add(
              AddressInput(
                line1: address.line1,
                line2: address.line2,
                city: address.city,
                postcode: address.postcode,
                lat: address.lat,
                lng: address.lng,
                accessNotes: notes,
              ),
            );
        state = state.copyWith(address: address);
      }
      final created = await ref
          .read(bookingRepositoryProvider)
          .create(
            CreateBookingRequest(
              serviceId: service.id,
              bedrooms: s.bedrooms,
              bathrooms: s.bathrooms,
              addressId: address.id,
              start: slot,
              extraIds: s.extraIds.toList()..sort(),
              frequency: s.frequency,
              cleanerId: s.cleanerId,
            ),
          );
      state = state.copyWith(submitting: false);
      ref
        ..invalidate(bookingsListProvider(BookingScope.upcoming))
        ..invalidate(bookingsListProvider(BookingScope.past));
      return BookingSubmitted(created);
    } on SlotTakenException {
      state = state.copyWith(submitting: false, slot: null);
      await loadSlots();
      return const BookingSlotTaken();
    } on Object catch (error) {
      state = state.copyWith(submitting: false);
      return BookingSubmitFailed(error);
    }
  }

  /// A change to rooms or extras alters both price and duration, so the times
  /// already loaded no longer apply.
  void _configChanged() {
    state = state.copyWith(slot: null, slots: const []);
    _refreshQuote();
  }

  void _refreshQuote({bool debounced = true}) {
    _debounce?.cancel();
    final ticket = ++_quoteTicket;
    state = state.copyWith(quoteLoading: true, quoteError: null);
    if (!debounced) {
      unawaited(_fetchQuote(ticket));
      return;
    }
    _debounce = Timer(
      ref.read(quoteDebounceProvider),
      () => unawaited(_fetchQuote(ticket)),
    );
  }

  Future<void> _fetchQuote(int ticket) async {
    final request = state.quoteRequest;
    if (request == null) return;
    try {
      final quote = await ref.read(bookingRepositoryProvider).quote(request);
      // A newer request was made while this one was in flight.
      if (ticket != _quoteTicket) return;
      state = state.copyWith(quote: quote, quoteLoading: false);
    } on Object catch (error) {
      if (ticket != _quoteTicket) return;
      state = state.copyWith(quoteLoading: false, quoteError: error);
    }
  }

  DateTime _today() {
    final now = ref.read(clockProvider)();
    return DateTime(now.year, now.month, now.day);
  }
}
