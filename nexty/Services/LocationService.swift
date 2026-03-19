import MapKit
import os

private let logger = Logger(subsystem: "com.talthent.nexty", category: "LocationService")

@Observable
final class LocationService {
    var cityName: String? {
        didSet { UserDefaults.standard.set(cityName, forKey: "location.cityName") }
    }
    var latitude: Double? {
        didSet {
            if let latitude { UserDefaults.standard.set(latitude, forKey: "location.latitude") }
            else { UserDefaults.standard.removeObject(forKey: "location.latitude") }
        }
    }
    var longitude: Double? {
        didSet {
            if let longitude { UserDefaults.standard.set(longitude, forKey: "location.longitude") }
            else { UserDefaults.standard.removeObject(forKey: "location.longitude") }
        }
    }
    var preferredLocale: Locale = .current

    private(set) var lastGeocodedLocale: String? {
        didSet { UserDefaults.standard.set(lastGeocodedLocale, forKey: "location.lastGeocodedLocale") }
    }

    var hasLocation: Bool { latitude != nil && longitude != nil }

    var needsLocaleUpdate: Bool {
        lastGeocodedLocale != preferredLocale.identifier
    }

    init() {
        restoreLocation()
    }

    private func restoreLocation() {
        let defaults = UserDefaults.standard
        cityName = defaults.string(forKey: "location.cityName")
        lastGeocodedLocale = defaults.string(forKey: "location.lastGeocodedLocale")
        if defaults.object(forKey: "location.latitude") != nil {
            latitude = defaults.double(forKey: "location.latitude")
            longitude = defaults.double(forKey: "location.longitude")
            logger.info("Restored saved location: \(self.cityName ?? "nil") (\(self.latitude ?? 0), \(self.longitude ?? 0))")
        }
    }

    func resolveFromDeviceRegion() async {
        guard !hasLocation else { return }
        guard let regionCode = Locale.current.region?.identifier else {
            logger.warning("No device region available")
            return
        }
        let locale = preferredLocale
        let countryName = Locale(identifier: locale.identifier).localizedString(forRegionCode: regionCode) ?? regionCode
        logger.info("Resolving location from device region: \(regionCode) (\(countryName))")
        _ = await geocodeCity(countryName, locale: locale)
    }

    func reverseGeocode(latitude: Double, longitude: Double) async {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        guard let request = MKReverseGeocodingRequest(location: location) else {
            logger.error("Failed to create reverse geocoding request")
            return
        }
        request.preferredLocale = preferredLocale
        do {
            let mapItems = try await request.mapItems
            if let item = mapItems.first {
                let resolved = Self.formatCityName(from: item, locale: preferredLocale)
                let locale = preferredLocale
                await MainActor.run {
                    cityName = resolved
                    lastGeocodedLocale = locale.identifier
                }
                logger.info("Reverse geocoded to: \(resolved ?? "nil") with locale \(locale.identifier)")
            }
        } catch {
            logger.error("Reverse geocode error: \(error.localizedDescription)")
        }
    }

    func geocodeCity(_ name: String, locale: Locale = .current) async -> Bool {
        logger.info("Geocoding city: \(name)")
        guard let request = MKGeocodingRequest(addressString: name) else {
            logger.error("Failed to create geocoding request for: \(name)")
            return false
        }
        request.preferredLocale = locale
        do {
            let mapItems = try await request.mapItems
            logger.info("Geocode returned \(mapItems.count) results")
            if let item = mapItems.first {
                let coord = item.location.coordinate
                let resolved = Self.formatCityName(from: item, locale: locale)
                logger.info("Resolved to: \(resolved ?? "nil") at \(coord.latitude), \(coord.longitude)")
                await MainActor.run {
                    latitude = coord.latitude
                    longitude = coord.longitude
                    cityName = resolved ?? name
                    lastGeocodedLocale = locale.identifier
                }
                return true
            }
        } catch {
            logger.error("Geocode error: \(error.localizedDescription)")
        }
        return false
    }

    private static func formatCityName(from item: MKMapItem, locale: Locale) -> String? {
        if let short = item.address?.shortAddress, !short.isEmpty {
            let parts = short.components(separatedBy: ", ")
            if parts.count > 2 {
                return parts.suffix(2).joined(separator: ", ")
            }
            return short
        }
        return item.name
    }
}
