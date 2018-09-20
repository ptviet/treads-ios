
import UIKit

class RunLogCell: UITableViewCell {

  // Outlets
  @IBOutlet weak var runDurationLbl: UILabel!
  @IBOutlet weak var distanceLbl: UILabel!
  @IBOutlet weak var avgPaceLbl: UILabel!
  @IBOutlet weak var dateLbl: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
      
    }
  
  func configureCell(run: Run) {
    runDurationLbl.text = run.duration.formatTimeDurationToString()
    distanceLbl.text = "\(run.distance.meterToKm(places: 2)) km"
    avgPaceLbl.text = run.pace.formatTimeDurationToString()
    dateLbl.text = run.date.getDateString()
  }

}
