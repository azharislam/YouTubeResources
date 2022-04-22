//
//  ViewController.swift
//  Subscriptions & Cancellables
//
//  Created by Tunde on 13/04/2021.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private let countLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "00:00"
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 50, weight: .heavy)
        return lbl
    }()
    
    private let startBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 8
        btn.setTitle("Start", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()
    
    private let stopBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(stopTimer), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 8
        btn.setTitle("Stop", for: .normal)
        btn.backgroundColor = .systemGray5
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()
    
    private let btnContainerStackVw: UIStackView = {
        let stackVw = UIStackView()
        stackVw.spacing = 8
        stackVw.distribution = .fillEqually
        stackVw.translatesAutoresizingMaskIntoConstraints = false
        return stackVw
    }()
    
    private var subscription: AnyCancellable?
        
    override func loadView() {
        super.loadView()
        setup()
    }
    
    @objc
    func startTimer() {
        print("Start")
        subscription = Timer // Store our timer in a subscription
            .publish(every: 1, on: .main, in: .common) // Run the timer every 1 second on the main thread
            .autoconnect() // Connects our timer to the publisher so we can listen to changes
            .scan(0, { (count, _) in // Scan from 0, increment seconds by 1
                return count + 1
            })
            .sink(receiveCompletion: { _ in // Sink is when you want to get final value out of subscription
                print("Finished") // Completion finished
            }, receiveValue: { [weak self] count in // Value in subscription changes
                print("Updating the label to the current value: \(count.format)") // When the count changes
                self?.countLbl.text = count.format // Assign label to the new time format
            })
        
    }
    
    @objc
    func stopTimer() {
        print("Stop")
        subscription?.cancel()
    }
}

private extension ViewController {
    
    func setup() {
        
        btnContainerStackVw.addArrangedSubview(startBtn)
        btnContainerStackVw.addArrangedSubview(stopBtn)
        
        view.addSubview(btnContainerStackVw)
        view.addSubview(countLbl)
        
        NSLayoutConstraint.activate([
            
            countLbl.leadingAnchor.constraint(equalTo: btnContainerStackVw.leadingAnchor),
            countLbl.trailingAnchor.constraint(equalTo: btnContainerStackVw.trailingAnchor),
            countLbl.bottomAnchor.constraint(equalTo: btnContainerStackVw.topAnchor,
                                             constant: -24),

            
            btnContainerStackVw.heightAnchor.constraint(equalToConstant: 50),
            btnContainerStackVw.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnContainerStackVw.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnContainerStackVw.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: 16),
            btnContainerStackVw.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                         constant: -16),
        ])
    }
}

// Taken from: https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds
extension Int {

    var format: String {

        let (h,m,s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)

        let h_string = h < 10 ? "0\(h)" : "\(h)"
        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        let s_string =  s < 10 ? "0\(s)" : "\(s)"

        return "\(h_string):\(m_string):\(s_string)"
    }
}
