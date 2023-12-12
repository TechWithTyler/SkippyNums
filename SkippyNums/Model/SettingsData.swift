//
//  SettingsData.swift
//  SkippyNums
//
//  Created by Tyler Sheft on 8/1/23.
//  Copyright © 2023 SheftApps. All rights reserved.
//

import Foundation

struct SettingsData {
    
    // MARK: - 5-Frame/10-Frame Settings Data

    // Whether the game uses a 10-frame (true - 2 rows of 5 images) or 5-frame (false - 1 row of 5 images) layout.
	var tenFrame: Bool {
		get {
			return UserDefaults.standard.bool(forKey: "tenFrame")
		} set {
			UserDefaults.standard.set(newValue, forKey: "tenFrame")
		}
	}

}
