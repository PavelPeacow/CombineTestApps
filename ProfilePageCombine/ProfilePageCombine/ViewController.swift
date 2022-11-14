//
//  ViewController.swift
//  ProfilePageCombine
//
//  Created by Павел Кай on 14.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var text: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello world!"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(text)
    
        view.backgroundColor = .red
        setConstraints()
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

}
