//
//  SignInViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
    private let viewModel = SignInViewModel()
    private let disposeBag = DisposeBag()
    
    private var isKeyboardShowed = false
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
        imageView.image = Icon.roundSpeechBubble.image
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "이메일"
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "비밀번호"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton.rounded
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        view.layoutIfNeeded()
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
    
    func bind() {
        // 키보드 높이를 Observable로 만듦
        let keyboardRectangle = Observable
            .from([NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                .map { notification -> CGRect in
                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
                },
                   NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                .map { _ -> CGRect in .zero }])
            .merge()
        
        // 키보드 높이가 변경될 때
        keyboardRectangle
            .subscribe { [weak self] rect in
                guard let self = self, !isKeyboardShowed else { return }
                self.signInView.snp.updateConstraints {
                    $0.centerY.equalToSuperview().offset(-(self.signInView.frame.maxY - rect.minY))
                }
                self.view.layoutIfNeeded()
                self.isKeyboardShowed = true
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.beginEditing
            .map { (color: UIColor.highlighted!, width: 2.0) }
            .bind(to: emailTextField.rx.borderColorWidth)
            .disposed(by: disposeBag)

        emailTextField.rx.endEditing
            .map { (color: UIColor.placeholderText, width: 1.0) }
            .bind(to: emailTextField.rx.borderColorWidth)
            .disposed(by: disposeBag)
        
        emailTextField.rx.endEditing
            .subscribe { [weak self] _ in
                guard let self = self, isKeyboardShowed else { return }
                signInView.snp.updateConstraints {
                    $0.centerY.equalToSuperview()
                }
                view.layoutIfNeeded()
                isKeyboardShowed = false
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.returnPressed
            .subscribe { [weak self] _ in
                guard let self = self, isKeyboardShowed else { return }
                self.view.endEditing(true)
                view.layoutIfNeeded()
                isKeyboardShowed = false
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.beginEditing
            .map { (color: UIColor.highlighted!, width: 2.0) }
            .bind(to: passwordTextField.rx.borderColorWidth)
            .disposed(by: disposeBag)

        passwordTextField.rx.endEditing
            .map { (color: UIColor.placeholderText, width: 1.0) }
            .bind(to: passwordTextField.rx.borderColorWidth)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.endEditing
            .subscribe { [weak self] _ in
                guard let self = self, isKeyboardShowed else { return }
                signInView.snp.updateConstraints {
                    $0.centerY.equalToSuperview()
                }
                view.layoutIfNeeded()
                isKeyboardShowed = false
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.returnPressed
            .subscribe { [weak self] _ in
                guard let self = self, isKeyboardShowed else { return }
                self.view.endEditing(true)
                view.layoutIfNeeded()
                isKeyboardShowed = false
            }
            .disposed(by: disposeBag)
        
        // ViewModel -> View
        viewModel.emailRelay
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordRelay
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)

        // View -> ViewModel
        signInButton.rx.tap
            .subscribe { [weak self] _ in
                self?.view.endEditing(true)
                
                // UINavigationController에서 모든 뷰 컨트롤러를 pop하여 기존 스택 제거
                let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
                navigationController?.popToRootViewController(animated: false)

                // 새로운 루트 뷰 컨트롤러 설정
                let newRootViewController = UINavigationController(rootViewController: TabBarController())
                UIApplication.shared.windows.first?.rootViewController = newRootViewController
            }
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
