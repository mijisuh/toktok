//
//  SignInViewModel.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/15.
//

import UIKit
import RxSwift
import RxCocoa

struct SignInViewModel {
    let emailRelay = PublishRelay<String>()
    let passwordRelay = PublishRelay<String>()
    
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
    
    var isValidUser: Observable<Bool> {
        Observable
            .combineLatest(isEmailValid, isPasswordValid)
            .map { isPasswordValid, isConfirmPasswordValid in
                return isPasswordValid && isConfirmPasswordValid
            }
    }
}
