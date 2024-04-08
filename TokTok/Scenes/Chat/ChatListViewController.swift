//
//  ChatListViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/07.
//

import UIKit
import Floaty

final class ChatListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 26.0, left: MARGIN, bottom: 0.0, right: MARGIN)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChatListCell.self, forCellWithReuseIdentifier: ChatListCell.identifier)
        return collectionView
    }()
    
    private lazy var addChatButton: Floaty = {
        let floaty = Floaty()
        floaty.sticky = true
        floaty.handleFirstItemDirectly = true // 버튼 클릭 시 세부 버튼이 나오지 않고 바로 동작
        floaty.addItem(title: "") { [weak self] _ in
            self?.didTapAddChatButton()
        }
        floaty.buttonColor = .primary!
        floaty.plusColor = .white
        return floaty
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ChatListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatListCell.identifier, for: indexPath) as? ChatListCell
        else { return UICollectionViewCell() }
        
        cell.setup()
        
        return cell
    }
}

extension ChatListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.frame.width - 32.0,
            height: 60.0
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ChatViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension ChatListViewController {
    func setupViews() {
        navigationItem.hidesBackButton = true
        navigationItem.title = TabBarItem.chat.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        [
            collectionView,
            addChatButton
        ].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addChatButton.paddingY = 100.0
    }
    
    func didTapAddChatButton() {
        let viewController = AddChatViewController()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
