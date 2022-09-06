import SwiftUI
import Firebase

@main
struct UserAuthenticationApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
