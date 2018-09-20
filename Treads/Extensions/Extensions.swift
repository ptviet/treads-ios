
import UIKit

extension Double {
  
  func meterToKm(places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return ((self / 1000) * divisor ).rounded() / divisor
  }
  
}

extension Int {
  
  func formatTimeDurationToString() -> String {
    let hours = self / 3600
    let minutes = (self % 3600) / 60
    let seconds = (self % 3600) % 60
    
    if seconds < 0 {
      return "00:00:00"
    } else {
      if hours == 0 {
        return String(format: "%02d:%02d", minutes, seconds)
      } else {
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
      }
    }
  }
  
}

extension NSDate {
  func getDateString() -> String {
    let calendar = Calendar.current
    let day = calendar.component(.day, from: self as Date)
    let month = calendar.component(.month, from: self as Date)
    let year = calendar.component(.year, from: self as Date)
    
    return "\(day)/\(month)/\(year)"
  }
}
