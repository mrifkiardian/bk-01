//
//  AddItemView.swift
//  MobileInventorySystem
//
//  Created by Rifki Ardian on 09/12/24.
//

import SwiftUI
import PhotosUI

struct AddItemView: View {
    @EnvironmentObject var storage: AppStorageHelper
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var category = ""
    @State private var price = ""
    @State private var stock = ""

    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informasi Barang")) {
                    TextField("Nama Barang", text: $name)
                    TextField("Deskripsi", text: $description)
                    TextField("Kategori", text: $category)
                    TextField("Harga", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Stok", text: $stock)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Foto Barang")) {
                    PhotosPicker(
                        selection: $selectedImageItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let imageData = selectedImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .foregroundColor(.gray)
                                Text("Pilih Foto")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .onChange(of: selectedImageItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tambah Barang")
            .toolbar {
                Button("Simpan") {
                    saveItem()
                }
            }
        }
    }

    private func saveItem() {
        guard let priceValue = Double(price), let stockValue = Int(stock) else { return }

        let imageName = UUID().uuidString
        if let imageData = selectedImageData {
            saveImageToDocuments(imageData: imageData, name: imageName)
        }

        let newItem = Item(
            name: name,
            description: description,
            category: category,
            price: priceValue,
            stock: stockValue,
            imageName: imageName
        )

        storage.items.append(newItem)
        dismiss()
    }

    private func saveImageToDocuments(imageData: Data, name: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(name).png")
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("Error saving image: \(error)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

#Preview {
    AddItemView()
}
