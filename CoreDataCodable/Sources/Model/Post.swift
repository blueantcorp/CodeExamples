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
		case id, identifier, title, descr, image, published, visible
	}
	
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
			self.id = Int16(try container.decodeIfPresent(String.self, forKey: .id) ?? "")
			self.identifier = try container.decodeIfPresent(UUID.self, forKey: .identifier)
			self.title = try container.decodeIfPresent(String.self, forKey: .title)
			self.descr = try container.decodeIfPresent(String.self, forKey: .descr)
			self.image = try container.decodeIfPresent(String.self, forKey: .image)
			self.published = try container.decodeIfPresent(String.self, forKey: .published)?.toDate()
			self.visible = try container.decodeIfPresent(Bool.self, forKey: .visible)
		} catch (let error) {
			fatalError(error.localizedDescription)
		}
	}
	
	// Encodable
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(identifier, forKey: .identifier)
		try container.encode(title, forKey: .title)
		try container.encode(descr, forKey: .descr)
		try container.encode(image, forKey: .image)
		try container.encode(published, forKey: .published)
		try container.encode(visible, forKey: .visible)
	}
}

// MARK: - Properties
extension Post {
	
	//  @NSManaged replacement for optionals
	public var id: Int16? {
		get {
			willAccessValue(forKey: "id")
			defer {didAccessValue(forKey: "id")}
			return primitiveValue(forKey: "id") as? Int16
		}
		set {
			willChangeValue(forKey: "id")
			defer {didChangeValue(forKey: "id")}
			guard let value = newValue else {
				setPrimitiveValue(nil, forKey: "id")
				return
			}
			setPrimitiveValue(value, forKey: "id")
		}
	}
	
	//  @NSManaged replacement for optionals
	public var identifier: UUID? {
		get {
			willAccessValue(forKey: "identifier")
			defer {didAccessValue(forKey: "identifier")}
			return primitiveValue(forKey: "identifier") as? UUID
		}
		set {
			willChangeValue(forKey: "identifier")
			defer {didChangeValue(forKey: "identifier")}
			guard let value = newValue else {
				setPrimitiveValue(nil, forKey: "identifier")
				return
			}
			setPrimitiveValue(value, forKey: "identifier")
		}
	}
	
	@NSManaged var title: String?
	@NSManaged var descr: String?
	@NSManaged var image: String?
	
	// @NSManaged replacement for optionals
	public var published: Date? {
		get {
			willAccessValue(forKey: "published")
			defer {didAccessValue(forKey: "published")}
			return primitiveValue(forKey: "published") as? Date
		}
		set {
			willChangeValue(forKey: "published")
			defer {didChangeValue(forKey: "published")}
			guard let value = newValue else {
				setPrimitiveValue(nil, forKey: "published")
				return
			}
			setPrimitiveValue(value, forKey: "published")
		}
	}
	
	// @NSManaged replacement for optionals
	public var visible: Bool? {
		get {
			willAccessValue(forKey: "visible")
			defer {didAccessValue(forKey: "visible")}
			return primitiveValue(forKey: "visible") as? Bool
		}
		set {
			willChangeValue(forKey: "visible")
			defer {didChangeValue(forKey: "visible")}
			guard let value = newValue else {
				setPrimitiveValue(nil, forKey: "visible")
				return
			}
			setPrimitiveValue(value, forKey: "visible")
		}
	}
}
