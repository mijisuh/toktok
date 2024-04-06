//
//  TACStepViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit

final class TACStepViewController: UIViewController {
    private var isChecked: Bool = false {
        willSet {
            checkButton.configuration?.image = newValue
            ? .checked
            : .unchecked
            
            checkButton.configuration?.baseBackgroundColor = newValue
            ? .secondarySystemFill.withAlphaComponent(1.0)
            : .secondarySystemFill.withAlphaComponent(0.5)
        }
    }
    
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: .back,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var stepSlider: StepSlider = {
        let slider = StepSlider(step: 5)
        return slider
    }()
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel.large
        label.text = "약관에 동의해 주세요."
        return label
    }()
    
    private lazy var stepDescriptionLabel: UILabel = {
        let label = UILabel.secondary
        label.text = "TokTok 이용을 위해 동의해 주세요."
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        // 버튼 속성
        var configuration = UIButton.Configuration.tinted()
        
        var attText = AttributedString("필수 약관 전체 동의")
        attText.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        attText.foregroundColor = .black
        configuration.attributedTitle = attText

        configuration.image = .unchecked
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8.0
        
        configuration.baseBackgroundColor = .secondarySystemFill.withAlphaComponent(0.5)
        configuration.background.cornerRadius = 4.0
        configuration.background.backgroundInsets = .init(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 0.0)
        
        let button = UIButton(configuration: configuration)
        
        button.setBackgroundColor(.secondarySystemFill.withAlphaComponent(0.8), for: .highlighted)
        button.clipsToBounds = true
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        button.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tacButton: UIButton = {
        let button = UIButton.link
        var attText = AttributedString("서비스 이용 약관 동의")
        attText.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        button.configuration?.attributedTitle = attText
        return button
    }()
    
    private lazy var privacyButton: UIButton = {
        let button = UIButton.link
        var attText = AttributedString("개인정보 처리 방침")
        attText.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        button.configuration?.attributedTitle = attText
        return button
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
}

private extension TACStepViewController {
    func setupViews() {
        view.backgroundColor = .background
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = leftBarButtonItem

        [
            stepSlider,
            stepLabel,
            stepDescriptionLabel,
            checkButton,
            tacButton,
            privacyButton,
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
        
        checkButton.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(50.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(56.0)
        }
        
        tacButton.snp.makeConstraints {
            $0.top.equalTo(checkButton.snp.bottom).offset(26.0)
            $0.leading.trailing.equalToSuperview().inset(44.0)
        }
        
        privacyButton.snp.makeConstraints {
            $0.top.equalTo(tacButton.snp.bottom).offset(22.0)
            $0.leading.trailing.equalTo(tacButton)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
            $0.bottom.equalToSuperview().inset(BOTTOM + MARGIN)
            $0.height.equalTo(46.0)
        }
    }
    
    @objc func didTapNextButton() {
        let viewController = SuccessStepViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapCheckButton() {
        isChecked.toggle()
        nextButton.isEnabled = isChecked
    }
}
