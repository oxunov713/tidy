package domain

import (
	"errors"
	"reflect"
	"testing"
)

var standard = Service{
	Title: "Standard clean", BasePrice: 4500, PerBedroom: 1500, PerBathroom: 1000,
	BaseMinutes: 120, MinutesPerRoom: 30, IsActive: true,
}

var oven = Extra{Title: "Inside oven", Price: 2000, Minutes: 30}

func TestPrice(t *testing.T) {
	tests := []struct {
		name string
		in   QuoteInput
		want Quote
	}{
		{
			name: "one bed one bath is the base price",
			in:   QuoteInput{Service: standard, Bedrooms: 1, Bathrooms: 1, Frequency: FrequencyOnce},
			want: Quote{Subtotal: 4500, Total: 4500, Minutes: 120, Lines: []QuoteLine{
				{Label: "Standard clean · 1 bed, 1 bath", Amount: 4500},
			}},
		},
		{
			name: "weekly with an extra matches the design",
			in:   QuoteInput{Service: standard, Bedrooms: 2, Bathrooms: 1, Extras: []Extra{oven}, Frequency: FrequencyWeekly},
			want: Quote{Subtotal: 8000, Discount: 1200, Total: 6800, Minutes: 180, Lines: []QuoteLine{
				{Label: "Standard clean · 2 bed, 1 bath", Amount: 6000},
				{Label: "Inside oven", Amount: 2000},
				{Label: "Weekly discount (15%)", Amount: -1200},
			}},
		},
		{
			name: "fortnightly takes ten percent",
			in:   QuoteInput{Service: standard, Bedrooms: 3, Bathrooms: 2, Frequency: FrequencyFortnightly},
			want: Quote{Subtotal: 8500, Discount: 850, Total: 7650, Minutes: 210, Lines: []QuoteLine{
				{Label: "Standard clean · 3 bed, 2 bath", Amount: 8500},
				{Label: "Fortnightly discount (10%)", Amount: -850},
			}},
		},
		{
			name: "discount rounds half up to whole pence",
			in:   QuoteInput{Service: Service{Title: "Odd", BasePrice: 4510, BaseMinutes: 60, IsActive: true}, Bedrooms: 1, Bathrooms: 1, Frequency: FrequencyWeekly},
			want: Quote{Subtotal: 4510, Discount: 677, Total: 3833, Minutes: 60, Lines: []QuoteLine{
				{Label: "Odd · 1 bed, 1 bath", Amount: 4510},
				{Label: "Weekly discount (15%)", Amount: -677},
			}},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := Price(tt.in)
			if err != nil {
				t.Fatalf("Price: %v", err)
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("got  %+v\nwant %+v", got, tt.want)
			}
			if got.Total != got.Subtotal-got.Discount {
				t.Errorf("total %d != subtotal %d - discount %d", got.Total, got.Subtotal, got.Discount)
			}
		})
	}
}

func TestPriceRejectsBadInput(t *testing.T) {
	inactive := standard
	inactive.IsActive = false

	tests := []struct {
		name  string
		in    QuoteInput
		field string
	}{
		{"no bedrooms", QuoteInput{Service: standard, Bedrooms: 0, Bathrooms: 1, Frequency: FrequencyOnce}, "bedrooms"},
		{"too many bathrooms", QuoteInput{Service: standard, Bedrooms: 1, Bathrooms: 11, Frequency: FrequencyOnce}, "bathrooms"},
		{"unknown frequency", QuoteInput{Service: standard, Bedrooms: 1, Bathrooms: 1, Frequency: "daily"}, "frequency"},
		{"inactive service", QuoteInput{Service: inactive, Bedrooms: 1, Bathrooms: 1, Frequency: FrequencyOnce}, "service_id"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err := Price(tt.in)
			var de *Error
			if !errors.As(err, &de) || de.Code != CodeInvalidRequest {
				t.Fatalf("want invalid_request, got %v", err)
			}
			if _, ok := de.Fields[tt.field]; !ok {
				t.Errorf("want problem on %q, got %v", tt.field, de.Fields)
			}
		})
	}
}

func TestCleanerPayout(t *testing.T) {
	tests := []struct{ total, want int }{
		{6800, 5100},
		{4500, 3375},
		{1, 1},
		{0, 0},
	}
	for _, tt := range tests {
		if got := CleanerPayout(tt.total); got != tt.want {
			t.Errorf("CleanerPayout(%d) = %d, want %d", tt.total, got, tt.want)
		}
	}
}
