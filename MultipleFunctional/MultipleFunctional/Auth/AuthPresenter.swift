//
//  AuthPresenter.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 22/1/24.
//

import Foundation
import LocalAuthentication
import AuthenticationServices
import FirebaseAuth

class AuthPresenter: ObservableObject {
    private let authInteractor: AuthInteractable
    private let authLoginMailInteractor: AuthLoginMailInteractable
    private let authLoginAppleInteractor: AuthLoginAppleInteractable
    private let authRegisterInteractor: AuthRegisterMailInteractable
    private let router: AuthRouting

    @Published var user: User?
    @Published var showErrorMessage: String?
    @Published var showErrorMessageLogin: String?
    @Published var showErrorMessageRegister: String?
    @Published var showLoadingSpinner: Bool = true

    init(authInteractor: AuthInteractable,
         authLoginMailInteractor: AuthLoginMailInteractable,
         authLoginAppleInteractor: AuthLoginAppleInteractable,
         authRegisterInteractor: AuthRegisterMailInteractable,
         router: AuthRouting) {
        self.authInteractor = authInteractor
        self.authLoginAppleInteractor = authLoginAppleInteractor
        self.authLoginMailInteractor = authLoginMailInteractor
        self.authRegisterInteractor = authRegisterInteractor
        self.router = router
    }

    func getCurrentUser() {
        Task {
            let user = await authInteractor.getUser()
            self.user = user
            showLoadingSpinner = false
        }
    }

    func authenticateBiometric() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Por favor autentícate para poder continuar") { success, error in

                self.readBiometric(success: success, error: error)
            }
        } else {
            readBiometric(success: false, error: nil)
        }
    }

    func readBiometric(success: Bool, error: Error?) {
        if success {
            Task {
                let result = await authLoginMailInteractor.loginMail(email: "biometricUser@gmail.com",
                                                        password: "passBiometric")
                handleResult(result, fromLogin: false)
            }
        } else {
            if let error = error {
                showErrorMessage = error.localizedDescription
            } else {
                showErrorMessage = "No biometrics supported"
            }
        }
    }

    func handleResult(_ result: Result<User, Error>, fromLogin: Bool) {
        guard case .success(let loginResult) = result else {
            Task { @MainActor in
                showErrorMessage = "Login fail"
            }
            return
        }

        Task { @MainActor in
            showLoadingSpinner = false
            self.user = loginResult
        }
    }

    func showHome() -> HomeView {
        router.showHome()
    }

    /**
     Handle the result of Sign In with Apple
     */
    func handleSignInAppleResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            switch auth.credential {
            case let credential as ASAuthorizationAppleIDCredential:
                logInApple(credential: credential)
                print("")
            default:
                showErrorMessage = "No se pudo continuar con la cuenta de Apple"
            }
        case .failure(let error):
            showErrorMessage = error.localizedDescription
        }
    }

    func showLogin() -> LoginView {
        router.showLogin()
    }

    func showRegister() -> RegisterView {
        router.showRegister()
    }

    func logInApple(credential: ASAuthorizationAppleIDCredential) {
        showLoadingSpinner = true
        Task {
            let token = credential.identityToken ?? Data()
            let appleCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                           idToken: String(data: token, encoding: .utf8)!,
                                                           rawNonce: nil)
            let result = await authLoginAppleInteractor.logInApple(credential: appleCredential)
            handleResult(result, fromLogin: true)
        }
    }

    /**
     Logs in a user with the provided email and password.
     */
    func logInEmail(email: String, password: String) {
        // showLoadingSpinner = true
        Task {
            let result = await authLoginMailInteractor.loginMail(email: email,
                                                    password: password)
            handleResult(result, fromLogin: false)
        }
    }

    /**
     Creates a new user with the provided email and password.
     */
    func createNewUser(email: String, password: String) {
        // showLoadingSpinner = true
        Task {
            let result = await authRegisterInteractor.createNewUser(email: email,
                                                    password: password)
            handleResult(result, fromLogin: false)
        }
    }
}
