//
//  LoginView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var presenter: AuthPresenter
    @State var textFieldEmail: String = ""
    @State var textFieldPassword: String = ""
    @State var showPassword: Bool = false
    @FocusState var focus1: Bool
    @FocusState var focus2: Bool

    init(presenter: AuthPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        VStack {
            DismissView()
                .padding(.top, 8)
            Group {
                Text("welcomeagainto")
                Text("MultipleFunctional")
                    .bold()
                    .underline()
            }
            .accessibilityIdentifier("groupTitleLoginView")
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .tint(.primary)

            Group {
                Text("emailLoginTitle")
                    .tint(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
                    .padding(.bottom, 2)
                    .accessibilityIdentifier("textDescriptionLoginView")

                TextField("emailPlaceholder", text: $textFieldEmail)
                    .autocapitalization(.none)
                    .accessibilityIdentifier("fieldEmailLoginView")

                HStack {
                        ZStack(alignment: .trailing) {
                            TextField("passwordPlaceholder", text: $textFieldPassword)
                                .modifier(LoginModifier())
                                .textContentType(.password)
                                .focused($focus1)
                                .opacity(showPassword ? 1 : 0)
                                .accessibilityIdentifier("fieldPassLoginView")

                            SecureField("passwordPlaceholder", text: $textFieldPassword)
                                .modifier(LoginModifier())
                                .textContentType(.password)
                                .focused($focus2)
                                .opacity(showPassword ? 0 : 1)
                                .accessibilityIdentifier("secureFieldPassLoginView")

                            Button(action: {
                                showPassword.toggle()
                                if showPassword { focus1 = true } else { focus2 = true }
                            }, label: {
                                Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                                    .font(.system(size: 16, weight: .regular))
                                    .padding()
                            })
                            .accessibilityIdentifier("btnShowPassLogin")
                        }
                    }

                Button("login") {
                    presenter.logInEmail(email: textFieldEmail, password: textFieldPassword)
                }
                .accessibilityIdentifier("btnLoginEmailLoginView")
                .padding(.top, 18)
                .buttonStyle(.bordered)
                .tint(.blue)

                if let messageError = presenter.showErrorMessageLogin {
                    Text(messageError)
                        .bold()
                        .font(.body)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                        .accessibilityIdentifier("loginViewErrorMessage")
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 64)
            Spacer()
        }
        .onAppear {
            presenter.showErrorMessageLogin = nil
        }

    }
}

#Preview {
    AuthRouter().showLogin()
}
