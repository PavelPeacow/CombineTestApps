//
//  LoginView.swift
//  LoginPageCombine
//
//  Created by Павел Кай on 07.11.2022.
//

import UIKit

class LoginView: UIView {
    
    lazy var emailTextfield: CustomTextField = CustomTextField(placeholder: "Email", leftIcon: UIImage(named: "emailIcon")!)
    
    lazy var passwordTextfield: CustomTextField = CustomTextField(placeholder: "Пароль", leftIcon: UIImage(named: "passwordIcon")!)
    
    lazy var loginTextfield: CustomTextField = {
        let textfield = CustomTextField(placeholder: "Почта", leftIcon: UIImage(named: "loginIcon")!)
        textfield.isHidden = true
        return textfield
    }()
    
    lazy var passwordRepeatTextfield: CustomTextField = {
        let textfield = CustomTextField(placeholder: "Повторите пароль", leftIcon: UIImage(named: "passwordIcon")!)
        textfield.isHidden = true
        return textfield
    }()
    
    var heightConstaint: NSLayoutConstraint!
    
    lazy var loginButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.bordered())
        button.backgroundColor = .systemGray4
        button.setTitle("Войти", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var registrationButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.bordered())
        button.backgroundColor = .systemGray4
        button.setTitle("Зарегистрироваться", for: .normal)
        button.isHidden = true
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var dividerLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var forgotLabel: UILabel = {
        let label = UILabel()
        label.text = "Забыли пароль?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var mainVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(loginTextfield)
        stackView.addArrangedSubview(emailTextfield)
        stackView.addArrangedSubview(passwordTextfield)
        stackView.addArrangedSubview(passwordRepeatTextfield)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var mainHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(loginLabel)
        stackView.addArrangedSubview(dividerLabel)
        stackView.addArrangedSubview(registrationLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setUpSubviews()
        
        backgroundColor = .systemBackground
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        [mainHorizontalStackView, mainVerticalStackView, loginButton, registrationButton, forgotLabel]
            .forEach {
                addSubview($0)
            }
    }
    
}

extension LoginView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainHorizontalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainHorizontalStackView.bottomAnchor.constraint(equalTo: mainVerticalStackView.topAnchor, constant: -40),
            
            mainVerticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainVerticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 62),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -62),
            
            loginButton.topAnchor.constraint(equalTo: mainVerticalStackView.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 226),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            registrationButton.topAnchor.constraint(equalTo: mainVerticalStackView.bottomAnchor, constant: 40),
            registrationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registrationButton.widthAnchor.constraint(equalToConstant: 226),
            registrationButton.heightAnchor.constraint(equalToConstant: 40),
            
            forgotLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            forgotLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        heightConstaint = mainVerticalStackView.heightAnchor.constraint(equalToConstant: 124)
        heightConstaint?.isActive = true
    }
}
