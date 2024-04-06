//
//  MainViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/04.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .speechBubble
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TokTok"
        label.textColor = .label
        label.font = .systemFont(ofSize: 32.0, weight: .semibold)
        return label
    }()
    
    private lazy var appDescriptionLabel: UILabel = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18.0, weight: .medium),
            .foregroundColor: UIColor.darkGray,
            .paragraphStyle: paragraphStyle
        ]

        let attributedText = NSAttributedString(
            string: "이야기를 나누고 싶은 바로 그 사람과\n지금 대화를 시작해보세요!",
            attributes: attributes
        )
        
        let label = UILabel()
        label.attributedText = attributedText
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton.rounded
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.text = "이미 계정이 있나요?"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
}

private extension MainViewController {
    func setUpViews() {
        view.backgroundColor = .background
        
        let signinStackView = UIStackView(arrangedSubviews: [signInLabel, signInButton])
        signinStackView.axis = .horizontal
        signinStackView.spacing = 6
        
        [
            imageView,
            appNameLabel,
            appDescriptionLabel,
            signUpButton,
            signinStackView
        ].forEach { view.addSubview($0) }
        
        let margin: CGFloat = 16.0
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(margin + 20.0)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(64.0)
            $0.height.equalTo(64.0)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView)
            $0.top.equalTo(imageView.snp.bottom).offset(40.0)
        }
        
        appDescriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(appNameLabel)
            $0.top.equalTo(appNameLabel.snp.bottom).offset(20.0)
        }
        
        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(margin)
            $0.top.equalTo(appDescriptionLabel.snp.bottom).offset(60.0)
            $0.height.equalTo(46.0)
        }
        
        signinStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signUpButton.snp.bottom).offset(32.0)
        }
    }
    
    @objc func didTapSignUpButton() {
        let viewController = EmailStepViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapSignInButton() {
        let viewController = SignInViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
