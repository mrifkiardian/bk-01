//
//  MobileInventorySystemApp.swift
//  MobileInventorySystem
//
//  Created by Rifki Ardian on 09/12/24.
//

import SwiftUI

@main
struct MobileInventorySystemApp: App {
    @StateObject private var storage = AppStorageHelper()
    
    var body: some Scene {
        WindowGroup {
            ItemListView()
                .environmentObject(storage)
        }
    }
}
