//
//  ChatMessageCell.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/08.
//

import UIKit

final class ChatMessageCell: UICollectionViewCell {
    static let identifier = "ChatMessageCell"
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Icon.profileImage.image
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15.0, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 9.0, left: 10.0, bottom: 9.0, right: 10.0)
        textView.sizeToFit()
        textView.backgroundColor = .background
        textView.layer.masksToBounds = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 10.0, weight: .regular)
        return label
    }()
    
    func setup(_ message: Message) {
        messageTextView.text = message.contents
        timeLabel.text = message.time
        
        setupViews(message)
    }
}

private extension ChatMessageCell {
    func setupViews(_ message: Message) {
        [
            profileImageView,
            messageTextView,
            timeLabel
        ].forEach { addSubview($0) }

        if message.type == .receive {
            profileImageView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.width.height.equalTo(36.0)
            }
            
            messageTextView.snp.makeConstraints {
                $0.leading.equalTo(profileImageView.snp.trailing).offset(6.0)
                $0.top.equalTo(profileImageView)
                $0.height.greaterThanOrEqualTo(36.0)
                $0.width.lessThanOrEqualTo(255)
            }
            
            timeLabel.snp.makeConstraints {
                $0.leading.equalTo(messageTextView.snp.trailing).offset(6.0)
                $0.bottom.equalTo(messageTextView)
            }
            
            layoutIfNeeded()
            
            messageTextView.applyRadiusMaskFor(topLeft: 2.0, bottomLeft: 12.0, bottomRight: 12.0, topRight: 12.0)
        } else {
            profileImageView.isHidden = true
            messageTextView.textColor = .white
            messageTextView.backgroundColor = .highlighted
            
            messageTextView.snp.makeConstraints {
                $0.top.trailing.equalToSuperview()
                $0.height.greaterThanOrEqualTo(36.0)
                $0.width.lessThanOrEqualTo(255)
            }
            
            timeLabel.snp.makeConstraints {
                $0.trailing.equalTo(messageTextView.snp.leading).offset(-6.0)
                $0.bottom.equalTo(messageTextView)
            }
            
            layoutIfNeeded()

            messageTextView.applyRadiusMaskFor(topLeft: 12.0, bottomLeft: 12.0, bottomRight: 2.0, topRight: 12.0)
        }
    }
}
