import CoreLocation
import MapKit

@Observable
final class LocationService: NSObject, @unchecked Sendable, CLLocationManagerDelegate {
    var cityName: String?
    var latitude: Double?
    var longitude: Double?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func geocodeCity(_ name: String) async -> Bool {
        guard let request = MKGeocodingRequest(addressString: name) else { return false }
        do {
            let mapItems = try await request.mapItems
            if let item = mapItems.first {
                let coord = item.location.coordinate
                let resolvedName = item.address?.shortAddress ?? item.name ?? name
                await MainActor.run {
                    latitude = coord.latitude
                    longitude = coord.longitude
                    cityName = resolvedName
                }
                return true
            }
        } catch {}
        return false
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coord = location.coordinate
        Task { @MainActor in
            self.latitude = coord.latitude
            self.longitude = coord.longitude
            await self.reverseGeocode(location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}

    private func reverseGeocode(_ location: CLLocation) async {
        guard let request = MKReverseGeocodingRequest(location: location) else { return }
        do {
            let mapItems = try await request.mapItems
            cityName = mapItems.first?.address?.shortAddress ?? mapItems.first?.name
        } catch {}
    }
}
