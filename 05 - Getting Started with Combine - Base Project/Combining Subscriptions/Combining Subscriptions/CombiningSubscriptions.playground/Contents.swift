import UIKit
import Combine

/*
 * Combine two publishers and validate any nil values remove it
 *
 */

let meals: Publishers.Sequence<[String?], Never> = ["🍔", "🌭", "🍕", nil].publisher
let people: Publishers.Sequence<[String?], Never> = ["Tunde", "Bob", "Toyo", "Jack"].publisher

// Never = never fails

enum PersonError: Error {
    case emptyData
}

extension PersonError {
    
    public var errorDescription: String {
        switch self {
        case .emptyData:
            return "There is a nil value somewhere"
        }
    }
}

func validate(person: String?, meal: String?) throws -> String {
    
    guard let person = person,
          let meal = meal else {
        throw PersonError.emptyData
    }
    
    return "\(person) \(meal)"
    
}
let subscription = people
    .zip(meals) // Combine meals and people
    .filter({ $0 != nil && $1 != nil}) // Filter out the nils
    .sink { completion in
        print("Subscription: \(completion)") // Print out completion of subscription
    } receiveValue: { (person, meal) in // Have access to person and meal from RecVal
        print("\(person) enjoys \(meal)") // Listen to what they emit, create custom string
    }
}
