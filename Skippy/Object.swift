//
//  Object.swift
//  Skipy
//
//  Created by Tyler Sheft on 2/13/23.
//

import Foundation

protocol Object {

	var displayPluralName: String { get set }

	var imageName: String { get set }

	var quantity: Int { get set }

	var attributionText: String? { get set }

}

struct Cherry: Object {
	
	var displayPluralName: String = "cherries"

	var imageName: String = "cherries.svg"

	var quantity: Int = 2

	var attributionText: String? = nil

}
