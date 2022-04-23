//
//  AccountsViewModel.swift
//  PassthroughSubjects
//
//  Created by Azhar Islam on 23/04/2022.
//

import Foundation
import Combine

final class AccountsViewModel {
    
    // Two states an account can be in
    enum AccountStatus {
        case active
        case banned
    }
    
    private let warningLimit = 3 // Three strikes
    
    let userAccountStatus = CurrentValueSubject<AccountStatus, Never>(.active) // Observe value as it changes, default active
    
    let warnings = CurrentValueSubject<Int, Never>(0) // Observe warnings, default is 0
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        createSubscription()
    }
    
    func increaseWarning() {
        warnings.value += 1
        print("Warning: \(warnings.value)")
    }
}

private extension AccountsViewModel {
    
    func createSubscription() {
        
        warnings
            .filter({ [weak self] val in
                guard let self = self else { return false }
                return val >= self.warningLimit // If warnings >= 3
            })
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.userAccountStatus.value = .banned // User becomes banned
            }
            .store(in: &subscriptions)
    }
}
