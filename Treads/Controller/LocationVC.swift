
import UIKit
import MapKit

class LocationVC: UIViewController, MKMapViewDelegate {
  
  var locationManager: CLLocationManager?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager = CLLocationManager()
    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    locationManager?.activityType = .fitness
    
  }
  
  func checkLocationAuthStatus() {
    if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
      locationManager?.requestWhenInUseAuthorization()
    }
    
  }
  
  
}
