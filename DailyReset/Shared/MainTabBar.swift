
import SwiftUI

struct MainTabBar: View {
    @State private var isShowingWaterInput = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(isShowingWaterInput: $isShowingWaterInput)
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
                .tag(0)

            WaterView()
                .tabItem {
                    Label("Вода", systemImage: "drop.fill")
                }
                .tag(1)

            HabitsView()
                .tabItem {
                    Label("Привычки", systemImage: "checkmark.circle")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape")
                }
                .tag(3)
        }
        .overlay(alignment: .bottom) {
            if isShowingWaterInput {
                Color.clear
                    .frame(height: 60)
                    .contentShape(Rectangle())
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    MainTabBar()
}
