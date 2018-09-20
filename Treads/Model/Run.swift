
import UIKit
import RealmSwift

class Run: Object {
  
  @objc dynamic public private(set) var id: String = ""
  @objc dynamic public private(set) var date: NSDate = NSDate()
  @objc dynamic public private(set) var pace: Int = 0
  @objc dynamic public private(set) var distance: Double = 0.0
  @objc dynamic public private(set) var duration: Int = 0
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  override class func indexedProperties() -> [String] {
    return ["date", "pace", "duration"]
  }
  
  convenience init(pace: Int, distance: Double, duration: Int) {
    self.init()
    self.id = UUID().uuidString.lowercased()
    self.date = NSDate()
    self.pace = pace
    self.distance = distance
    self.duration = duration
  }
  
}
