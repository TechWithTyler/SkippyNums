//
//  SettingsData.swift
//  SkippyNums
//
//  Created by TechWithTyler on 8/1/23.
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
