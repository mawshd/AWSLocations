import Foundation
import CoreLocation

public class AWSLocationsUtils : NSObject, CLLocationManagerDelegate {
    
    public static let shared = AWSLocationsUtils()
    public static var distanceFilter = 25.0
    public static var alwaysRequired = false

    private var locationManager : CLLocationManager?
    public fileprivate (set) var permission : (granted : Bool, status : String) = (false, "not configured")
    fileprivate var trackLocations: ((_ location : CLLocation) -> ())? = nil
    
    private let defults = UserDefaults.standard
    
    public fileprivate (set) var latitude : Double {
        get { return defults.latitude ?? 0.0 }
        set { defults.latitude = newValue }
    }
    
    public fileprivate (set) var longitude : Double {
        get { return defults.longitude ?? 0.0 }
        set { defults.longitude = newValue }
    }
    
    public fileprivate (set) var address : String {
        get { return defults.address ?? "" }
        set { defults.address = newValue }
    }
    
    public fileprivate (set) var city : String {
        get { return defults.city ?? "" }
        set { defults.city = newValue }
    }
    
    public fileprivate (set) var location : CLLocation {
        get { return CLLocation(latitude: latitude, longitude: longitude) }
        set {  }
    }
    
    private override init() {
        super.init()
        registerForLocationServices()
    }
    
    private func registerForLocationServices() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.distanceFilter = AWSLocationsUtils.distanceFilter
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        if AWSLocationsUtils.alwaysRequired {
            locationManager?.requestAlwaysAuthorization()
            locationManager?.allowsBackgroundLocationUpdates = true
            locationManager?.pausesLocationUpdatesAutomatically = false
        }
        else {
            locationManager?.requestWhenInUseAuthorization()
        }
        startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingHeading()
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingHeading()
        locationManager?.stopUpdatingLocation()
    }
    
    public func trackLocationChanges(updatedLocation: @escaping(_ loc:CLLocation)->Void ) {
        trackLocations = updatedLocation
    }
    
    fileprivate func setUpAWSLocation(placemark : CLPlacemark) {
        var components = [String]()
        if let subThroughFare = placemark.subThoroughfare, !subThroughFare.isEmpty {
            components.append(subThroughFare)
        }
        if let throughFare = placemark.thoroughfare, !throughFare.isEmpty {
            components.append(throughFare)
        }
        if let subLocality = placemark.subLocality, !subLocality.isEmpty {
            components.append(subLocality)
        }
        if let locality = placemark.locality, !locality.isEmpty {
            components.append(locality)
        }
        
        self.address = components.joined(separator:", ")
        self.city = placemark.locality ?? ""
    }
    
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        setupLocationByApple(location: manager.location!)
        trackLocations?(location)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        permission.granted = false
        
        switch status {
        case .restricted:
            permission.status = "restricted"
        case .denied:
            permission.status = "denied"
        case .authorizedAlways:
            permission.granted = true
            permission.status = "authorized always"
        case .authorizedWhenInUse:
            permission.granted = true
            permission.status = "when in use"
        default:
            permission.status = "not determined"
        }
        
        if permission.granted {
            startUpdatingLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}


public extension AWSLocationsUtils {
    
    fileprivate func setupLocationByApple(location : CLLocation) {
        AWSLocationsUtils.reverseGeocodeByApple(location) { [weak self] (loc) in
            self?.city = loc.city ?? ""
            self?.address = loc.address ?? ""
        }
    }
    
    class func geocodeByApple (address: String, completion: @escaping (_ location: AWSLocation) -> Void) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                completion(placemark._location)
                return
            }
            print(error?.localizedDescription ?? "")
        })
    }
    
    class func reverseGeocodeByApple (_ location:CLLocation, completion: @escaping (_ location: AWSLocation) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                completion(placemark._location)
                return
            }
            print(error?.localizedDescription ?? "")
        })
    }
}


