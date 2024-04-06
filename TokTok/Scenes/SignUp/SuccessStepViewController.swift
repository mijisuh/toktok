//
//  SuccessStepViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit
import SnapKit

final class SuccessStepViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .fireworks
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var stepLabel: UILabel = {
        let label = UILabel.large
        label.text = "회원가입이 완료되었습니다."
        return label
    }()
    
    private lazy var stepDescriptionLabel: UILabel = {
        let label = UILabel.secondary
        label.text = "TokTok의 회원이 되신 것을 환영합니다."
        return label
    }()
    
    private lazy var popToRootButton: UIButton = {
        let button = UIButton.rounded
        button.setTitle("로그인으로 이동", for: .normal)
        button.addTarget(self, action: #selector(didTapPopToRootButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension SuccessStepViewController {
    func setupViews() {
        view.backgroundColor = .background
        navigationController?.isNavigationBarHidden = true
        
        [
            imageView,
            stepLabel,
            stepDescriptionLabel,
            popToRootButton
        ].forEach { view.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-122.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(64.0)
            $0.height.equalTo(64.0)
        }
        
        stepLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-12.0)
            $0.centerX.equalToSuperview()
        }
        
        stepDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(24.0)
            $0.centerX.equalToSuperview()
        }
        
        popToRootButton.snp.makeConstraints {
            $0.top.equalTo(stepDescriptionLabel.snp.bottom).offset(60.0)
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
            $0.height.equalTo(46.0)
        }
    }
    
    @objc func didTapPopToRootButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}
