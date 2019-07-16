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
//	ID: 8E22663F-99D9-47C7-8693-0B49F79B2467
//
//	Pkg: CoreDataCodable
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation

class PostService {
	private let stubDataURL = "http://5d2dbfb843c343001498d42e.mockapi.io/api/v1/Post"
	public static var shared = PostService()
	
	public func fetchPosts(completion: @escaping (_ posts: [PostViewModel]?, _ error: Error?) -> Void) {
		get(stubDataURL) { posts, error in
			completion(posts, error)
		}
	}
	
	private func get(_ urlString: String, completion: @escaping (_ posts: [PostViewModel]?, _ error: Error?) -> Void) {
		guard let url = URL(string: urlString) else {
			return
		}
		
		let urlRequest = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
			
			let posts = try! JSONDecoder().decode([Post].self, from: data!)
			let result = posts.map { post in
				PostViewModel(post)
			}
			completion(result, nil)
		}
		task.resume()
	}
}
