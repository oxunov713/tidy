-- Demo catalogue. Prices are in pence and match the design.
INSERT INTO services (slug, title, base_price, per_bedroom, per_bathroom, base_minutes, minutes_per_room, sort_order) VALUES
    ('standard',       'Standard clean',  4500, 1500, 1000, 120, 30, 1),
    ('deep',           'Deep clean',      8900, 2500, 1500, 240, 45, 2),
    ('end-of-tenancy', 'End of tenancy', 14900, 3000, 2000, 300, 60, 3),
    ('office',         'Office',          6000, 1500, 1000, 120, 30, 4);

INSERT INTO service_extras (slug, title, price, minutes) VALUES
    ('oven',    'Inside oven',   2000, 30),
    ('fridge',  'Inside fridge', 1500, 20),
    ('windows', 'Windows',       2500, 40),
    ('ironing', 'Ironing',       1800, 30);
