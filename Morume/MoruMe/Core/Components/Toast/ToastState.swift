// ToastState.swift
// トーストの内容をまとめて管理する構造体
import SwiftUI

struct ToastState: Equatable, Identifiable {
    let id = UUID()
    let icon: ImageResource
    let message: String
    let type: ToastType

    init(icon: ImageResource, message: String, type: ToastType) {
        self.icon = icon
        self.message = message
        self.type = type
    }
}
