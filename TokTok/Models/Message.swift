//
//  Message.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/08.
//

import Foundation

struct Message {
    let id: String
    let contents: String
    let time: String
    let type: ChatType
}

enum ChatType {
    case send
    case receive
}
