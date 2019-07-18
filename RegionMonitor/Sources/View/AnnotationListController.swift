//	MIT License
//
//	Copyright © 2019 Emile, Blue Ant Corp
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
//	ID: 39DD98C4-7919-42C8-B579-9D5CE07CC279
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

let RegionAnnotationsTableViewCellId = "RegionAnnotationsTableViewCell"

class AnnotationListController: UITableViewController {
	
	var regionAnnotations: [Annotation]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Monitored Regions", comment: "Monitored Regions")
		
		regionAnnotations = AnnotationStore.shared.storedItems
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(AnnotationListController.regionAnnotationItemsDidChange(_:)),
											   name: NSNotification.Name(rawValue: RegionAnnotationItemsDidChangeNotification),
											   object: nil)
	}
}

// MARK: - Segues
extension AnnotationListController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == RegionAnnotationSettingsDetailSegue {
			let cell = sender as? UITableViewCell
			let indexPath = tableView.indexPath(for: cell!)
			let regionAnnotation = regionAnnotations?[(indexPath! as NSIndexPath).row]
			let regionAnnotationSettingsDetailVC = segue.destination as? AnnotationDetailController
			regionAnnotationSettingsDetailVC?.regionAnnotation = regionAnnotation
		}
	}
}

// MARK: - NSNotificationCenter Events
extension AnnotationListController {
	@objc func regionAnnotationItemsDidChange(_ notification: Notification) {
		regionAnnotations = AnnotationStore.shared.storedItems
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

// MARK: - Actions
extension AnnotationListController {
	@IBAction func editButtonTapped(_ sender: AnyObject) {
		tableView.isEditing = !tableView.isEditing
	}
}

// MARK: - UITableViewDataSource
extension AnnotationListController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if regionAnnotations != nil {
			return regionAnnotations!.count
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: RegionAnnotationsTableViewCellId, for: indexPath)
		let row = (indexPath as NSIndexPath).row
		let regionAnnotation = regionAnnotations?[row]
		cell.textLabel?.text = regionAnnotation?.subtitle
		cell.detailTextLabel?.text = String(format: NSLocalizedString("Region \(row+1)", comment: "Region {number}"));
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			regionAnnotations?.remove(at: (indexPath as NSIndexPath).row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		default:
			return
		}
	}
}
