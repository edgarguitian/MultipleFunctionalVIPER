//
//  HomePresenter.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import Foundation
import StoreKit
import SwiftUI

class HomePresenter: ObservableObject {
    private let homeInteractor: HomeInteractable
    let authPresenter: AuthPresenter
    private let router: HomeRouting

    init(homeInteractor: HomeInteractable, authPresenter: AuthPresenter, router: HomeRouting) {
        self.homeInteractor = homeInteractor
        self.authPresenter = authPresenter
        self.router = router
    }

    func status(for statuses: [Product.SubscriptionInfo.Status], ids: PassIdentifiers) -> PassStatus {
        return homeInteractor.status(for: statuses, ids: ids)
    }

    func observeTransactionUpdates() {
        Task {
            homeInteractor.observeTransactionUpdates
        }
    }

    func process(transaction verificationResult: VerificationResult<StoreKit.Transaction>) {
        Task {
            await homeInteractor.process(transaction: verificationResult)
        }
    }

    func checkForUnfinishedTransactions() {
        Task {
            homeInteractor.checkForUnfinishedTransactions
        }
    }

    func createShopView() -> ShopView {
        return router.createShopView()
    }

    func createNoteView() -> NoteView {
        return router.createNoteView()
    }

    func logOut() {
        Task {
            let result = await homeInteractor.logOut()
            handleResultLogOut(result)
        }
    }

    func handleResultLogOut(_ result: Result<Bool, Error>) {
        switch result {
            case .success:
                Task { @MainActor in
                    authPresenter.user = nil
                }
            case .failure:
                print("Error logOut")
            }

    }
}
