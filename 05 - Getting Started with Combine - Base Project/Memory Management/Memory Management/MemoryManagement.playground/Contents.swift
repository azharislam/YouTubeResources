import UIKit
import Combine

class AccountViewModel {
    
    enum AccountState {
        case active
        case inactive
    }
    
    struct Account {
        var username: String
        var status: AccountState
    }
    
    let user = CurrentValueSubject<Account, Never>(Account(username: "tundsdev",
                                                           status: .active))
    private var accountState: AccountState = .active {
        
        didSet {
            print("The user's account status changed: \(accountState)")
        }
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        
        user
         .map(\.status) // Assign status of accountState to self
//         .assign(to: \.accountState, on: self) // Retain cycle so no way to dispose of it
         .sink{ [weak self] val in // Do weak self and sink so retain cycle isn't created
             self?.accountState = val
         }
         .store(in: &subscriptions)
    }
    
    deinit {
        print("deinit released AccountViewModel")
    }
}

var viewModel: AccountViewModel? = AccountViewModel()

viewModel?.user.value.status = .inactive

viewModel = nil
