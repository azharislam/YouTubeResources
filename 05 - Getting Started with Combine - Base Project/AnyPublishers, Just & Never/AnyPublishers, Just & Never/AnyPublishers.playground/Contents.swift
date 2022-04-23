import UIKit
import Combine

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

let postURL = URL(string: "https://jsonplaceholder.typicode.com/posts")

func getPosts() -> AnyPublisher<[Post], Never> {
    
    let postPublisher = URLSession // Create URL session for internet work
        .shared
        .dataTaskPublisher(for: postURL!) // Call service from URL
        .map { $0.data } // Map data from service
        .decode(type: [Post].self, decoder: JSONDecoder()) // Decode data to Array of posts
        .catch { _ in return Just([]) } // If fails, JUST return empty posts
        .eraseToAnyPublisher() // Turns it into an AnyPublisher
    
    return postPublisher
}

var subscriptions = Set<AnyCancellable>()

getPosts()
    .sink { posts in
        print(posts)
    }
    .store(in: &subscriptions)
