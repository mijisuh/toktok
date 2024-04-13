//
//  AddChatViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/07.
//

import UIKit

final class AddChatViewController: UIViewController {
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: Icon.back.image,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel.large
        label.text = "채팅 상대의\nID를 입력해 주세요."
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var stepDescriptionLabel: UILabel = {
        let label = UILabel.secondary
        label.text = "ID를 정확하게 입력해주세요."
        return label
    }()
    
    private lazy var idTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "ID"
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton.rounded
        button.setTitle("확인", for: .normal)
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

extension AddChatViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension AddChatViewController {
    func setupViews() {
        view.backgroundColor = .background
        navigationItem.title = "채팅 생성"
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.prefersLargeTitles = false

        [
            stepLabel,
            stepDescriptionLabel,
            idTextField,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        stepLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(116.0)
            $0.leading.trailing.equalToSuperview().inset(34.0)
        }
        
        stepDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(14.0)
            $0.leading.trailing.equalTo(stepLabel)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(36.0)
            $0.leading.trailing.equalTo(stepDescriptionLabel)
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
    
    @objc func textFieldDidChange() {
        if let text = idTextField.text, !text.isEmpty {
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
