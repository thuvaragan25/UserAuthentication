import SwiftUI
import Firebase

enum ActiveAlert {
    case first, second
}

struct ContentView: View {

    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    @State private var userIsLoggedIn = false
    @State private var showAlert = false

    @State private var shouldShowLoginAlert: Bool = false
    @State private var shouldShowSignUpAlert: Bool = false

    @State private var activeAlert: ActiveAlert = .first
    
    var body: some View {
        if userIsLoggedIn{
            Home(userisLoggedIn: $userIsLoggedIn)
        }
        else{
            content
        }
    }
    var content: some View {
        NavigationView {
            ScrollView {

                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())

                    if !isLoginMode {
                        Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                                .foregroundColor(.blue)
                    }

                    Group {
                        HStack{
                            Image(systemName: "envelope").foregroundColor(.gray)
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                        }
                            .autocapitalization(.none)
                        HStack{
                            Image(systemName: "lock").foregroundColor(.gray)
                            SecureField("Password", text: $password)
                        }
                    }
                    .padding(12)
                    .background(Color.white)

                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                        .cornerRadius(20)

                    }
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()

            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
            .alert(isPresented: $showAlert) {
                switch activeAlert{
                case .first:
                    return Alert(title: Text("Email/Password Is Incorrect"), message: Text("Try again with a valid email and password, if you do not have an account, please sign up"))
                
                case .second:
                    return Alert(title: Text("Failed To Create An Account"), message: Text("Try again, ensure your email is a valid email and your password is more than 8 characters. If you already have an account login"))
                }
            }
            .onAppear{
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil{
                        email = ""
                        password = ""
                        userIsLoggedIn = true
                    }
                    
                }
            }
        }
    }

    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    private func loginUser(){
        Auth.auth().signIn(withEmail: email, password: password){
            result, err in
            if err != nil {
                self.activeAlert = .first
                self.showAlert = true
                return
            }
        }

    }

    @State var loginStatusMessage = ""

    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password){
            result, err in
            if err != nil {
                self.activeAlert = .second
                self.showAlert = true
                
                return
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

