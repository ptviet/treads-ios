
import UIKit
import MapKit

class BeginRunVC: LocationVC {
  
  // Outlets
  @IBOutlet weak var mapView: MKMapView!
  
  // Variables
  let authStatus = CLLocationManager.authorizationStatus()
  let regionRadius: Double = 1000
  
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
    if authStatus == .authorizedWhenInUse {
      checkLocationAuthStatus()
      centerMapOnUserLocation()
    }
  }
  
  func centerMapOnUserLocation() {
    guard let coordinate = locationManager?.location?.coordinate else { return }
    let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
    
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

