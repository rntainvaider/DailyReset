
import SwiftUI
import SwiftData

struct WaterSummaryCard: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [WaterEntry]

    @Binding var isShowingWaterInput: Bool
    @State private var showGoalCompleted = false

    private let dailyGoal = 2000

    private var todayAmount: Int {
        entries
            .filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.amount }
    }

    private var remainingAmount: Int {
        max(0, dailyGoal - todayAmount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "drop.fill")
                    .font(.title2)
                    .foregroundStyle(Color(red: 0.16, green: 0.47, blue: 0.82))
                    .frame(width: 44, height: 44)
                    .background(Color(red: 0.84, green: 0.92, blue: 1.0))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Вода за сегодня")
                        .font(.headline)
                        .foregroundStyle(Color(red: 0.09, green: 0.21, blue: 0.33))

                    Text("Твоя ежедневная цель")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text("\(min(todayAmount, dailyGoal))")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color(red: 0.09, green: 0.21, blue: 0.33))

                Text("/ \(dailyGoal) мл")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(red: 0.84, green: 0.90, blue: 0.96))

                        Capsule()
                            .fill(Color(red: 0.22, green: 0.53, blue: 0.91))
                            .frame(
                                width: geometry.size.width
                                    * min(CGFloat(todayAmount) / CGFloat(dailyGoal), 1)
                            )
                    }
                }
                .frame(height: 12)
                .animation(.easeInOut(duration: 0.6), value: todayAmount)

                HStack {
                    Text("\(Int(Double(min(todayAmount, dailyGoal)) / Double(dailyGoal) * 100))% выполнено")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(red: 0.22, green: 0.53, blue: 0.91))

                    Spacer()

                    Text("Осталось \(remainingAmount) мл")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if todayAmount >= dailyGoal {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                        Text("Цель выполнена!")
                            .fontWeight(.medium)
                            .foregroundStyle(.green)
                    }

                    Text("Отличная работа — ты выполнил дневную цель.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .scaleEffect(showGoalCompleted ? 1.0 : 0.85, anchor: .leading)
                .opacity(showGoalCompleted ? 1.0 : 0.0)
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        showGoalCompleted = true
                    }
                }
                .onDisappear {
                    showGoalCompleted = false
                }
            } else {
                Button {
                    isShowingWaterInput = true
                } label: {
                    Label("Добавить воду", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Color(red: 0.22, green: 0.53, blue: 0.91)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)


                HStack(spacing: 6) {
                    quickAddButton(200)
                    quickAddButton(250)
                    quickAddButton(330)
                    quickAddButton(500)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(20)
        .background(
            Color(red: 0.94, green: 0.97, blue: 1.0)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func quickAddButton(_ amount: Int) -> some View {
        Button {
            let amountToAdd = min(amount, remainingAmount)

            if amountToAdd > 0 {
                let entry = WaterEntry(amount: amountToAdd)
                modelContext.insert(entry)
            }
        } label: {
            Text("\(amount) мл")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(red: 0.16, green: 0.41, blue: 0.68))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color(red: 0.84, green: 0.90, blue: 0.96),
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WaterSummaryCard(isShowingWaterInput: .constant(false))
}
