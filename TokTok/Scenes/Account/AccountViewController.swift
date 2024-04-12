//
//  AccountViewController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/10.
//

import UIKit

final class AccountViewController: UIViewController {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Icon.addProfileImage.image
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        return imageView
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.addTarget(self, action: #selector(didTapDeleteAccountButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        button.addTarget(self, action: #selector(didTapSignOutButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        idLabel.text = "ID"
    }
}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이메일"
            cell.detailTextLabel?.text = "abc@gmail.com"
        case 1:
            cell.textLabel?.text = "ID 변경"
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.textLabel?.text = "비밀번호 변경"
            cell.accessoryType = .disclosureIndicator
        default: break
        }
        
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let viewController = UpdateIDViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController = UpdateIDViewController()
            navigationController?.pushViewController(viewController, animated: true)
        default: return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let viewController = UpdateIDViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController = CurrentPasswordStepViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        default: return
        }
    }
}

extension AccountViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension AccountViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "계정"
        
        let underlineView = UIView()
        underlineView.backgroundColor = .black
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [deleteAccountButton, dividerView, signOutButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 18.0
        
        [
            profileImageView,
            idLabel,
            underlineView,
            tableView,
            stackView
        ].forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(128.0)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(32.0)
            $0.centerX.equalTo(profileImageView)
        }
        
        underlineView.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(6.0)
            $0.centerX.equalTo(idLabel)
            $0.width.equalTo(idLabel.snp.width).multipliedBy(2)
            $0.height.equalTo(1.0)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(underlineView.snp.bottom).offset(32.0)
            $0.leading.trailing.equalToSuperview().inset(MARGIN)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-14.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16.0)
        }
        
        dividerView.snp.makeConstraints {
            $0.width.equalTo(1.0)
            $0.height.equalToSuperview()
        }
    }
    
    @objc func didTapDeleteAccountButton() {
        
    }
    
    @objc func didTapSignOutButton() {
        // UINavigationController에서 모든 뷰 컨트롤러를 pop하여 기존 스택 제거
        let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
        navigationController?.popToRootViewController(animated: false)

        // 새로운 루트 뷰 컨트롤러 설정
        let newRootViewController = UINavigationController(rootViewController:MainViewController())
        UIApplication.shared.windows.first?.rootViewController = newRootViewController
    }
}
