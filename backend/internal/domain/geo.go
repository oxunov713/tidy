package domain

import "math"

const earthRadiusKm = 6371.0

// DistanceKm is the great-circle distance between two points.
func DistanceKm(lat1, lng1, lat2, lng2 float64) float64 {
	rad := func(d float64) float64 { return d * math.Pi / 180 }
	dLat, dLng := rad(lat2-lat1), rad(lng2-lng1)
	a := math.Sin(dLat/2)*math.Sin(dLat/2) +
		math.Cos(rad(lat1))*math.Cos(rad(lat2))*math.Sin(dLng/2)*math.Sin(dLng/2)
	return 2 * earthRadiusKm * math.Asin(math.Sqrt(a))
}

// citySpeedKmh is an average door-to-door speed across London. Good enough
// for an ETA until a routing API is plugged in.
const citySpeedKmh = 20.0

// ETAMinutes is a naive travel time estimate, never less than one minute.
func ETAMinutes(distanceKm float64) int {
	return max(1, int(math.Ceil(distanceKm/citySpeedKmh*60)))
}

func ValidCoordinates(lat, lng float64) bool {
	return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180
}
