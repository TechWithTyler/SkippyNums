//
//  Object.swift
//  SkippyNums
//
//  Created by TechWithTyler on 2/13/23.
//

import Foundation

// MARK - Object Protocol

protocol Object {

	var name: String { get }

	var quantity: Int { get }

	var attributionText: String? { get }

	var soundFilename: String { get }

	var soundRate: Float { get }

}

// MARK: - Twos

struct Cow: Object {
	
	var name: String = "cows"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "moo.caf"

	var soundRate: Float = 2
	
}

struct Elephant: Object {

	var name: String = "elephants"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "elephantTrumpet.caf"

	var soundRate: Float = 2.5

}

struct Car: Object {

	var name: String = "cars"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "carHorn.caf"

	var soundRate: Float = 2.5

}

// MARK: - Fives

struct Airplane: Object {

	var name: String = "airplanes"

	var quantity: Int = 5

	var attributionText: String? = nil

	var soundFilename: String = "airplane.caf"

	var soundRate: Float = 5

}

// MARK: - Twos or Fives

struct Bear: Object {

	var name: String = "bears"

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "bear.caf"

	var soundRate: Float = 1.5

}

struct Monkey: Object {

	var name: String {
		return "\(quantity)monkeys"
	}

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "monkey.caf"

	var soundRate: Float = 1.5

}

struct Robot: Object {

	var name: String {
		return "\(quantity)robots"
	}

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "robot.caf"

	var soundRate: Float = 1.5

}

struct Bird: Object {

	var name: String {
		return "\(quantity)birds"
	}

	var quantity: Int = 2

	var attributionText: String? = nil

	var soundFilename: String = "bird.caf"

	var soundRate: Float = 1

}
