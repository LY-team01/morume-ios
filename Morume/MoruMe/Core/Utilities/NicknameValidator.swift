//
//  NicknameValidator.swift
//  MoruMe
//
//  Created by System on 2025/06/08.
//

import Foundation

/// ニックネームのバリデーションを行うクラス
final class NicknameValidator {

    /// ニックネームの最小文字数
    static let minimumLength = 1

    /// ニックネームの最大文字数
    static let maximumLength = 20

    /// 使用可能な文字のパターン（ひらがな、カタカナ、漢字、英数字、スペース）
    private static let allowedCharacterPattern = "^[\\p{Hiragana}\\p{Katakana}\\p{Han}a-zA-Z0-9\\s]+$"

    /// ニックネームをバリデーションする
    /// - Parameter nickname: バリデーション対象のニックネーム
    /// - Throws: ValidationError
    static func validate(_ nickname: String) throws {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        // 空文字チェック
        if trimmedNickname.isEmpty {
            throw ValidationError.emptyNickname
        }

        // 文字数チェック
        if trimmedNickname.count < minimumLength {
            throw ValidationError.nicknameTooShort
        }

        if trimmedNickname.count > maximumLength {
            throw ValidationError.nicknameTooLong
        }

        // 文字種チェック
        let regex = try NSRegularExpression(pattern: allowedCharacterPattern)
        let range = NSRange(location: 0, length: trimmedNickname.utf16.count)

        if regex.firstMatch(in: trimmedNickname, options: [], range: range) == nil {
            throw ValidationError.invalidCharacters
        }
    }

    /// ニックネームが有効かどうかを確認する（例外を投げない版）
    /// - Parameter nickname: 確認対象のニックネーム
    /// - Returns: 有効な場合はtrue
    static func isValid(_ nickname: String) -> Bool {
        do {
            try validate(nickname)
            return true
        } catch {
            return false
        }
    }
}
