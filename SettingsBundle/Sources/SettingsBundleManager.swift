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
//	ID: 0D54B58E-0BF4-484F-83E3-78CAE4A9B720
//
//	Pkg: SettingsBundle
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation

struct SettingsBundleManager {
	
	public static let shared = SettingsBundleManager()
	
	struct SettingsBundleKeys {
		static let Reset = "RESET_APP_KEY"
		static let BuildVersionKey = "build_preference"
		static let AppVersionKey = "version_preference"
		static let RedThemeKey = "RedThemeKey"
		
	}
	
	func checkAndExecuteSettings() {
		if UserDefaults.standard.bool(forKey: SettingsBundleKeys.Reset) {
			UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Reset)
			let appDomain: String? = Bundle.main.bundleIdentifier
			UserDefaults.standard.removePersistentDomain(forName: appDomain!)
			// reset userDefaults..
			// CoreDataDataModel().deleteAllData()
			// delete all other user data here..
		}
	}
	
	func setVersionAndBuildNumber() {
		let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
		UserDefaults.standard.set(version, forKey: "version_preference")
		let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
		UserDefaults.standard.set(build, forKey: "build_preference")
	}
}
