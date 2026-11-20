/// JSON as the Go backend writes it (field names and shapes copied from real
/// responses of `backend/internal/httpapi`).
library;

const cleanerId = '407b11b6-f759-4db5-a8f5-348118f8f90f';
const clientId = 'b459ae9e-c31d-43bc-a833-9d2f9a60e017';

Map<String, Object?> bookingJson({String status = 'assigned'}) => {
  'id': '5874d2af-ead1-4862-a807-260266e04e24',
  'code': 'TD-1000',
  'client_id': clientId,
  'cleaner_id': cleanerId,
  'service_id': '89ea21c9-94fa-41d8-99bd-f8506c947a21',
  'service_title': 'Standard clean',
  'address_id': 'f7a2078c-199f-4af0-af4f-7d6f565d5ce6',
  'requested_cleaner_id': null,
  'plan_id': '066ba558-a2ee-4fb5-846b-61888aafa867',
  'bedrooms': 2,
  'bathrooms': 1,
  'frequency': 'weekly',
  'start': '2026-12-03T10:00:00Z',
  'end': '2026-12-03T13:00:00Z',
  'status': status,
  'subtotal': 8000,
  'discount': 1200,
  'total': 6800,
  'cleaner_payout': 5100,
  'extras': [
    {
      'id': '91544ea8-34b4-4533-8c25-2152b0e5f0c1',
      'title': 'Inside oven',
      'price': 2000,
    },
  ],
  'created_at': '2026-11-20T06:35:52.018791Z',
  'updated_at': '2026-11-20T06:35:52.182969Z',
};

Map<String, Object?> addressJson() => {
  'id': 'f7a2078c-199f-4af0-af4f-7d6f565d5ce6',
  'line1': '221B Baker Street',
  'line2': '',
  'city': 'London',
  'postcode': 'NW1 6XE',
  'lat': 51.5238,
  'lng': -0.1586,
  'access_notes': 'Ring the top bell.',
};

Map<String, Object?> userJson({String role = 'client'}) => {
  'id': clientId,
  'phone': '+447700900201',
  'full_name': 'Charlie Client',
  'email': null,
  'role': role,
  'avatar_url': null,
  'created_at': '2026-11-20T06:35:11.249316Z',
};

Map<String, Object?> cleanerJson() => {
  'user_id': cleanerId,
  'status': 'approved',
  'bio': 'Five years of deep cleans, pet friendly.',
  'rating': 5,
  'rating_count': 1,
  'is_online': true,
  'last_lat': 51.5115,
  'last_lng': -0.116,
  'last_seen_at': '2026-11-20T06:46:05.829462Z',
};
