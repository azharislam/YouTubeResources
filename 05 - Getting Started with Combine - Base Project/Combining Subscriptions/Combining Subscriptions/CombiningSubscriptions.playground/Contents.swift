import UIKit
import Combine

/*
 * Combine two publishers and validate any nil values remove it
 *
 */

let meals: Publishers.Sequence<[String?], Never> = ["🍔", "🌭", "🍕", nil].publisher
let people: Publishers.Sequence<[String?], Never> = ["Tunde", "Bob", "Toyo", "Jack"].publisher

// Never = never fails

let subscription = people
    .zip(meals) // Combine meals and people
    .filter({ $0 != nil && $1 != nil}) // Filter out the nils
    .sink { completion in
        print("Subscription: \(completion)") // Print out completion of subscription
    } receiveValue: { (person, meal) in // Have access to person and meal from RecVal
        print("\(person) enjoys \(meal)") // Listen to what they emit, create custom string
    }
}
