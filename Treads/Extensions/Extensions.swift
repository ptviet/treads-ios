
import UIKit

extension Double {
  
  func metertoKm(places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return ((self / 1000) * divisor ).rounded() / divisor
  }
  
}
