//
//  ItemListView.swift
//  MobileInventorySystem
//
//  Created by Rifki Ardian on 09/12/24.
//

import SwiftUI

struct ItemListView: View {
    @EnvironmentObject var storage: AppStorageHelper
    @State private var showAddItem = false

    var body: some View {
        NavigationView {
            List(storage.items) { item in
                NavigationLink(destination: ItemDetailView(item: item)) {
                    HStack {
                        if let image = loadImageFromDocuments(name: item.imageName) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text("Stok: \(item.stock)").font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Daftar Barang")
            .toolbar {
                Button(action: {
                    showAddItem.toggle()
                }) {
                    Label("Tambah Barang", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddItemView()
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func loadImageFromDocuments(name: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(name).png")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        }
        return nil
    }
}
