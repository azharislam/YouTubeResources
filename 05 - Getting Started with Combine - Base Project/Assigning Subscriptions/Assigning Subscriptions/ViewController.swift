//
//  ViewController.swift
//  Assigning Subscriptions
//
//  Created by Tunde on 13/04/2021.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private let inputTxtField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "Enter some text here"
        txtField.borderStyle = .roundedRect
        return txtField
    }()
    
    private let textLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "The user entered:"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 24, weight: .semibold)
        return lbl
    }()
    
    private var subscriptions = Set<AnyCancellable>()
        
    override func loadView() {
        super.loadView()
        setup()
        setupSubscriptions()
    }
}

private extension ViewController {
    
    func setup() {
        
        view.addSubview(inputTxtField)
        view.addSubview(textLbl)
        
        NSLayoutConstraint.activate([
            inputTxtField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputTxtField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputTxtField.heightAnchor.constraint(equalToConstant: 44),
            inputTxtField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: 8),
            textLbl.topAnchor.constraint(equalTo: inputTxtField.bottomAnchor,
                                         constant: 16),
            textLbl.leadingAnchor.constraint(equalTo: inputTxtField.leadingAnchor),
            textLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                              constant: -8)
        ])
    }
    
    func setupSubscriptions() {
        
        NotificationCenter
            .default // Get default NC
            .publisher(for: UITextField.textDidChangeNotification, object: inputTxtField) // Get publisher for it, listen for textdidchange on textfield
            .compactMap({ ($0.object as? UITextField)?.text }) // Get text from textfield and acces property, no nils because its compactMap
            .map { "The user entered \($0)" } // Flatten value into a string
            .assign(to: \.text, on: textLbl) // Assign the value to textLabel on the text property
            .store(in: &subscriptions) // & is in and out property
    }
}
