//
//  ImageDownloaderViewModel.swift
//  Multi Threading
//
//  Created by Azhar Islam on 23/04/2022.
//

import UIKit
import Combine

final class ImageDownloaderViewModel {
    
    let image = PassthroughSubject<UIImage?, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    func download(url: String) {
        
        URLSession // By default it is in background thread
            .shared
            .dataTaskPublisher(for: URL(string: url)!)
            .subscribe(on: DispatchQueue.global(qos: .background)) // Want to see it handles events
            .handleEvents(receiveSubscription: { _ in
                print("Starting subscription on the main thread: \(Thread.isMainThread)")
                DispatchQueue
                    .main
                    .async {
                        self.image.send(UIImage(named: "placeholder"))
                        print("Setting placeholder on the main thread: \(Thread.isMainThread)")
                    }
            })
            .map({ UIImage(data: $0.data) })
            .receive(on: DispatchQueue.main)
            .sink { (res) in
                print("Finished subscription on main thread: \(Thread.isMainThread)")
            } receiveValue: { [weak self] (val) in
                self?.image.send(val)
                self?.image.send(completion: .finished)
                print("Received subscription on the main thread: \(Thread.isMainThread)")
            }
            .store(in: &subscriptions)
    }
}
