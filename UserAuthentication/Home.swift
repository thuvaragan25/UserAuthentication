import SwiftUI
import Firebase

struct Home: View {
    @Binding var userisLoggedIn: Bool
    @State private var showPopup = false

    var body: some View {
        NavigationView{
            
            VStack {
                Button("Log Out"){
                    try? Auth.auth().signOut()
                    self.userisLoggedIn = false
                }
            }
        }
    }
}
