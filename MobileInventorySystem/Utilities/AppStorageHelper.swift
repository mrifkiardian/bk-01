//
//  AppStorageHelper.swift
//  MobileInventorySystem
//
//  Created by Rifki Ardian on 09/12/24.
//

import Foundation

class AppStorageHelper: ObservableObject {
    @Published var items: [Item] {
        didSet {
            saveToStorage()
        }
    }
    
    init() {
        self.items = Self.loadFromStorage()
    }
    
    private static func loadFromStorage() -> [Item] {
        if let data = UserDefaults.standard.data(forKey: "items"),
           let decoded = try? JSONDecoder().decode([Item].self, from: data) {
            return decoded
        }
        return []
    }
    
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "items")
        }
    }
}
