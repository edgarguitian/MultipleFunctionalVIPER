//
//  HomeInteractable.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import Foundation
import StoreKit

protocol HomeInteractable {
    func status(for statuses: [Product.SubscriptionInfo.Status], ids: PassIdentifiers) -> PassStatus
    func process(transaction verificationResult: VerificationResult<Transaction>) async -> [String]
    func checkForUnfinishedTransactions() async
    func observeTransactionUpdates() async
    func logOut() async -> Result<Bool, Error>
}
