//
//  Object.swift
//  Skipy
//
//  Created by Tyler Sheft on 2/13/23.
//

import UIKit

protocol Object {

	var displayPluralName: String { get }

	var imageName: String { get }

	var quantity: Int { get }

	var attributionText: String? { get }

	var soundFilename: String { get }

}

struct Cow: Object {
	
	var displayPluralName: String = "cows"

	var imageName: String = "cows.svg"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "moo.caf"
	
}

struct Elephant: Object {

	var displayPluralName: String = "elephants"

	var imageName: String = "elephants.svg"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "elephantTrumpet.caf"

}

struct Car: Object {

	var displayPluralName: String = "cars"

	var imageName: String = "cars.svg"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "carHorn.caf"

}

