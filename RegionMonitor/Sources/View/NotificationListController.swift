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
//	ID: A634D686-87C6-4FF9-8B7F-9B444152C49F
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import UIKit

let RegionNotificationsTableViewCellId = "RegionNotificationsTableViewCell"

class NotificationListController: UITableViewController {
	
	var regionNotifications: [RegionNotification]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = NSLocalizedString("Region Notifications", comment: "Region Notifications")
		
		regionNotifications = NotificationStore.shared.storedItems
		regionNotifications?.sort(by: { $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 })
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(NotificationListController.regionNotificationsItemsDidChange(_:)),
											   name: NSNotification.Name(rawValue: RegionNotificationItemsDidChangeNotification),
											   object: nil)
	}
	
	// MARK: UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if regionNotifications != nil {
			return regionNotifications!.count
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 66.0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: RegionNotificationsTableViewCellId, for: indexPath) as! NotificationCell
		let row = (indexPath as NSIndexPath).row
		let regionNotification = regionNotifications?[row]
//		cell.timestamp.text = regionNotification?.displayTimestamp()
//		cell.status.text = regionNotification?.displayAppStatus()
//		cell.message.text = regionNotification?.message
//		cell.event.text = regionNotification?.displayEvent()
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		switch editingStyle {
		case .delete:
			regionNotifications?.remove(at: (indexPath as NSIndexPath).row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		default:
			return
		}
	}
	
	// MARK: NSNotificationCenter Events
	
	@objc func regionNotificationsItemsDidChange(_ notification: Notification) {
		regionNotifications = NotificationStore.shared.storedItems
		regionNotifications?.sort(by: { $0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970 })
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
}
