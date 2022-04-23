//
//  NotificationViewModel.swift
//  Future & Deffered
//
//  Created by Azhar Islam on 23/04/2022.
//

import Foundation
import Combine
import UserNotifications

final class NotificationViewModel {
    
    func authorize() -> AnyPublisher<Bool, Error> {
        
        Deferred { // Wait for subscription to run before allowing publisher to emit values, delays publisher
            
            Future { handler in // Emit whether success or failure
                
                UNUserNotificationCenter
                    .current() // Get current NC
                    .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in // Request auth from that in our app
                        
                        if let error = error {
                            handler(.failure(error)) // If error, get error and push it through handler
                        } else {
                            handler(.success(granted))
                            // Push through success through handler
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}
