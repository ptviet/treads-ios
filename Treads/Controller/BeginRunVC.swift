
import UIKit
import MapKit

class BeginRunVC: LocationVC {
  
  // Outlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var lastRunCloseBtn: UIButton!
  @IBOutlet weak var paceLbl: UILabel!
  @IBOutlet weak var distanceLbl: UILabel!
  @IBOutlet weak var durationLbl: UILabel!
  @IBOutlet weak var lastRunView: UIView!
  @IBOutlet weak var lastRunStack: UIStackView!
  
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
    getLastRun()
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
  
  func getLastRun() {
    guard let lastRun = Run.getAllRuns()?.first else {
      lastRunView.isHidden = true
      lastRunStack.isHidden = true
      lastRunCloseBtn.isHidden = true
      
      return
    }
    
    paceLbl.text = "\(lastRun.pace.formatTimeDurationToString()) km/h"
    distanceLbl.text = "\(lastRun.distance.meterToKm(places: 2)) km"
    durationLbl.text = lastRun.duration.formatTimeDurationToString()
    
    lastRunView.isHidden = false
    lastRunStack.isHidden = false
    lastRunCloseBtn.isHidden = false
    
  }
  
  @IBAction func onLastRunCloseBtnPressed(_ sender: Any) {
    lastRunView.isHidden = true
    lastRunStack.isHidden = true
    lastRunCloseBtn.isHidden = true
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

