//
//  Object.swift
//  Skippy
//
//  Created by TechWithTyler on 2/13/23.
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

	var imageName: String = "elephants.png"

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

struct Airplane: Object {

	var displayPluralName: String = "airplanes"

	var imageName: String = "airplanes.svg"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "airplane.caf"

}

struct Bear: Object {

	var displayPluralName: String = "bears"

	var imageName: String = "bears.svg"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "bear.caf"

}

struct Monkey: Object {

	var displayPluralName: String = "monkeys"

	var imageName: String = "monkeys.svg"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "monkey.caf"

}

struct Robot: Object {

	var displayPluralName: String = "robots"

	var imageName: String = "robots.svg"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "robot.caf"

}
