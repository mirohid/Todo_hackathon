import SwiftUI
internal import CoreData

@main
struct Todo_hackathonApp: App {
    let persistence = CoreDataStack.shared

    @AppStorage("appearance") private var appearance: String = "system"

    private var resolvedColorScheme: ColorScheme? {
        switch appearance {
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return nil
        }
    }

       var body: some Scene {
           WindowGroup {
               TodayTasksView(
                   viewModel: TodayTasksViewModel(
                       context: persistence.container.viewContext
                   )
               )
               .preferredColorScheme(resolvedColorScheme)
           }
       }
}
