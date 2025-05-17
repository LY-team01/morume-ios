//
//  FilterRepository.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

protocol FilterRepository {
    /// フィルターを登録
    func putFilter(filter: Filter) async throws -> Filter
    /// 自分のフィルターを取得
    func fetchMyFilter() async throws -> Filter
    /// フィルターを取得
    func fetchFilter(userID: Int) async throws -> Filter
}
