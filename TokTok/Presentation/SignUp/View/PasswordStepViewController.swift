//
//  PasswordStepViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordStepViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: Icon.back.image,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var stepSlider: StepSlider = {
        let slider = StepSlider(step: 2, total: 5)
        return slider
    }()
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel.large
        label.text = "비밀번호를 입력해 주세요."
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "영문, 숫자, 특수문자 포함 8자 이상"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var passwordConfirmationTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "비밀번호 재입력"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton.rounded
        button.setTitle("다음", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func bind(_ viewModel: SignUpViewModel) {
        // 키보드 높이를 Observable로 만듦
        let keyboardHeight = Observable
            .from([NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                .map { notification -> CGFloat in
                    (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                },
                   NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                .map { _ -> CGFloat in 0 }])
            .merge()
        
        // 키보드 높이가 변경될 때
        keyboardHeight
            .subscribe { [weak self] height in
                self?.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(height + MARGIN)
                }
                self?.view.layoutIfNeeded()
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
        
        passwordConfirmationTextField.rx.beginEditing
            .map { (color: UIColor.highlighted!, width: 2.0) }
            .bind(to: passwordConfirmationTextField.rx.borderColorWidth)
            .disposed(by: disposeBag)

        passwordConfirmationTextField.rx.endEditing
            .map { (color: UIColor.placeholderText, width: 1.0) }
            .bind(to: passwordConfirmationTextField.rx.borderColorWidth)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.endEditing
            .subscribe { [weak self] _ in
                self?.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
                }
                self?.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        passwordConfirmationTextField.rx.endEditing
            .subscribe { [weak self] _ in
                self?.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
                }
                self?.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordRelay)
            .disposed(by: disposeBag)
        
        passwordConfirmationTextField.rx.text.orEmpty
            .bind(to: viewModel.passwordConfirmationRelay)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.returnPressed
            .subscribe { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        passwordConfirmationTextField.rx.returnPressed
            .subscribe { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        // ViewModel -> View
        viewModel.passwordRelay
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordConfirmationRelay
            .bind(to: passwordConfirmationTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .isValidPassword
            .subscribe { [weak self] isValid in
                self?.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        // View -> ViewModel
        nextButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                view.endEditing(true)
                
                let viewController = IDStepViewController()
                viewController.bind(viewModel)
                navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension PasswordStepViewController {
    func setupViews() {
        view.backgroundColor = .background
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = leftBarButtonItem

        [
            stepSlider,
            stepLabel,
            passwordTextField,
            passwordConfirmationTextField,
            nextButton
        ].forEach { view.addSubview($0) }
        
        stepSlider.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
        }
        
        stepLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(104.0)
            $0.leading.trailing.equalToSuperview().inset(34.0)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(36.0)
            $0.leading.trailing.equalTo(stepLabel)
            $0.height.equalTo(46.0)
        }
        
        passwordConfirmationTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(stepLabel)
            $0.height.equalTo(46.0)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
            $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
            $0.height.equalTo(46.0)
        }
    }
}
