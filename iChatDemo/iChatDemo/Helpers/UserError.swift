//
//  UserError.swift
//  iChatDemo
//
//  Created by Admin on 27.03.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
    case profileNotExist
    case documentConversionFailed
    case photoScaleFailed
    case photoCompressionFailed
    case userNotAuthorized
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Добавьте фотографию", comment: "")
        case .profileNotExist:
            return NSLocalizedString("Профиль не найден", comment: "")
        case .documentConversionFailed:
            return NSLocalizedString("Ошибка конвертации модели пользователя", comment: "")
        case .photoScaleFailed:
            return NSLocalizedString("Ошибка масштабирования фотографии", comment: "")
            case .photoCompressionFailed:
            return NSLocalizedString("Ошибка сжатия фотографии", comment: "")
        case .userNotAuthorized:
            return NSLocalizedString("Пользователь не авторизован", comment: "")
        }
    }
}
