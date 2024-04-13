//
//  UpdatePasswordStepViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/10.
//

import UIKit

final class UpdatePasswordStepViewController: UIViewController {
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: Icon.back.image,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var stepSlider: StepSlider = {
        let slider = StepSlider(step: 2, total: 2)
        return slider
    }()
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel.large
        label.text = "변경하려는\n비밀번호를 입력해 주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "영문, 숫자, 특수문자 포함 8자 이상"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordConfirmationTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "비밀번호 재입력"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(passwordConfirmationTextFieldDidChange), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton.rounded
        button.setTitle("변경", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        addKeyboardNotifications(#selector(keyboardWillShow), #selector(keyboardWillHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
//        removeKeyboardNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension UpdatePasswordStepViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension UpdatePasswordStepViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "비밀번호 변경"
        navigationItem.leftBarButtonItem = leftBarButtonItem

        [
            stepSlider,
            stepLabel,
            passwordTextField,
            passwordConfirmationTextField,
            confirmButton
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
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
            $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
            $0.height.equalTo(46.0)
        }
    }
    
    @objc func didTapConfirmButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func passwordTextFieldDidChange() {
        if let text = passwordTextField.text, !text.isEmpty {
            confirmButton.isEnabled = true
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    @objc func passwordConfirmationTextFieldDidChange() {
        if let text = passwordConfirmationTextField.text, !text.isEmpty {
            confirmButton.isEnabled = true
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            confirmButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight + MARGIN)
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
        confirmButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
        }
        view.layoutIfNeeded()
    }
}

