
import UIKit

class RunLogVC: UIViewController {
  
  // Outlets
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
}

extension RunLogVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Run.getAllRuns()?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "runLogCell", for: indexPath) as? RunLogCell {
      guard let run = Run.getAllRuns()?[indexPath.row] else {
        return RunLogCell()
      }
      cell.configureCell(run: run)
      return cell
    } else {
      return RunLogCell()
    }
  }

}

