//
//  SignUpViewModel.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/13.
//

import UIKit
import RxSwift
import RxCocoa

struct SignUpViewModel {
    // ViewModel -> View
    
    // View -> ViewModel
    // 이메일, 비밀번호 텍스트필드에서 받은 값에 대한 처리
    // PublishRelay: 초기값 X, UI의 이벤트를 전달할 수도 받을 수도 있음
    let emailRelay = PublishRelay<String>()
    let passwordRelay = PublishRelay<String>()
    let passwordConfirmationRelay = PublishRelay<String>()
    let idRelay = PublishRelay<String>()
    
    var isEmailValid: Observable<Bool> {
        emailRelay
            .map { email in
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailPredicate.evaluate(with: email)
            }
    }
    
    var isPasswordValid: Observable<Bool> {
        passwordRelay
            .map { password in
                let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,}"
                let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                return passwordPredicate.evaluate(with: password)
            }
    }
    
    var isConfirmPasswordValid: Observable<Bool> {
        Observable
            .combineLatest(passwordRelay, passwordConfirmationRelay)
            .map { password, confirmPassword in
                return password == confirmPassword
            }
    }
    
    // 모든 유효성 검사 결과를 결합하여 최종 유효성 검사 결과를 반환하는 Observable
    var isValidPassword: Observable<Bool> {
        Observable
            .combineLatest(isPasswordValid, isConfirmPasswordValid)
            .map { isPasswordValid, isConfirmPasswordValid in
                return isPasswordValid && isConfirmPasswordValid
            }
    }
    
    var isIdValid: Observable<Bool> {
        idRelay
            .map { id in
                return !id.isEmpty
            }
    }
}
