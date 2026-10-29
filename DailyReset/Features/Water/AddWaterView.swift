
import SwiftUI

struct AddWaterView: View {

    @Binding var isPresented: Bool
    @Binding var waterAmountText: String

    let onAdd: (Int) -> Bool

    @State private var showingError = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                VStack(alignment: .leading, spacing: 10) {
                    Text("Количество воды")
                        .font(.headline)

                    TextField("Миллилитры", text: $waterAmountText)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }

                HStack(spacing: 16) {
                    Button("Отмена") {
                        isPresented = false
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("Добавить") {
                        if let amount = Int(waterAmountText),
                           amount > 0 {
                            if onAdd(amount) {
                                waterAmountText = "250"
                                isPresented = false
                            } else {
                                showingError = true
                            }
                        } else {
                            showingError = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(24)
            .alert(
                "Некорректное количество",
                isPresented: $showingError
            ) {
                Button("Понятно", role: .cancel) { }
            } message: {
                Text("Введи целое число миллилитров больше нуля. Если дневная цель достигнута, добавить воду больше нельзя.")
            }
            .navigationTitle("Добавить воду")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
