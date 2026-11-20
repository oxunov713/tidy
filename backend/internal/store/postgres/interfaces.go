package postgres

import "github.com/oxunov713/tidy/backend/internal/service"

// Compile-time checks that Store provides everything the services need.
var (
	_ service.AuthStore      = (*Store)(nil)
	_ service.UserStore      = (*Store)(nil)
	_ service.DeviceStore    = (*Store)(nil)
	_ service.CatalogueStore = (*Store)(nil)
	_ service.CleanersStore  = (*Store)(nil)
	_ service.BookingsStore  = (*Store)(nil)
	_ service.DispatchStore  = (*Store)(nil)
	_ service.PaymentStore   = (*Store)(nil)
	_ service.AdminDeps      = (*Store)(nil)
)
