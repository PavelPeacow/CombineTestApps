//
//  LoginViewModel.swift
//  LoginPageCombine
//
//  Created by Павел Кай on 07.11.2022.
//

import Foundation
import Combine

final class LoginViewModel {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    @Published var isValid = false
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
    
    private var isFullFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4($username, $email, $password, $repeatPassword)
            .map {
                guard Validator.validateUsername(with: $0) else { return false }
                guard Validator.validateEmail(with: $1) else { return false }
                guard Validator.validatePassword(with: $2) else { return false }
                guard $2 == $3 else { return false }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    
    
    private var validateForm: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isFormValidPublisher, isFullFormValidPublisher, $isSwitchedToRegistrationForm)
            .map { 
                if $2 {
                    return $1
                } else {
                    return $0
                }
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        clearInput()
        validateForm
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancallables)
        
    }
    
    func login() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("logged")
        }
    }
}
