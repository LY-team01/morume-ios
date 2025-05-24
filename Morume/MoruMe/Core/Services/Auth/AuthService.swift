//
//  AuthService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

protocol AuthService {
    func login() async throws
    func getToken() async throws -> String
}
