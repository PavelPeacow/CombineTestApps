//
//  LoginViewModel.swift
//  LoginPageCombine
//
//  Created by Павел Кай on 07.11.2022.
//

import Foundation
import Combine

enum ValidationStatus {
    case valid
    
    case invalidUsername
    case invalidEmail
    case invalidPassword
    case passwordsNotMatch
}

final class LoginViewModel {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    @Published var isValid = false
    @Published var inlineValidationError = ""
    
    @Published var isSwitchedToRegistrationForm = false
    
    private var cancallables = Set<AnyCancellable>()
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($email, $password)
            .map {
                guard $0.count > 0 else { return false }
                guard $1.count > 0 else { return false }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    private func clearInput() {
        $isSwitchedToRegistrationForm
            .sink { [weak self] _ in
                self?.username = ""
                self?.email = ""
                self?.password = ""
                self?.repeatPassword = ""
            }
            .store(in: &cancallables)
        
    }
    
    private var isFullFormValidPublisher: AnyPublisher<ValidationStatus, Never> {
        Publishers.CombineLatest4($username, $email, $password, $repeatPassword)
            .map {
                guard Validator.validateUsername(with: $0) else { return .invalidUsername }
                guard Validator.validateEmail(with: $1) else { return .invalidEmail }
                guard Validator.validatePassword(with: $2) else { return .invalidPassword }
                guard $2 == $3 else { return .passwordsNotMatch }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    
    
    private var validateForm: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isFormValidPublisher, isFullFormValidPublisher, $isSwitchedToRegistrationForm)
            .map { 
                if $2 {
                    return $1 == .valid
                } else {
                    return $0
                }
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        clearInput()
        validateForm
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancallables)
        
        isFullFormValidPublisher
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .map { validationStatus in
                switch validationStatus {
                case .valid:
                    return ""
                case .invalidUsername:
                    return "Неправильный логин"
                case .invalidEmail:
                    return "Неправильная почта"
                case .invalidPassword:
                    return "Неправильный пароль"
                case .passwordsNotMatch:
                    return "Пароли не совпадают"
                }
            }
            .assign(to: \.inlineValidationError, on: self)
            .store(in: &cancallables)
    }
    
    func login() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("logged")
        }
    }
}
