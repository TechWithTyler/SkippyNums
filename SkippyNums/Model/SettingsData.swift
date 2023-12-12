//
//  SettingsData.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/1/23.
//  Copyright © 2023 SheftApps. All rights reserved.
//

import Foundation

struct SettingsData {

	var tenFrame: Bool {
		get {
			return UserDefaults.standard.bool(forKey: "tenFrame")
		} set {
			UserDefaults.standard.set(newValue, forKey: "tenFrame")
		}
	}

}
