//
//  SignInViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit
import SnapKit

final class SignInViewController: UIViewController {
    private var signInView: UIView = UIView()
    
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TokTok"
        label.textColor = .label
        label.font = .systemFont(ofSize: 32.0, weight: .semibold)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .roundSpeechBubble
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "이메일"
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "비밀번호"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton.rounded
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "계정이 없으신가요?"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotifications(#selector(keyboardWillShow), #selector(keyboardWillHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        removeKeyboardNotifications()
    }
}

private extension SignInViewController {
    func setupViews() {
        view.backgroundColor = .background

        navigationItem.title = "로그인"
        navigationItem.hidesBackButton = true
        
        let signUpStackView = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
        signUpStackView.axis = .horizontal
        signUpStackView.spacing = 6
        
        [
            appNameLabel,
            imageView,
            emailTextField,
            passwordTextField,
            signInButton,
            signUpStackView
        ].forEach { signInView.addSubview($0) }
        
        view.addSubview(signInView)
        
        appNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(18.0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14.0)
            $0.leading.equalTo(appNameLabel.snp.trailing).offset(12.0)
            $0.width.equalTo(48.0)
            $0.height.equalTo(48.0)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(appNameLabel.snp.bottom).offset(38.0)
            $0.leading.trailing.equalToSuperview().inset(18.0)
            $0.height.equalTo(46.0)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(emailTextField)
            $0.height.equalTo(46.0)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(43.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46.0)
        }
        
        signUpStackView.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(32.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.0)
        }
        
        signInView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
        }
    }
    
    @objc func didTapSignInButton() {
        // UINavigationController에서 모든 뷰 컨트롤러를 pop하여 기존 스택 제거
        let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
        navigationController?.popToRootViewController(animated: false)

        // 새로운 루트 뷰 컨트롤러 설정
        let newRootViewController = TabBarController()
        UIApplication.shared.windows.first?.rootViewController = newRootViewController
    }
    
    @objc func didTapSignUpButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            signInView.snp.updateConstraints {
                $0.centerY.equalToSuperview().offset(-(signInView.frame.maxY - keyboardRectangle.minY))
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
        signInView.snp.updateConstraints {
            $0.centerY.equalToSuperview()
        }
        view.layoutIfNeeded()
    }
}
