import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var waterAmountText = "250"
    
    @Query private var entries: [WaterEntry]

    private var todayAmount: Int {
        entries
            .filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.amount }
    }
    
    @Binding var isShowingWaterInput: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                Text("Daily Reset")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Маленькие шаги — большие перемены.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                WaterSummaryCard(isShowingWaterInput: $isShowingWaterInput)
                    .padding(.top, 16)
            }
            .padding()
            .allowsHitTesting(!isShowingWaterInput)

            if isShowingWaterInput {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    AddWaterView(
                        isPresented: $isShowingWaterInput,
                        waterAmountText: $waterAmountText
                    ) { amount in
                        let remainingAmount = max(0, 2000 - todayAmount)
                        let amountToAdd = min(amount, remainingAmount)

                        guard amountToAdd > 0 else {
                            return false
                        }

                        let entry = WaterEntry(amount: amountToAdd)
                        modelContext.insert(entry)
                        return true
                    }
                    .frame(width: 320, height: 260)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isShowingWaterInput)
    }
}

#Preview {
    HomeView(isShowingWaterInput: .constant(false))
}
