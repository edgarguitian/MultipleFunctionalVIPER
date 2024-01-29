//
//  AuthView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 22/1/24.
//

import SwiftUI
import AuthenticationServices

enum AuthenticationSheetView: String, Identifiable {
    case register
    case login

    var id: String {
        return rawValue
    }
}

struct AuthView: View {
    @ObservedObject private var presenter: AuthPresenter
    @State private var authenticationSheetView: AuthenticationSheetView?
    @Environment(\.colorScheme) var colorScheme

    init(presenter: AuthPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        VStack {
            if presenter.showLoadingSpinner {
                CustomLoadingView()
            } else {
                if presenter.user != nil {
                    presenter.showHome()
                } else {
                    VStack {
                        Text("MultipleFunctional")
                            .bold()
                            .font(.title)
                            .padding(.top, 100)
                            .accessibilityIdentifier("textTitleAuthenticationView")

                        VStack {
                            Button {
                                authenticationSheetView = .login
                            } label: {
                                Label("emailLogin", systemImage: "envelope.fill")
                            }
                            .frame(width: 250, height: 60)
                            .cornerRadius(45)
                            .accessibilityIdentifier("btnLoginMailAuthenticationView")
                            .tint(.auth)

                            SignInWithAppleButton(.continue,
                                                  onRequest: { (request) in
                                request.requestedScopes = [.email, .fullName]

                            },
                                                  onCompletion: { result in
                                presenter.handleSignInAppleResult(result)
                            })
                            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                            .frame(width: 180, height: 50)
                            .cornerRadius(45)
                            .padding(.top, 20)
                            .accessibilityIdentifier("btnLoginAppleAuthenticationView")

                            Button {
                                presenter.authenticateBiometric()
                            } label: {
                                Label("faceIdLogin", systemImage: "faceid")
                            }
                            .frame(width: 250, height: 60)
                            .cornerRadius(45)
                            .accessibilityIdentifier("btnFaceIdAuthenticationView")
                            .tint(.auth)
                            .padding(.top, 20)

                            if presenter.showErrorMessage != nil {
                                Text(presenter.showErrorMessage!)
                                    .bold()
                                    .font(.body)
                                    .foregroundColor(.red)
                                    .padding(.top, 20)
                                    .accessibilityIdentifier("authenticationViewErrorMessage")
                            }

                        }
                        .controlSize(.extraLarge)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .padding(.top, 60)

                        Spacer()

                        HStack {
                            Button {
                                authenticationSheetView = .register
                            } label: {
                                Text("notaccount")
                                Text("register")
                                    .underline()
                            }
                            .accessibilityIdentifier("btnRegisterAuthenticationView")
                            .tint(.auth)
                        }
                    }
                    .sheet(item: $authenticationSheetView) { sheet in
                        switch sheet {
                        case .register:
                            presenter.showRegister()
                        case .login:
                            presenter.showLogin()
                        }
                    }

                }
            }

        }
        .onAppear {
            let uiTestInitialLoading = ProcessInfo.processInfo.arguments.contains("UITestInitialLoading")
            if uiTestInitialLoading {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    presenter.getCurrentUser()
                        }
            } else {
                presenter.getCurrentUser()
            }
        }
    }
}

#Preview {
    AuthRouter().createAuth()
}
