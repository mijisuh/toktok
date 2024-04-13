//
//  CurrentPasswordStepViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/10.
//

import UIKit

final class CurrentPasswordStepViewController: UIViewController {
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: Icon.back.image,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var stepSlider: StepSlider = {
        let slider = StepSlider(step: 1, total: 2)
        return slider
    }()
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel.large
        label.text = "현재 비밀번호를 입력해 주세요."
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "현재 비밀번호"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton.rounded
        button.setTitle("다음", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
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

extension CurrentPasswordStepViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension CurrentPasswordStepViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "비밀번호 변경"
        navigationItem.leftBarButtonItem = leftBarButtonItem

        [
            stepSlider,
            stepLabel,
            passwordTextField,
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
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
            $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
            $0.height.equalTo(46.0)
        }
    }
    
    @objc func didTapNextButton() {
        let viewController = UpdatePasswordStepViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func passwordTextFieldDidChange() {
        if let text = passwordTextField.text, !text.isEmpty {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            nextButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight + MARGIN)
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
        nextButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
        }
        view.layoutIfNeeded()
    }
}
