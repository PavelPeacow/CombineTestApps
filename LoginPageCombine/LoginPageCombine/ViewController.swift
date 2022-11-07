//
//  ViewController.swift
//  LoginPageCombine
//
//  Created by Павел Кай on 07.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var isLoginActive: Bool = true
    
    private lazy var emailTextfield: CustomTextField = CustomTextField(placeholder: "Email", leftIcon: UIImage(named: "emailIcon")!)
    
    private lazy var passwordTextfield: CustomTextField = CustomTextField(placeholder: "Пароль", leftIcon: UIImage(named: "passwordIcon")!)
    
    private lazy var loginTextfield: CustomTextField = {
        let textfield = CustomTextField(placeholder: "Почта", leftIcon: UIImage(named: "loginIcon")!)
        textfield.isHidden = true
        return textfield
    }()
    
    private lazy var passwordRepeatTextfield: CustomTextField = {
        let textfield = CustomTextField(placeholder: "Повторите пароль", leftIcon: UIImage(named: "emailIcon")!)
        textfield.isHidden = true
        return textfield
    }()
    
    private var heightConstaint: NSLayoutConstraint!
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.bordered())
        button.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        let tapLoginGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLoginLabel))
        label.addGestureRecognizer(tapLoginGesture)
        return label
    }()
    
    private lazy var dividerLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var registrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Регистрация"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        let tapLoginGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRegistrationLabel))
        label.addGestureRecognizer(tapLoginGesture)
        return label
    }()
    
    private lazy var forgotLabel: UILabel = {
        let label = UILabel()
        label.text = "Забыли пароль?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var mainVerticalStackView: UIStackView = {
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
    
    private lazy var mainHorizontalStackView: UIStackView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(mainHorizontalStackView)
        view.addSubview(mainVerticalStackView)
        view.addSubview(loginButton)
        view.addSubview(forgotLabel)
        
        view.backgroundColor = .systemBackground
        
        setConstraints()
    }

    @objc private func didTapLoginLabel() {
        guard !isLoginActive else { return }
        isLoginActive = true
        print("tap")
        UIView.transition(with: loginLabel, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.registrationLabel.textColor = .gray
            self?.loginLabel.textColor = .white
            
            self?.loginTextfield.isHidden = true
            self?.passwordRepeatTextfield.isHidden = true
            self?.heightConstaint.constant = 124
            self?.view.layoutIfNeeded()
        }
        
    }

    @objc private func didTapRegistrationLabel() {
        guard isLoginActive else { return }
        isLoginActive = false
        print("tap register")
        UIView.transition(with: loginLabel, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.registrationLabel.textColor = .white
            self?.loginLabel.textColor = .gray
            
            self?.loginTextfield.isHidden = false
            self?.passwordRepeatTextfield.isHidden = false
            self?.heightConstaint.constant = 324
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc private func didTapLoginButton() {
        print("tap login")
    }
    
}

extension ViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainHorizontalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainHorizontalStackView.bottomAnchor.constraint(equalTo: mainVerticalStackView.topAnchor, constant: -40),
            
            mainVerticalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainVerticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 62),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),
            
            
            loginButton.topAnchor.constraint(equalTo: mainVerticalStackView.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 226),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
            forgotLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            forgotLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        heightConstaint = mainVerticalStackView.heightAnchor.constraint(equalToConstant: 124)
        heightConstaint?.isActive = true
    }
}
