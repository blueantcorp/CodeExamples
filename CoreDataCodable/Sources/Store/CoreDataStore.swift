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
//	ID: 5D1E5605-4719-4647-A1FC-A9971C9DF133
//
//	Pkg: CoreDataCodable
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation
import CoreData

class CoreDataStore {
	
	public static let shared = CoreDataStore()
	
	// Core Data stack
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Post")
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
	// Context
	var context: NSManagedObjectContext {
		let context = persistentContainer.viewContext
		context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		return context
	}
	
	// Core Data Saving support
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}

// MARK: -
extension CoreDataStore {
	
	func insertItem<T>() -> T {
		return NSEntityDescription.insertNewObject(forEntityName: "\(T.self)", into: context) as! T
	}
	
	func fetchItems<T>(predicate: String? = nil) -> [T] {
		
		let itemsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(T.self)")
		
		if let predicate = predicate {
			itemsFetchRequest.predicate = NSPredicate(format: predicate)
		}
		
		return try! context.fetch(itemsFetchRequest) as! [T]
	}
	
	func deteleItem(_ entity: NSManagedObject) {
		context.delete(entity)
		try! context.save()
	}
	
	func deleteAll<T>(_ entity: T) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(entity)")
		let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		try! context.execute(batchDeleteRequest)
		try! context.save()
	}
}
