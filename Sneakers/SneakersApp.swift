import SwiftUI

@main
struct SneakersApp: App {
    var body: some Scene {
        WindowGroup {
            SneakersView(sneakers: .data)
        }
    }
}
