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
//	ID: 62837E72-0E8A-473C-9CAD-6221361D6AA3
//
//	Pkg: CoreDataCodable
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation

struct PostViewModel: Equatable {
	let identifier: UUID
	let title: String
	let descr: String
	let image: String
	let published: Date
	let visible: Bool
	
	init(_ post: Post) {
		identifier = post.identifier
		title = post.title
		descr = post.descr
		image = post.image
		published = post.published
		visible = post.visible
	}
}

func ==(lhs: PostViewModel, rhs: PostViewModel) -> Bool {
	return lhs.identifier == rhs.identifier
		&& lhs.title == rhs.title
		&& lhs.descr == rhs.descr
		&& lhs.image == rhs.image
		&& lhs.published == rhs.published
		&& lhs.visible == rhs.visible
}
