//
//  IDStepViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class IDStepViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
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
        
        idTextField.rx.beginEditing
            .map { (color: UIColor.highlighted!, width: 2.0) }
            .bind(to: idTextField.rx.borderColorWidth)
            .disposed(by: disposeBag)

        idTextField.rx.endEditing
            .map { (color: UIColor.placeholderText, width: 1.0) }
            .bind(to: idTextField.rx.borderColorWidth)
            .disposed(by: disposeBag)
        
        idTextField.rx.endEditing
            .subscribe { [weak self] _ in
                self?.nextButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
                }
                self?.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        idTextField.rx.text.orEmpty
            .bind(to: viewModel.idRelay)
            .disposed(by: disposeBag)
        
        idTextField.rx.returnPressed
            .subscribe { [weak self] _ in
                self?.view.endEditing(true)
            }
        
        // ViewModel -> View
        viewModel.idRelay
            .bind(to: idTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .isIdValid
            .subscribe { [weak self] isValid in
                self?.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        // View -> ViewModel
        nextButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                view.endEditing(true)
                
                let viewController = ProfileImageStepViewController()
                navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
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
}
