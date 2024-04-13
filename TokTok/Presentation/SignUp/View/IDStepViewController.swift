//
//  IDStepViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit
import SnapKit

final class IDStepViewController: UIViewController {
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: Icon.back.image,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var stepSlider: StepSlider = {
        let slider = StepSlider(step: 3, total: 5)
        return slider
    }()
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel.large
        label.text = "ID를 입력해 주세요."
        return label
    }()
    
    private lazy var stepDescriptionLabel: UILabel = {
        let label = UILabel.secondary
        label.text = "입력하신 ID는 채팅 검색 시 사용됩니다."
        return label
    }()
    
    private lazy var idTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "한글, 영문 또는 숫자 포함 5~20자"
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
        addKeyboardNotifications(#selector(keyboardWillShow), #selector(keyboardWillHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        removeKeyboardNotifications()
    }
}

extension IDStepViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension IDStepViewController {
    func setupViews() {
        view.backgroundColor = .background
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = leftBarButtonItem

        [
            stepSlider,
            stepLabel,
            stepDescriptionLabel,
            idTextField,
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
        
        stepDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(14.0)
            $0.leading.trailing.equalTo(stepLabel)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(36.0)
            $0.leading.trailing.equalTo(stepDescriptionLabel)
            $0.height.equalTo(46.0)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
            $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
            $0.height.equalTo(46.0)
        }
    }
    
    @objc func didTapNextButton() {
        let viewController = ProfileImageStepViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func textFieldDidChange() {
        if let text = idTextField.text, !text.isEmpty {
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
