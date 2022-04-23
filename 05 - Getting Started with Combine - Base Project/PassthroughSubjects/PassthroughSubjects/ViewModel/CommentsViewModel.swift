//
//  CommentsViewModel.swift
//  PassthroughSubjects
//
//  Created by Azhar Islam on 23/04/2022.
//

import Foundation
import Combine

final class CommentsViewModel { // Final so it isn't subclassed
    
    // Similar to currentValue, no default value, we don't observe, just emit events (with a type String, never fails)
    private let commentEntered = PassthroughSubject<String, Never>()
    private var subscriptions = Set<AnyCancellable>()
    private let badWords = ["💩", "🍆"]
    private let manager: AccountsViewModel
    
    init(manager: AccountsViewModel) {
        self.manager = manager
        setupSubscriptions() // Whenever we init this class, we set up sub
    }
    
    // Send function to emit the comment
    func send(comment: String) {
        commentEntered.send(comment)
    }
    
}

private extension CommentsViewModel {
    
    func setupSubscriptions() {
        
        commentEntered
            .filter({ !$0.isEmpty })
            .sink { [weak self] val in // Observe and publish value
                
                guard let self = self else { return }
                
                if self.badWords.contains(val) {
                    self.manager.increaseWarning()
                } else {
                    print("New Comment: \(val)")
                }
            }
            .store(in: &subscriptions)
    }
}
