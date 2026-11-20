import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tidy_core/tidy_core.dart';

part 'booking_wizard_state.freezed.dart';

const int maxRooms = 6;

/// Everything the three booking steps share. One notifier owns it, so going
/// back and forth between steps never loses a choice.
@freezed
abstract class BookingWizardState with _$BookingWizardState {
  const factory BookingWizardState({
    Service? service,
    @Default(2) int bedrooms,
    @Default(1) int bathrooms,
    @Default(<String>{}) Set<String> extraIds,
    @Default(Frequency.once) Frequency frequency,

    /// Latest price from the server. Kept while a newer one is loading so the
    /// total does not jump to nothing.
    Quote? quote,
    @Default(false) bool quoteLoading,
    Object? quoteError,

    /// The day picked in the Schedule step (local, time of day ignored).
    DateTime? date,
    @Default(<Slot>[]) List<Slot> slots,
    @Default(false) bool slotsLoading,
    Object? slotsError,

    /// Chosen start time.
    DateTime? slot,

    /// A specific cleaner ("your last cleaner"), or null for anyone.
    String? cleanerId,
    Address? address,
    @Default('') String accessNotes,
    @Default(false) bool submitting,
  }) = _BookingWizardState;

  const BookingWizardState._();

  QuoteRequest? get quoteRequest {
    final service = this.service;
    if (service == null) return null;
    return QuoteRequest(
      serviceId: service.id,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      extraIds: extraIds.toList()..sort(),
      frequency: frequency,
    );
  }

  bool get canChooseTime => service != null && quote != null && !quoteLoading;
  bool get canCheckout => canChooseTime && slot != null && address != null;
}

/// How `BookingWizard.submit` ended.
sealed class BookingSubmitResult {
  const BookingSubmitResult();
}

final class BookingSubmitted extends BookingSubmitResult {
  const BookingSubmitted(this.created);

  final BookingCreated created;
}

/// Somebody else took the time first. The wizard has already dropped the slot
/// and reloaded the times.
final class BookingSlotTaken extends BookingSubmitResult {
  const BookingSlotTaken();
}

final class BookingSubmitFailed extends BookingSubmitResult {
  const BookingSubmitFailed(this.error);

  final Object error;
}
