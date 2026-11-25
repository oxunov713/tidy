import 'package:tidy_core/tidy_core.dart';

const standard = Service(
  id: 'svc-standard',
  slug: 'standard',
  title: 'Standard clean',
  fromPrice: 4500,
  minutes: 120,
);
const deep = Service(
  id: 'svc-deep',
  slug: 'deep',
  title: 'Deep clean',
  fromPrice: 8900,
  minutes: 240,
);
const oven = Extra(
  id: 'ex-oven',
  slug: 'oven',
  title: 'Inside oven',
  price: 2000,
);
const fridge = Extra(
  id: 'ex-fridge',
  slug: 'fridge',
  title: 'Fridge',
  price: 1500,
);

const home = Address(
  id: 'addr-1',
  line1: '14 Baker Street',
  city: 'London',
  postcode: 'NW1 6XE',
  lat: 51.5238,
  lng: -0.1586,
  line2: '',
  accessNotes: 'Ring the top bell',
);

User user({String name = 'Emma Stone'}) => User(
  id: 'user-1',
  phone: '+447700900201',
  fullName: name,
  role: UserRole.client,
  createdAt: DateTime.utc(2026),
);

Booking booking({
  String id = 'bk-1',
  BookingStatus status = BookingStatus.confirmed,
  String? cleanerId,
  DateTime? start,
  int total = 6800,
  Frequency frequency = Frequency.once,
  String title = 'Standard clean',
  String? planId,
}) {
  final s = start ?? DateTime.utc(2026, 12, 3, 10);
  return Booking(
    id: id,
    code: 'TD-$id',
    clientId: 'user-1',
    serviceId: standard.id,
    serviceTitle: title,
    addressId: home.id,
    bedrooms: 2,
    bathrooms: 1,
    frequency: frequency,
    start: s,
    end: s.add(const Duration(hours: 3)),
    status: status,
    subtotal: total,
    discount: 0,
    total: total,
    cleanerPayout: 4000,
    createdAt: DateTime.utc(2026, 11),
    updatedAt: DateTime.utc(2026, 11),
    cleanerId: cleanerId,
    planId: planId,
  );
}

Quote quoteFor({int total = 6800, int minutes = 150}) => Quote(
  subtotal: total,
  discount: 0,
  total: total,
  minutes: minutes,
  lines: [QuoteLine(label: 'Standard clean', amount: total)],
);
