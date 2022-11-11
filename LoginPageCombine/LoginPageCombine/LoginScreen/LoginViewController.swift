//
//  ViewController.swift
//  LoginPageCombine
//
//  Created by Павел Кай on 07.11.2022.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    
    //MARK: Properties
    private let loginView = LoginView()
    private let loginViewModel = LoginViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDelegates()
        setUpTargets()
        setUpBindings()
    }
    
    override func loadView() {
        view = loginView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: Bindings
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
            loginViewModel.$isValid
                .receive(on: RunLoop.main)
                .sink { [weak self] isValid in
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
                .sink { [weak self] isSwitched in
                    self?.animateFormChange(isDidChangeFormAnimation: isSwitched)
                }
                .store(in: &cancellables)
            
            loginViewModel.$inlineValidationError
                .receive(on: RunLoop.main)
                .sink { [weak self] validationStatus in
                    print(validationStatus)
                    self?.loginView.inlineValidatioError.text = validationStatus
                }
                .store(in: &cancellables)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    //MARK: Logic
    private func setUpDelegates() {
        [loginView.loginTextfield, loginView.emailTextfield, loginView.passwordTextfield, loginView.passwordRepeatTextfield]
            .forEach {
                $0.delegate = self
            }
    }
    
    private func setUpTargets() {
        let tapLoginGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoginLabel))
        loginView.loginLabel.addGestureRecognizer(tapLoginGesture)
        
        let tapRegistrationGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRegistrationLabel))
        loginView.registrationLabel.addGestureRecognizer(tapRegistrationGesture)
        
        loginView.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    private func animateFormChange(isDidChangeFormAnimation didChange: Bool) {
        [loginView.loginTextfield, loginView.passwordTextfield, loginView.passwordRepeatTextfield, loginView.emailTextfield]
            .forEach {
                $0.text = ""
                $0.resignFirstResponder()
            }
        
        loginView.registrationLabel.textColor = didChange ? .white : .gray
        loginView.loginLabel.textColor = didChange ? .gray : .white
        
        //login form
        [loginView.loginButton, loginView.forgotLabel]
            .forEach {
                $0.isHidden = didChange ? true : false
            }
        
        //registration form
        [loginView.loginTextfield, loginView.passwordRepeatTextfield, loginView.registrationButton, loginView.agreementLabel, loginView.inlineValidatioError]
            .forEach {
                $0.isHidden = didChange ? false : true
            }
        
        UIView.transition(with: loginView.mainStackView, duration: 0.3, options: .transitionFlipFromLeft) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
    }
}

//MARK: Button Targets
extension LoginViewController {
    
    @objc func didTapLoginLabel() {
        guard loginViewModel.isSwitchedToRegistrationForm else { return }
        loginViewModel.isSwitchedToRegistrationForm = false
        print("tap")
    }
    
    @objc func didTapRegistrationLabel() {
        guard !loginViewModel.isSwitchedToRegistrationForm else { return }
        loginViewModel.isSwitchedToRegistrationForm = true
        print("tap register")
    }
    
    @objc func didTapLoginButton() {
        print("tap login")
        loginViewModel.login()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
