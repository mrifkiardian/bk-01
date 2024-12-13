//
//  AddTransactionView.swift
//  MobileInventorySystem
//
//  Created by Rifki Ardian on 09/12/24.
//

import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var storage: AppStorageHelper
    @Environment(\.dismiss) var dismiss
    var item: Item
    @State private var transactionType: TransactionType = .inStock
    @State private var quantity = ""

    var body: some View {
        NavigationView {
            Form {
                // Jenis Transaksi
                Section(header: Text("Jenis Transaksi")) {
                    Picker("Jenis Transaksi", selection: $transactionType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // Jumlah Barang
                Section(header: Text("Jumlah Barang")) {
                    TextField("Masukkan jumlah barang", text: $quantity)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Tambah Riwayat")
            .toolbar {
                Button("Simpan") {
                    saveTransaction()
                }
            }
        }
    }

    private func saveTransaction() {
        if let index = storage.items.firstIndex(where: { $0.id == item.id }),
           let quantityValue = Int(quantity) {
            // Buat transaksi baru
            let transaction = Transaction(
                type: transactionType,
                quantity: quantityValue
            )

            // Tambahkan transaksi ke barang
            storage.items[index].transactions.append(transaction)

            // Perbarui stok barang
            if transactionType == .inStock {
                storage.items[index].stock += quantityValue
            } else {
                storage.items[index].stock -= quantityValue
            }

            dismiss()
        }
    }
}

