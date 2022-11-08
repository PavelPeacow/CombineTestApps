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
                .assign(to: &loginViewModel.$email)
            
            loginView.loginTextfield.textPublisher
                .assign(to: &loginViewModel.$username)
            
            loginView.passwordTextfield.textPublisher
                .assign(to: &loginViewModel.$password)
            
            loginView.passwordRepeatTextfield.textPublisher
                .assign(to: &loginViewModel.$repeatPassword)
        }
        
        func bindViewModelToView() {
            loginViewModel.validateForm
                .receive(on: RunLoop.main)
                .sink { [weak self] isValid in
                    self?.loginView.forgotLabel.text = String(isValid)
                    if isValid {
                        self?.loginView.loginButton.isEnabled = true
                        self?.loginView.registrationButton.isEnabled = true
                    } else {
                        self?.loginView.loginButton.isEnabled = false
                        self?.loginView.registrationButton.isEnabled = false
                    }
                }
                .store(in: &cancellables)
            
            loginViewModel.$isSwitchedToRegistrationForm
                .receive(on: RunLoop.main)
                .sink { isSwitched in
                    self.animateFormChange(isDidChangeFormAnimation: isSwitched)
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
            
            if didChange {
                self?.loginView.registrationLabel.textColor = .white
                self?.loginView.loginLabel.textColor = .gray
                self?.loginView.loginTextfield.isHidden = false
                self?.loginView.passwordRepeatTextfield.isHidden = false
                self?.loginView.registrationButton.isHidden = false
                self?.loginView.forgotLabel.isHidden = true
                self?.loginView.heightConstaint.constant = 324
            } else {
                self?.loginView.registrationLabel.textColor = .gray
                self?.loginView.loginLabel.textColor = .white
                self?.loginView.loginTextfield.isHidden = true
                self?.loginView.passwordRepeatTextfield.isHidden = true
                self?.loginView.registrationButton.isHidden = true
                self?.loginView.forgotLabel.isHidden = false
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
    }
    
    @objc private func didTapRegistrationLabel() {
        guard !loginViewModel.isSwitchedToRegistrationForm else { return }
        loginViewModel.isSwitchedToRegistrationForm = true
        print("tap register")
    }
    
    @objc private func didTapLoginButton() {
        print("tap login")
        loginViewModel.login()
    }
}
