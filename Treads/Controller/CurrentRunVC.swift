
import UIKit

class CurrentRunVC: LocationVC {
  
  // Outlets
  @IBOutlet weak var swipeBgImgView: UIImageView!
  @IBOutlet weak var sliderImgView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwipe(_:)))
    sliderImgView.addGestureRecognizer(swipeGesture)
    sliderImgView.isUserInteractionEnabled = true
    swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    
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
