
import UIKit
import MapKit
import RealmSwift

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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkLocationAuthStatus()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    mapView.delegate = self
    locationManager?.delegate = self
    locationManager?.startUpdatingLocation()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    setupMapView()
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
    mapView.userTrackingMode = .follow
    let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: REGION_RADIUS, longitudinalMeters: REGION_RADIUS)
    mapView.setRegion(coordinateRegion, animated: true)
    
  }
  
  func centerMapOnPrevRoute(locations: List<Location>) -> MKCoordinateRegion {
    guard let initialLocation = locations.first else { return MKCoordinateRegion() }
    var minLat = initialLocation.latitude
    var minLng = initialLocation.longitude
    var maxLat = minLat
    var maxLng = minLng
    
    for location in locations {
      minLat = min(minLat, location.latitude)
      minLng = min(minLng, location.longitude)
      maxLat = max(maxLat, location.latitude)
      maxLng = max(maxLng, location.longitude)
    }
    
    return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: ((minLat + maxLat)/2),
                                                             longitude: ((minLng + maxLng)/2)),
                              span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 2,
                                                     longitudeDelta: (maxLng - minLng) * 2)
    )
    
  }
  
  func setupMapView() {
    if let overlay = addLastRunToMap() {
      if mapView.overlays.count > 0 {
        mapView.removeOverlays(mapView.overlays)
      }
      mapView.addOverlay(overlay)
      lastRunView.isHidden = false
      lastRunStack.isHidden = false
      lastRunCloseBtn.isHidden = false
    } else {
      lastRunView.isHidden = true
      lastRunStack.isHidden = true
      lastRunCloseBtn.isHidden = true
      centerMapOnUserLocation()
    }
  }
  
  func addLastRunToMap() -> MKPolyline? {
    guard let lastRun = Run.getAllRuns()?.first else { return nil }
    paceLbl.text = "\(lastRun.pace.formatTimeDurationToString()) km/h"
    distanceLbl.text = "\(lastRun.distance.meterToKm(places: 2)) km"
    durationLbl.text = lastRun.duration.formatTimeDurationToString()
    
    var coordinates = [CLLocationCoordinate2D]()
    for location in lastRun.locations {
      coordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
    }
    
    mapView.userTrackingMode = .none
    mapView.setRegion(centerMapOnPrevRoute(locations: lastRun.locations), animated: true)
    
    return MKPolyline(coordinates: coordinates, count: lastRun.locations.count)
  }
  
  @IBAction func onLastRunCloseBtnPressed(_ sender: Any) {
    lastRunView.isHidden = true
    lastRunStack.isHidden = true
    lastRunCloseBtn.isHidden = true
    centerMapOnUserLocation()
  }
  
}

extension BeginRunVC: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      checkLocationAuthStatus()
      mapView.showsUserLocation = true
      
    }
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let polyline = overlay as! MKPolyline
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    renderer.lineWidth = 3
    return renderer
  }
  
}

