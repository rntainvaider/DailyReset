import SwiftUI

struct MainTabBar: View {
    var body: some View {
        TabView {
            WaterView()
                .tabItem{
                    Label("Вода", systemImage: "drop.fill")
                }
            
            HabitsView()
                .tabItem{
                    Label("Привычки", systemImage: "checkmark.circle")
                }
            
            SettingsView()
                .tabItem{
                    Label("Настройки", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabBar()
}
