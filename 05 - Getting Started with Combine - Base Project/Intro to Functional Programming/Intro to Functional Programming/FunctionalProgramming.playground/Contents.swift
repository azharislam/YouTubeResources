import UIKit

var items: [String?] = ["Femi", "Pete", "Bryan", nil]

func filterNils(in items: [String?]) -> [String] {
    var myItems = [String]()
    for item in items {
        if let item = item {
            myItems.append(item)
        }
    }
    return myItems
}

print(filterNils(in: items))
print(items.compactMap{ $0 }) // compact map does what filterNils does


let combined = items
    .compactMap { $0 } //takes out nils but still optionals
    .map { $0 } // maps it into a new array without optionals
    .joined(separator: ",") // put seperator between each element in new array

print(combined)
