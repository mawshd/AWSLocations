import Foundation
import CoreLocation

public struct AWSLocation {
    var postcode : String?
    var city : String?
    var country : String?
    var country_short : String?
    var latitude : Double?
    var longitude : Double?
    var address : String?
}

public extension AWSLocation {
    var coordinates : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0)
    }
}

public extension CLLocationCoordinate2D {
    var location : CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension CLPlacemark {
    var _location : AWSLocation {
        
        
        var components = [String]()
        if let subThroughFare = self.subThoroughfare, !subThroughFare.isEmpty {
            components.append(subThroughFare)
        }
        if let throughFare = self.thoroughfare, !throughFare.isEmpty {
            components.append(throughFare)
        }
        if let subLocality = self.subLocality, !subLocality.isEmpty {
            components.append(subLocality)
        }
        if let locality = self.locality, !locality.isEmpty {
            components.append(locality)
        }
        
        var loc = AWSLocation()
        loc.address = components.joined(separator:", ")
        loc.city = self.locality ?? ""
        loc.latitude = self.location?.coordinate.latitude
        loc.longitude = self.location?.coordinate.longitude
        loc.postcode = self.postalCode
        loc.country = self.country
        
        return loc
    }
}

struct LOCATION_KEYS {
    static var LATITUDE = "awsLatitude"
    static var LONGITUDE = "awsLongitude"
    static var ADDRESS = "awsAddress"
    static var CITY = "awsCity"
    static var COUNTRY = "awsCountry"
    static var POSTALCODE = "awsPostalCode"
}


extension UserDefaults {
    
    var city : String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "awsCity")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: "awsCity") as? String
        }
    }
    
    var country : String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "awsCountry")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: "awsCountry") as? String
        }
    }
    
    var address : String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "awsAddress")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.value(forKey: "awsAddress") as? String
        }
    }
    
    var latitude : Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: "awsLatitude")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.double(forKey: "awsLatitude")
        }
    }
    
    var longitude : Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: "awsLongitude")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.double(forKey: "awsLongitude")
        }
    }
}

