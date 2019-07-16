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
//	ID: 257334F8-B606-4FAD-9AEA-DD03A5ED5D51
//
//	Pkg: CoreDataCodable
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation
import CoreData

typealias FetchItemsCompletionBlock = (_ success: Bool, _ error: NSError?) -> Void

// MARK: - PostControllerProtocol
protocol PostControllerProtocol {
	
	var items: [PostViewModel?]? { get }
	var itemCount: Int { get }
	
	func item(at index: Int) -> PostViewModel?
	func fetchItems(_ completionBlock: @escaping FetchItemsCompletionBlock)
}

extension PostControllerProtocol {
	
	var items: [PostViewModel?]? {
		return items
	}
	
	var itemCount: Int {
		return items?.count ?? 0
	}
	
	func item(at index: Int) -> PostViewModel? {
		guard index >= 0 && index < itemCount else { return nil }
		return items?[index] ?? nil
	}
}

// MARK: - PostController
class PostController: PostControllerProtocol {
	
	private static let pageSize = 25
	private static let entityName = "Post"
	
	private let persistentContainer: NSPersistentContainer
	
	private var currentPage = -1
	private var lastPage = -1
	private var fetchItemsCompletionBlock: FetchItemsCompletionBlock?
	
	var items: [PostViewModel?]? = []
	
	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}
	
	func fetchItems(_ completionBlock: @escaping FetchItemsCompletionBlock) {
		fetchItemsCompletionBlock = completionBlock
		loadNextPageIfNeeded(for: 0)
	}
	
	func item(at index: Int) -> PostViewModel? {
		guard index >= 0 && index < itemCount else { return nil }
		loadNextPageIfNeeded(for: index)
		return items?[index] ?? nil
	}
}

// MARK: -
private extension PostController {
	
	static func initViewModels(_ posts: [Post?]) -> [PostViewModel?] {
		return posts.map { post in
			if let post = post {
				return PostViewModel(post)
			} else {
				return nil
			}
		}
	}
}

// MARK: -
private extension PostController {

	func parse(_ jsonData: Data) -> Bool {
		do {
			guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.context else {
				fatalError("Failed to retrieve managed object context")
			}
			
			// Clear storage and save managed object instances
			if currentPage == 0 {
				clearStorage()
			}
			
			// Parse JSON data
			let managedObjectContext = persistentContainer.viewContext
			let decoder = JSONDecoder()
			decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
			_ = try decoder.decode([Post].self, from: jsonData)
			try managedObjectContext.save()
			
			return true
		} catch let error {
			print(error)
			return false
		}
	}
}

// MARK: -
private extension PostController {
	
	func fetchFromStorage() -> [Post]? {
		
		let managedObjectContext = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<Post>(entityName: PostController.entityName)
		
		do {
			let users = try managedObjectContext.fetch(fetchRequest)
			return users
		} catch let error {
			print(error)
			return nil
		}
	}

}

// MARK: -
private extension PostController {
	
	func clearStorage() {
		let isInMemoryStore = persistentContainer.persistentStoreDescriptions.reduce(false) {
			return $0 ? true : $1.type == NSInMemoryStoreType
		}
		
		let managedObjectContext = persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: PostController.entityName)
		
		// NSBatchDeleteRequest is not supported for in-memory stores
		if isInMemoryStore {
			do {
				let users = try managedObjectContext.fetch(fetchRequest)
				for user in users {
					managedObjectContext.delete(user as! NSManagedObject)
				}
			} catch let error as NSError {
				print(error)
			}
		} else {
			let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
			do {
				try managedObjectContext.execute(batchDeleteRequest)
			} catch let error as NSError {
				print(error)
			}
		}
	}
}

// MARK: -
private extension PostController {
	
	func loadNextPageIfNeeded(for index: Int) {
		let targetCount = currentPage < 0 ? 0 : (currentPage + 1) * PostController.pageSize - 1
		guard index == targetCount else {
			return
		}
		currentPage += 1
		let id = currentPage * PostController.pageSize + 1
		let urlString = String(format: "https://aqueous-temple-22443.herokuapp.com/users?id=\(id)&count=\(PostController.pageSize)")
		guard let url = URL(string: urlString) else {
			fetchItemsCompletionBlock?(false, nil)
			return
		}
		let session = URLSession.shared
		let task = session.dataTask(with: url) { [weak self] (data, response, error) in
			guard let strongSelf = self else { return }
			guard let jsonData = data, error == nil else {
				DispatchQueue.main.async {
					strongSelf.fetchItemsCompletionBlock?(false, error as NSError?)
				}
				return
			}
			strongSelf.lastPage += 1
			if strongSelf.parse(jsonData) {
				if let users = strongSelf.fetchFromStorage() {
					let newUsersPage = PostController.initViewModels(users)
					strongSelf.items?.append(contentsOf: newUsersPage)
				}
				DispatchQueue.main.async {
					strongSelf.fetchItemsCompletionBlock?(true, nil)
				}
			} else {
				DispatchQueue.main.async {
//					strongSelf.fetchItemsCompletionBlock?(false, NSError.createError(0, description: "JSON parsing error"))
				}
			}
		}
		task.resume()
	}
}
