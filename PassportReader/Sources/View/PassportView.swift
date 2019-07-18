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
//	ID: 77AE04CF-2DC1-467C-915E-9C8A635A728A
//
//	Pkg: PassportReader
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import SwiftUI

// Outline view of passport
struct PassportView : View {
	@EnvironmentObject var passportDetails: PassportDetails
	var body: some View {
		HStack {
			if (self.passportDetails.passport) != nil {
				
				ZStack(alignment: .bottomTrailing) {
					PassportDetailsView(passport: passportDetails.passport!)
					
					HStack {
						if !passportDetails.passport!.passportDataValid {
							VStack {
								Image( systemName:"exclamationmark").foregroundColor(.red)
									.font(.system(size: 50))
									.padding(.bottom, 5)
								
								Text( "Tampered")
									.font(.caption)
									.color(.red)
							}
							
						}
						VStack(alignment: .center) {
							if passportDetails.passport!.passportSigned {
								Image( systemName:"checkmark.seal").foregroundColor(.green)
									.font(.system(size: 50))
									.padding(.bottom, 5)
								Text( "Genuine")
									.font(.caption)
									.color(.green)
							} else {
								Image( systemName:"xmark.seal").foregroundColor(.red)
									.font(.system(size: 50))
									.padding([.leading,.trailing], 15)
									.padding(.bottom, 5)
								Text( "Not Genuine")
									.font(.caption)
									.color(.red)
									.frame(minWidth: 0, maxWidth: 100, minHeight: 0, maxHeight: 22)
							}
						}
						
					}.padding( [.trailing, .bottom], 10)
				}
			} else {
				Text( "No Passport set")
			}
		}
		.background(Image( "background" ).blur(radius:10))
			.cornerRadius(10)
			.shadow(radius: 20)
		
	}
}


// Shows the Pzssport details
struct PassportDetailsView : View {
	var passport: Passport
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading) {
				Spacer()
				Image(uiImage:passport.image)
					.resizable()
					.renderingMode(.original)
					.aspectRatio(contentMode: .fit)
					.frame(width: 120, height: 180)
					.padding([.leading], 10.0)
				Spacer()
			}
			VStack(alignment: .leading) {
				Spacer()
				HStack {
					Text( passport.documentType)
					Spacer()
					Text( passport.issuingAuthority)
					Spacer()
					Text( passport.documentNumber)
				}
				Text( passport.lastName)
				Text( passport.firstName)
				Text( passport.nationality)
				Text( passport.dateOfBirth)
				Text( passport.gender)
				Text( passport.documentExpiryDate )
				
				Spacer()
			}.padding([.trailing], 10.0)
		}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
	}
}


#if DEBUG
struct PassportView_Previews : PreviewProvider {
	static var previews: some View {
		let pptData = "P<GBRTEST<<TEST<TEST<<<<<<<<<<<<<<<<<<<<<<<<1234567891GBR8001019M2106308<<<<<<<<<<<<<<04"
		let passport = Passport( passportMRZData: pptData, image:UIImage(named: "head")!, signed: false, dataValid: false )
		let pd = PassportDetails()
		pd.passport = passport
		
		return Group {
			PassportView()
				.environment( \.colorScheme, .light)
			
		}.frame(width: UIScreen.main.bounds.width-10, height: 220)
			.environmentObject(pd)
	}
}
#endif

