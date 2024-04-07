//
//  Icon.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/07.
//

import UIKit

enum Icon {
    case speechBubble
    case roundSpeechBubble
    case addProfileImage
    case unchecked
    case checked
    case fireworks
    case profileImage
    case back
    case link
    case plus
    case chat
    case account
    
    var image: UIImage? {
        var systemName: String = ""
        var name: String = ""
        switch self {
        case .speechBubble:
            name = "SpeechBubble"
        case .roundSpeechBubble:
            name = "RoundSpeechBubble"
        case .addProfileImage:
            name = "AddProfileImage"
        case .unchecked:
            name = "Unchecked"
        case .checked:
            name = "Checked"
        case .fireworks:
            name = "Fireworks"
        case .profileImage:
            name = "ProfileImage"
        case .back:
            systemName = "chevron.backward"
        case .link:
            systemName = "chevron.forward"
        case .plus:
            systemName = "plus"
        case .chat:
            systemName = "ellipsis.message"
        case .account:
            systemName = "person.crop.circle"
        }
        
        return systemName.isEmpty ? UIImage(named: systemName) : UIImage(systemName: name)
    }
}

