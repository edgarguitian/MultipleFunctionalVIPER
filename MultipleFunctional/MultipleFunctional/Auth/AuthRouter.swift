//
//  AuthRouter.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 22/1/24.
//

import Foundation

class AuthRouter: AuthRouting {
    var presenter: AuthPresenter?

    func createAuth() -> AuthView {
        let interactor = AuthInteractor()
        presenter = AuthPresenter(authInteractor: interactor,
                                  authLoginMailInteractor: interactor,
                                  authLoginAppleInteractor: interactor,
                                  authRegisterInteractor: interactor,
                                  router: self)
        guard let presenter = presenter else {
            fatalError()
        }
        let authView = AuthView(presenter: presenter)
        return authView
    }

    func showLogin() -> LoginView {
        guard let presenter = presenter else {
            fatalError()
        }
        let loginView = LoginView(presenter: presenter)
        return loginView
    }

    func showRegister() -> RegisterView {
        guard let presenter = presenter else {
            fatalError()
        }
        let regsiterView = RegisterView(presenter: presenter)
        return regsiterView
    }

    func showHome() -> HomeView {
        guard let presenter = presenter else {
            fatalError()
        }
        return HomeRouter().createHome(authPresenter: presenter)
    }
}
