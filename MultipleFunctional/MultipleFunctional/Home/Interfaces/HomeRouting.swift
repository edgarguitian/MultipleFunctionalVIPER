//
//  HomeRouting.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import Foundation

protocol HomeRouting {
    func createHome(authPresenter: AuthPresenter) -> HomeView
    func createShopView() -> ShopView
    func createNoteView() -> NoteView
}
