//
//  ViewController.swift
//  LoginPageCombine
//
//  Created by Павел Кай on 07.11.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private var isSwitchedToRegistrationForm = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTargets()
    }
    
    override func loadView() {
        view = loginView
    }
    
    private func setUpTargets() {
        let tapLoginGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoginLabel))
        loginView.loginLabel.addGestureRecognizer(tapLoginGesture)
        
        let tapRegistrationGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRegistrationLabel))
        loginView.registrationLabel.addGestureRecognizer(tapRegistrationGesture)
        
        loginView.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    private func animateFormChange(isDidChangeFormAnimation didChange: Bool) {
        UIView.transition(with: loginView.loginLabel, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            
            if didChange {
                self?.loginView.registrationLabel.textColor = .white
                self?.loginView.loginLabel.textColor = .gray
                self?.loginView.loginTextfield.isHidden = false
                self?.loginView.passwordRepeatTextfield.isHidden = false
                self?.loginView.heightConstaint.constant = 324
            } else {
                self?.loginView.registrationLabel.textColor = .gray
                self?.loginView.loginLabel.textColor = .white
                self?.loginView.loginTextfield.isHidden = true
                self?.loginView.passwordRepeatTextfield.isHidden = true
                self?.loginView.heightConstaint.constant = 124
            }
            
            [self?.loginView.loginTextfield, self?.loginView.passwordTextfield, self?.loginView.passwordRepeatTextfield, self?.loginView.emailTextfield]
                .forEach {
                    $0?.text = ""
                    $0?.resignFirstResponder()
                }
            
            self?.view.layoutIfNeeded()
        }
    }
}

extension LoginViewController {
        
    @objc private func didTapLoginLabel() {
        guard isSwitchedToRegistrationForm else { return }
        isSwitchedToRegistrationForm = false
        print("tap")
        
        animateFormChange(isDidChangeFormAnimation: false)
    }
    
    @objc private func didTapRegistrationLabel() {
        guard !isSwitchedToRegistrationForm else { return }
        isSwitchedToRegistrationForm = true
        print("tap register")
        
        animateFormChange(isDidChangeFormAnimation: true)
    }
    
    @objc private func didTapLoginButton() {
        print("tap login")
    }
}
