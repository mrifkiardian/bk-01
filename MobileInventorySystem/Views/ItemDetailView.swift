//
//  ItemDetailView.swift
//  MobileInventorySystem
//
//  Created by Rifki Ardian on 09/12/24.
//

import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject var storage: AppStorageHelper
    var item: Item

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Menampilkan Foto Barang
                if let image = loadImageFromDocuments(name: item.imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                }

                // Informasi Barang
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nama Barang:")
                        .font(.headline)
                    Text(item.name)
                        .font(.title2)
                        .bold()

                    Text("Deskripsi:")
                        .font(.headline)
                    Text(item.description)

                    Text("Kategori:")
                        .font(.headline)
                    Text(item.category)

                    Text("Harga:")
                        .font(.headline)
                    Text("\(item.price, specifier: "%.2f")")

                    Text("Stok:")
                        .font(.headline)
                    Text("\(item.stock)")
                }
                .padding()

                // Riwayat Barang
                Divider()
                Text("Riwayat Barang")
                    .font(.headline)
                    .padding(.leading)

                if item.transactions.isEmpty {
                    Text("Belum ada riwayat transaksi.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.leading)
                } else {
                    ForEach(item.transactions) { transaction in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(transaction.type.rawValue)
                                .font(.headline)
                            Text("Jumlah: \(transaction.quantity)")
                            Text("Tanggal: \(transaction.date, formatter: dateFormatter)")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }

                // Tombol Tambah Riwayat
                NavigationLink(destination: AddTransactionView(item: item)) {
                    Text("Tambah Riwayat")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Detail Barang")
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    private func loadImageFromDocuments(name: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(name).png")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        }
        return nil
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

