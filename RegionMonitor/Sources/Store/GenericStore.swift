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
//	ID: 2C0B07D0-9585-4C00-B2FD-BCC7BC17AE4A
//
//	Pkg: RegionMonitor
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation

class GenericStore<T: NSObject> {
	
	private(set) internal var storedItems = [T]()
	
	let storeItemsKey: String
	let storeItemsDidChangeNotification: String
	
	init(storeItemsKey: String, storeItemsDidChangeNotification: String) {
		self.storeItemsKey = storeItemsKey
		self.storeItemsDidChangeNotification = storeItemsDidChangeNotification
		loadStoredItems()
	}
}

// MARK: -
extension GenericStore {
	func addStoredItem(_ item: T) {
		storedItems.append(item)
		saveStoredItems()
	}
	
	func removeStoredItem(_ item: T) {
		storedItems.remove(at: indexForItem(item))
		saveStoredItems()
	}
	
	func indexForItem(_ item: T) -> Int {
		var index = -1
		for storedItem in storedItems {
			if storedItem == item {
				break
			}
			index += 1
		}
		return index
	}
}


// MARK: -
private extension GenericStore {
	private func loadStoredItems() {
		storedItems = []
		if let items = UserDefaults.standard.array(forKey: storeItemsKey) {
			for item in items {
				if let storedItem = NSKeyedUnarchiver.unarchiveObject(with: item as! Data) as? T {
					storedItems.append(storedItem)
				}
			}
		}
		NotificationCenter.default.post(name: Notification.Name(rawValue: storeItemsDidChangeNotification), object: nil)
	}
	
	private func saveStoredItems() {
		let items = NSMutableArray()
		for storedItem in storedItems {
			let item = NSKeyedArchiver.archivedData(withRootObject: storedItem)
			items.add(item)
		}
		NotificationCenter.default.post(name: Notification.Name(rawValue: storeItemsDidChangeNotification), object: nil)
		UserDefaults.standard.set(items, forKey: storeItemsKey)
		UserDefaults.standard.synchronize()
	}
}
