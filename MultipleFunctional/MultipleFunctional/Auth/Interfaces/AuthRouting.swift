//
//  AuthRouting.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 22/1/24.
//

import Foundation

protocol AuthRouting {
    func createAuth() -> AuthView
    func showLogin() -> LoginView
    func showHome() -> HomeView
    func showRegister() -> RegisterView
}
