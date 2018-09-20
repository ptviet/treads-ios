
import UIKit
import MapKit

class CurrentRunVC: LocationVC {
  
  // Outlets
  @IBOutlet weak var swipeBgImgView: UIImageView!
  @IBOutlet weak var sliderImgView: UIImageView!
  @IBOutlet weak var durationLbl: UILabel!
  @IBOutlet weak var paceLbl: UILabel!
  @IBOutlet weak var distanceLbl: UILabel!
  @IBOutlet weak var pauseBtn: UIButton!
  
  // Variables
  var startLocation: CLLocation!
  var lastLocation: CLLocation!
  var timer: Timer = Timer()
  var runDistance: Double = 0.0
  var counter: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwipe(_:)))
    sliderImgView.addGestureRecognizer(swipeGesture)
    sliderImgView.isUserInteractionEnabled = true
    swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    locationManager?.delegate = self
    locationManager?.distanceFilter = 5
    startRun()
  }
  
  func startRun() {
    locationManager?.startUpdatingLocation()
    startTimer()
  }
  
  func startTimer() {
    durationLbl.text = counter.formatTimeDurationToString()
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
  }
  
  @objc func updateCounter() {
    counter += 1
    durationLbl.text = counter.formatTimeDurationToString()
  }
  
  func endRun() {
    locationManager?.stopUpdatingLocation()
  }
  
  @IBAction func onPauseBtnPressed(_ sender: Any) {
    
  }
  
  @objc func endRunSwipe(_ sender: UIPanGestureRecognizer ) {
    let minAdjust: CGFloat = 75
    let maxAdjust: CGFloat = 128
    if let sliderView = sender.view {
      if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
        let translation = sender.translation(in: self.view)
        
        if sliderView.center.x >= (swipeBgImgView.center.x - minAdjust) && sliderView.center.x <= (swipeBgImgView.center.x + maxAdjust) {
          sliderView.center.x = sliderView.center.x + translation.x
        } else if sliderView.center.x >= (swipeBgImgView.center.x + maxAdjust) {
          sliderView.center.x = swipeBgImgView.center.x + maxAdjust
          // Run ends
          endRun()
          dismiss(animated: true, completion: nil)
        } else {
          sliderView.center.x = swipeBgImgView.center.x - minAdjust
        }
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        
      } else if sender.state == UIGestureRecognizer.State.ended {
        UIView.animate(withDuration: 0.1) {
          sliderView.center.x = self.swipeBgImgView.center.x - minAdjust
        }
      }
    }
  }
  
}

extension CurrentRunVC: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      checkLocationAuthStatus()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if startLocation == nil {
      startLocation = locations.first
    } else if let location = locations.last {
      runDistance += lastLocation.distance(from: location)
      distanceLbl.text = "\(runDistance.metertoKm(places: 2))"
    }
    lastLocation = locations.last
  }
  
}
