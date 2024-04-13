//
//  ChatViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/08.
//

import UIKit
import SnapKit

final class ChatViewController: UIViewController {
    var keyboardHeight: CGFloat = 0.0
    
    var chatMessage = "" // 키보드가 내려간 경우 chatTextView에 한 줄만 보이게 하기 위함
    
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
        image: Icon.back.image,
        style: .plain,
        target: self,
        action: #selector(didTapLeftBarButtonItem)
    )
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.0
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: MARGIN, bottom: 12.0, right: MARGIN)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: ChatMessageCell.identifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        collectionView.addGestureRecognizer(tapGesture)
        
        return collectionView
    }()
    
    private lazy var chatTextView: UITextView = {
        let textView = UITextView()
        textView.text = "메시지를 입력하세요."
        textView.textColor = .placeholderText
        textView.font = .systemFont(ofSize: 15.0, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 9.0, left: 14.0, bottom: 9.0, right: 14.0)
        textView.layer.cornerRadius = 18.0
        textView.sizeToFit()
        textView.bounces = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.delegate = self
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
    
    private lazy var chatStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chatTextView, sendButton])
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        stackView.backgroundColor = .secondarySystemFill
        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: MARGIN, bottom: 10.0, right: MARGIN)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
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

extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = chatMessage
        textView.scrollToBottom()
        
        guard textView.textColor == .placeholderText else { return }
        textView.text = nil
        textView.textColor = .label
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines) // 공백 삭제
        
        chatMessage = textView.text
        
        guard textView.text.isEmpty else { return }
        setPlaceHolder(textView)
    }

    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else {
            setPlaceHolder(textView)
            return
        }
        
        // placeHolder인데 텍스트가 들어온 경우(빈 문자열에서 처음 문자열이 들어온 경우)
        if textView.textColor == .placeholderText {
            textView.text = String(textView.text.first ?? " ")
            textView.textColor = .label
        }
        
        chatMessage = textView.text
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        var estimatedSizeHeight = max(textView.sizeThatFits(size).height + 18.0, 56.0)
        
        if estimatedSizeHeight > 100.0 {
            estimatedSizeHeight = 100.0
            chatTextView.scrollToBottom()
        }
        
        collectionView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(keyboardHeight + estimatedSizeHeight)
        }
        
        chatStackView.snp.updateConstraints {
            $0.height.equalTo(estimatedSizeHeight)
            $0.bottom.equalToSuperview().inset(keyboardHeight)
        }
        
        view.layoutIfNeeded()
        
        scrollToBottom(animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func setPlaceHolder(_ textView: UITextView) {
        textView.text = "메시지를 입력해주세요."
        textView.textColor = .placeholderText
        textView.selectedRange = NSMakeRange(0, 0)
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
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let navigationBackgroundView = navigationController?.navigationBar.subviews.first
        navigationBackgroundView?.alpha = 0.7
        
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
        
        scrollToBottom(animated: false)
    }
    
    @objc func didTapSendButton() {
        chatTextView.resignFirstResponder()
    }

    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            self.keyboardHeight = keyboardHeight
            
            let size = CGSize(width: view.frame.width, height: .infinity)
            let estimatedSizeHeight = min(max(chatTextView.sizeThatFits(size).height + 18.0, 56.0), 100.0)
            
            collectionView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight + estimatedSizeHeight)
            }
            
            chatStackView.snp.updateConstraints {
                $0.height.equalTo(estimatedSizeHeight)
                $0.bottom.equalToSuperview().inset(keyboardHeight)
            }
            
            collectionView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight + estimatedSizeHeight)
            }
            
            chatStackView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight)
                $0.height.equalTo(estimatedSizeHeight)
            }
            
            view.layoutIfNeeded()
            
            scrollToBottom(animated: false)
        }
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification) {
        chatTextView.text = String(chatTextView.text.split(separator: "\n").first ?? "")
        
        collectionView.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(BOTTOM + 56.0)
        }
        
        chatStackView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(BOTTOM + 56.0)
        }
        
        view.layoutIfNeeded()
    }
    
    func scrollToBottom(animated: Bool) {
        guard collectionView.numberOfSections > 0 else { return }
        let indexPath = IndexPath(
            item: collectionView.numberOfItems(inSection: collectionView.numberOfSections - 1) - 1,
            section: collectionView.numberOfSections - 1
        )
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
    @objc func tapHandler() {
        self.view.endEditing(true)
    }
}
