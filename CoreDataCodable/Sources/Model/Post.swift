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
//	ID: 8C26602B-005F-4DB9-97F6-D7AB964E8F37
//
//	Pkg: CoreDataCodable
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation
import CoreData

class Post: NSManagedObject, Codable {
	
	// Codable keys
	enum CodingKeys: String, CodingKey {
		case heading, published, visible
	}
	
	// Core Data Managed Object
	@NSManaged var heading: String?
	@NSManaged var published: Date
	@NSManaged var visible: Bool
	
	// Decodable
	required convenience init(from decoder: Decoder) throws {
		
		// CoreData
		guard let ccontext = CodingUserInfoKey.context,
			let managedContext = decoder.userInfo[ccontext] as? NSManagedObjectContext,
			let entity = NSEntityDescription.entity(forEntityName: "Post", in: managedContext) else {
				fatalError("Failed to decode User")
		}
		
		self.init(entity: entity, insertInto: managedContext)
		
		// Decodable
		do {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.heading = try container.decodeIfPresent(String.self, forKey: .heading)
			self.published = try container.decodeIfPresent(Date.self, forKey: .published)!
			self.visible = try container.decodeIfPresent(Bool.self, forKey: .visible)!
		} catch (let error) {
			fatalError(error.localizedDescription)
		}
	}
	
	// Encodable
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(heading, forKey: .heading)
		try container.encode(published, forKey: .published)
		try container.encode(visible, forKey: .visible)
	}
}
