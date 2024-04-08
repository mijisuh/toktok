//
//  ChatViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/08.
//

import UIKit
import SnapKit

final class ChatViewController: UIViewController {
    let messages: [Message] = [
        Message(id: "", contents: "상대방의 메시지", time: "오후 12:30", type: .receive),
        Message(id: "", contents: "내 메시지", time: "오후 12:30", type: .send),
        Message(id: "", contents: "길어진 내 메시지", time: "오후 12:30", type: .send),
        Message(id: "", contents: "길어진 상대방의 메시지", time: "오후 12:30", type: .receive),
        Message(id: "", contents: "두줄로\n길어진 상대방의 메시지", time: "오후 12:30", type: .receive),
        Message(id: "", contents: "상대방이 안 읽은 내 메시지", time: "오후 12:30", type: .send),
        Message(id: "", contents: "매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우매우긴메시지", time: "오후 12:30", type: .send),
    ]
    
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: .back,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.0
        layout.sectionInset = UIEdgeInsets(top: 12.0, left: MARGIN, bottom: 12.0, right: MARGIN)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: ChatMessageCell.identifier)
        return collectionView
    }()
    
    private lazy var chatTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15.0, weight: .regular)
        textView.layer.cornerRadius = 20.0
        textView.layer.masksToBounds = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.send.image, for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
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

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMessageCell.identifier, for: indexPath) as? ChatMessageCell
        else { return UICollectionViewCell() }
        let message = messages[indexPath.row]
        cell.setup(message)
        return cell
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row]
        let estimatedFrame = message.contents.getEstimatedFrame(with: .systemFont(ofSize: 15.0, weight: .regular))
        return CGSize(width: collectionView.frame.width - 32.0, height: estimatedFrame.height + 18.0)
    }
}

private extension ChatViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.title = "ID"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let chatStackView = UIStackView(arrangedSubviews: [chatTextView, sendButton])
        chatStackView.axis = .horizontal
        chatStackView.spacing = 10.0
        chatStackView.distribution = .fillProportionally
        chatStackView.backgroundColor = .background
        chatStackView.layoutMargins = UIEdgeInsets(top: 10.0, left: MARGIN, bottom: 10.0, right: MARGIN)
        chatStackView.isLayoutMarginsRelativeArrangement = true

        [
            collectionView,
            chatStackView
        ].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(BOTTOM + 56.0)
        }
        
        chatStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(BOTTOM + 56.0)
        }
    }
    
    @objc func didTapSendButton() {
        
    }

    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            collectionView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight)
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
        collectionView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(BOTTOM)
        }
        view.layoutIfNeeded()
    }
}
