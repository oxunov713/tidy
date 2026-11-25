import 'dart:async';

import 'package:tidy_cleaner/core/alerts/offer_alerts.dart';
import 'package:tidy_cleaner/core/location/location_service.dart';
import 'package:tidy_cleaner/features/chat/domain/chat_repository.dart';
import 'package:tidy_cleaner/features/earnings/domain/earnings_repository.dart';
import 'package:tidy_cleaner/features/jobs/domain/incoming_offer.dart';
import 'package:tidy_cleaner/features/jobs/domain/jobs_repository.dart';
import 'package:tidy_cleaner/features/jobs/domain/offers_repository.dart';
import 'package:tidy_core/tidy_core.dart';

class FakeLocation implements LocationService {
  LocationAccess accessResult = LocationAccess.granted;
  LocationAccess requestResult = LocationAccess.granted;
  GeoPoint fix = const GeoPoint(lat: 51.5, lng: -0.12);
  Exception? currentError;
  final positionsController = StreamController<GeoPoint>.broadcast();
  int settingsOpened = 0;

  void move(double lat, double lng) =>
      positionsController.add(GeoPoint(lat: lat, lng: lng));

  @override
  Future<LocationAccess> access() async => accessResult;

  @override
  Future<LocationAccess> requestAccess() async => requestResult;

  @override
  Future<GeoPoint> current() async {
    if (currentError != null) throw currentError!;
    return fix;
  }

  @override
  Stream<GeoPoint> positions() => positionsController.stream;

  @override
  Future<void> openSettings() async => settingsOpened++;
}

class FakeAlerts implements OfferAlerts {
  int count = 0;

  @override
  Future<void> newOffer() async => count++;
}

class FakeOffersRepository implements OffersRepository {
  List<IncomingOffer> open_ = [];
  Exception? acceptError;
  Exception? declineError;
  Booking? acceptResult;
  final accepted = <String>[];
  final declined = <String>[];

  @override
  Future<List<IncomingOffer>> open() async => open_;

  @override
  Future<Booking> accept(String bookingId) async {
    accepted.add(bookingId);
    if (acceptError != null) throw acceptError!;
    return acceptResult!;
  }

  @override
  Future<void> decline(String bookingId) async {
    declined.add(bookingId);
    if (declineError != null) throw declineError!;
  }
}

class FakeJobsRepository implements JobsRepository {
  List<Job> jobs_ = [];
  Exception? statusError;
  Booking Function(String id, BookingStatus status)? onStatus;
  final statusCalls = <(String, BookingStatus)>[];
  int loads = 0;

  /// Makes the next [jobs] call fail once.
  bool failNext = false;

  @override
  Future<List<Job>> jobs({DateTime? from, DateTime? to}) async {
    loads++;
    if (failNext) {
      failNext = false;
      throw const NetworkException();
    }
    return jobs_;
  }

  @override
  Future<Booking> setStatus(String bookingId, BookingStatus status) async {
    statusCalls.add((bookingId, status));
    if (statusError != null) throw statusError!;
    return onStatus!(bookingId, status);
  }
}

class FakePresence implements PresenceRepository {
  final calls = <(bool, GeoPoint?)>[];
  Exception? error;

  @override
  Future<void> setOnline({required bool online, GeoPoint? at}) async {
    calls.add((online, at));
    if (error != null) throw error!;
  }
}

class FakeEarningsRepository implements EarningsRepository {
  FakeEarningsRepository(this.result);

  Earnings result;
  final requested = <EarningsPeriod>[];

  @override
  Future<Earnings> earnings(EarningsPeriod period) async {
    requested.add(period);
    return result;
  }
}

class FakeChatRepository implements ChatRepository {
  List<Message> messages = [];
  final sent = <String>[];

  @override
  Future<List<Message>> history(String bookingId) async => messages;

  @override
  Future<Message> send(String bookingId, String body) async {
    sent.add(body);
    return Message(
      id: 100 + sent.length,
      bookingId: bookingId,
      senderId: 'me',
      body: body,
      createdAt: DateTime.utc(2026, 12, 3, 9),
    );
  }
}
