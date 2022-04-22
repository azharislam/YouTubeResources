import UIKit
import Combine

/*
 * Combine two publishers and validate any nil values remove it
 *
 */

let meals: Publishers.Sequence<[String?], Never> = ["🍔", "🌭", "🍕", "🥘"].publisher
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
    .tryMap({ try validate(person: $0, meal: $1) })
//    .filter({ $0 != nil && $1 != nil}) // Filter out the nils
    .sink { completion in
        switch completion {
        case .finished:
            print("Finished")
        case .failure(let error as PersonError):
            print("Failed: \(error.errorDescription)")
        case .failure(let error):
            print("Failed: \(error.localizedDescription)")
        }
//        print("Subscription: \(completion)") // Print out completion of subscription
    } receiveValue: { (message) in // Have access to person and meal from RecVal
        print(message) // Listen to what they emit, create custom string
    }
}
