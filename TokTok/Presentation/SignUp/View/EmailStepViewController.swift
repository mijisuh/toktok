//
//  EmailStepViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EmailStepViewController: UIViewController {
    private let viewModel = SignUpViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: Icon.back.image,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var stepSlider: StepSlider = {
        let slider = StepSlider(step: 1, total: 5)
        return slider
    }()
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel.large
        label.text = "이메일을 입력해 주세요."
        return label
    }()
    
    private lazy var stepDescriptionLabel: UILabel = {
        let label = UILabel.secondary
        label.text = "입력하신 이메일은 로그인 시 사용됩니다."
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField.rounded
        textField.placeholder = "이메일"
        textField.keyboardType = .emailAddress
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
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension EmailStepViewController {
    func setupViews() {
        view.backgroundColor = .background
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = leftBarButtonItem

        [
            stepSlider,
            stepLabel,
            stepDescriptionLabel,
            emailTextField,
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
        
        emailTextField.snp.makeConstraints {
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
    
    func bind() {
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
                // 키보드의 높이만큼 화면을 내려준다.
                self?.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
                }
                self?.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.returnPressed
            .subscribe { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        // ViewModel -> View
        viewModel.emailRelay
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 사용자가 값을 입력했다면 유효성 검사
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailRelay)
            .disposed(by: disposeBag)
        
        viewModel
            .isEmailValid
            .subscribe { [weak self] isValid in
                self?.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        // View -> ViewModel
        nextButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                view.endEditing(true)
                
                let viewController = PasswordStepViewController()
                viewController.bind(self.viewModel)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
