//
//  ViewController.swift
//  LoginPageCombine
//
//  Created by Павел Кай on 07.11.2022.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let loginViewModel = LoginViewModel()
    private var isSwitchedToRegistrationForm = false
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTargets()
        setUpBindings()
    }
    
    override func loadView() {
        view = loginView
    }
    
    private func setUpBindings() {
        
        func bindViewToViewModel() {
            loginView.emailTextfield.textPublisher
                .sink(receiveValue: { [weak self] text in
                    self?.loginViewModel.email = text
                })
                .store(in: &cancellables)
            
            loginView.loginTextfield.textPublisher
                .sink(receiveValue: { [weak self] text in
                    self?.loginViewModel.username = text
                })
                .store(in: &cancellables)
            
            loginView.passwordTextfield.textPublisher
                .sink(receiveValue: { [weak self] text in
                    self?.loginViewModel.password = text
                })
                .store(in: &cancellables)
            
            loginView.passwordRepeatTextfield.textPublisher
                .sink(receiveValue: { [weak self] text in
                    self?.loginViewModel.repeatPassword = text
                })
                .store(in: &cancellables)
        }
        
        func bindViewModelToView() {
            loginViewModel.$isValid
                .sink { [weak self] isValid in
                    if isValid {
                        self?.loginView.loginButton.isEnabled = true
                    } else {
                        self?.loginView.loginButton.isEnabled = false
                    }
                }
                .store(in: &cancellables)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
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
            
//            self?.loginView.loginButton.isEnabled = false
            
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
        guard loginViewModel.isSwitchedToRegistrationForm else { return }
        loginViewModel.isSwitchedToRegistrationForm = false
        print("tap")
        
        animateFormChange(isDidChangeFormAnimation: false)
    }
    
    @objc private func didTapRegistrationLabel() {
        guard !loginViewModel.isSwitchedToRegistrationForm else { return }
        loginViewModel.isSwitchedToRegistrationForm = true
        print("tap register")
        
        animateFormChange(isDidChangeFormAnimation: true)
    }
    
    @objc private func didTapLoginButton() {
        print("tap login")
        loginViewModel.login()
    }
}
