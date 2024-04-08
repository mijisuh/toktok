//
//  ChatListCell.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/07.
//

import UIKit

final class ChatListCell: UICollectionViewCell {
    static let identifier = "ChatListCell"
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .profileImage
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    
    private lazy var recentMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var recentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    func setup() {
        setupViews()
        
        idLabel.text = "아이디"
        recentMessageLabel.text = "최근 메시지"
        recentTimeLabel.text = "오후 12:30"
    }
}

private extension ChatListCell {
    func setupViews() {
        let labelStackView = UIStackView(arrangedSubviews: [idLabel, recentMessageLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 4.0
        
        [
            profileImageView,
            labelStackView,
            recentTimeLabel
        ].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(48.0)
            $0.height.equalTo(48.0)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(11.0)
            $0.centerY.equalTo(profileImageView)
        }
        
        recentTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(idLabel)
        }
    }
}
