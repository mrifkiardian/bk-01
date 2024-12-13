//
//  Item.swift
//  MobileInventorySystem
//
//  Created by Rifki Ardian on 09/12/24.
//

import Foundation

struct Item: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var category: String
    var price: Double
    var stock: Int
    var imageName: String
    var transactions: [Transaction] = []
}

struct Transaction: Identifiable, Codable {
    var id: UUID = UUID()
    var type: TransactionType
    var quantity: Int
    var date: Date = Date()
}

enum TransactionType: String, Codable, CaseIterable {
    case inStock = "Barang Masuk"
    case outStock = "Barang Keluar"
}
