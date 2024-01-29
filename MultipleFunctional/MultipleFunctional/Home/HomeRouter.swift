//
//  HomeRouter.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import Foundation

class HomeRouter: HomeRouting {
    func createHome(authPresenter: AuthPresenter) -> HomeView {
        let interactor = HomeInteractor()
        let presenter = HomePresenter(homeInteractor: interactor, authPresenter: authPresenter, router: self)
        let homeView = HomeView(presenter: presenter)
        return homeView
    }

    func createShopView() -> ShopView {
        let shopView = ShopView()
        return shopView
    }

    func createNoteView() -> NoteView {
        let interactor = NoteInteractor()
        let presenter = NotePresenter(getNotesInteractor: interactor,
                                      createNoteInteractor: interactor,
                                      deleteNoteInteractor: interactor)
        let noteView = NoteView(presenter: presenter)
        return noteView
    }
}
