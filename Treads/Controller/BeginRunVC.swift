
import UIKit
import MapKit

class BeginRunVC: LocationVC {
  
  // Outlets
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkLocationAuthStatus()
    mapView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    locationManager?.delegate = self
    locationManager?.startUpdatingLocation()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    locationManager?.stopUpdatingLocation()
  }
  
  @IBAction func onCenterLocationBtnPressed(_ sender: Any) {
    
  }
  
}

extension BeginRunVC: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      checkLocationAuthStatus()
      mapView.showsUserLocation = true
      mapView.userTrackingMode = .follow
      
    }
  }
  
}

