//
//  AuthInteractable.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 22/1/24.
//

import Foundation
import FirebaseAuth

protocol AuthInteractable {
    func getUser() async -> User?
}

protocol AuthLoginMailInteractable {
    func loginMail(email: String, password: String) async -> Result<User, Error>
}

protocol AuthLoginAppleInteractable {
    func logInApple(credential: AuthCredential) async -> Result<User, Error>
}

protocol AuthRegisterMailInteractable {
    func createNewUser(email: String, password: String) async -> Result<User, Error>
}
