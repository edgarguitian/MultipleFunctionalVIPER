//
//  AuthInteractor.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 22/1/24.
//

import Foundation
import FirebaseAuth

class AuthInteractor: AuthInteractable {
    func getUser() async -> User? {
        guard let email = Auth.auth().currentUser?.email else {
            return nil
        }
        return User(email: email)
    }
}

extension AuthInteractor: AuthLoginMailInteractable {
    func loginMail(email: String, password: String) async -> Result<User, Error> {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email,
                                                                  password: password)

            guard let emailAuthResult = authDataResult.user.email else {
                return .failure(NSError(domain: "YourDomain", code: -1, userInfo: nil))
            }
            let user = User(email: emailAuthResult)

            return .success(user)
        } catch {
            return .failure(error)
        }
    }

}

extension AuthInteractor: AuthLoginAppleInteractable {
    func logInApple(credential: AuthCredential) async -> Result<User, Error> {
        do {
            let authDataResult = try await Auth.auth().signIn(with: credential)

            guard let emailAuthResult = authDataResult.user.email else {
                return .failure(NSError(domain: "YourDomain", code: -1, userInfo: nil))
            }
            let user = User(email: emailAuthResult)

            return .success(user)
        } catch {
            return .failure(error)
        }
    }

}

extension AuthInteractor: AuthRegisterMailInteractable {
    func createNewUser(email: String, password: String) async -> Result<User, Error> {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email,
                                                                  password: password)

            guard let emailAuthResult = authDataResult.user.email else {
                return .failure(NSError(domain: "YourDomain", code: -1, userInfo: nil))
            }
            let user = User(email: emailAuthResult)

            return .success(user)
        } catch {
            return .failure(error)
        }
    }

}
