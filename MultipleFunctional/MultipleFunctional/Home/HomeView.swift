//
//  HomeView.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 29/1/24.
//

import SwiftUI
import StoreKit

struct HomeView: View {

    @ObservedObject private var presenter: HomePresenter

    @State private var showScriptionView: Bool = false
    @State private var presentingSubscriptionSheet = false
    @State private var status: EntitlementTaskState<PassStatus> = .loading
    @Environment(\.passIDs) private var passIDs
    @Environment(PassStatusModel.self) var passStatusModel: PassStatusModel
    @EnvironmentObject var store: StoreManager

    init(presenter: HomePresenter) {
        self.presenter = presenter
    }

    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    Text("welcome \(presenter.authPresenter.user?.email ?? "No user")")
                        .padding(.top, 32)
                        .accessibilityIdentifier("titleHomeView")
                    Spacer()

                    List {
                        Section {
                            planView

                            if passStatusModel.passStatus == .notSubscribed {
                                Button {
                                    showScriptionView.toggle()
                                } label: {
                                    Text("viewSubsOptions")
                                        .foregroundStyle(Color.blue)
                                }
                                .accessibilityIdentifier("btnShopSubHomeView")
                            }
                        } header: {
                            Text("SUBSCRIPTION")
                        } footer: {
                            if passStatusModel.passStatus != .notSubscribed {
                                Text("Unique Subscription Plan: " +
                                     "\(String(describing: passStatusModel.passStatus.description))")

                            }
                        }

                        Section {
                            ProductView(id: Constants.idProduct) {
                                Image(systemName: store.hasPurchasedProduct ? "crown.fill" : "crown")
                                    .accessibilityIdentifier("imageBtnProd")
                            }
                            .onInAppPurchaseStart { product in
                                print("User has started buying \(product.id)")
                            }
                            .onInAppPurchaseCompletion { (product, result) in
                                if case .success(.success) = result {
                                    _ = await store.purchase(product)
                                }
                            }
                            .storeButton(.visible, for: .restorePurchases)
                            .productViewStyle(.compact)
                            .padding()
                            .accessibilityIdentifier("btnShopProdHomeView")
                        } header: {
                            Text("PRODUCT")
                        }
                    }
                    .sheet(isPresented: $showScriptionView, content: {
                        presenter.createShopView()
                    })

                    Spacer()

                }
                .tabItem {
                    Label("homeTitle", systemImage: "house.fill")
                }

                presenter.createNoteView()
                .tabItem {
                    Label("notes", systemImage: "link")
                        .accessibilityIdentifier("tabNotes")
                }

            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("homeTitle")
            .toolbar {
                Button("Logout") {
                    presenter.logOut()
                }
                .accessibilityIdentifier("btnLogout")
            }

        }
        .manageSubscriptionsSheet(
            isPresented: $presentingSubscriptionSheet,
            subscriptionGroupID: passIDs.group
        )
        .subscriptionStatusTask(for: passIDs.group) { taskStatus in
            self.status = taskStatus.map { statuses in
                presenter.status(
                    for: statuses,
                    ids: passIDs
                )
            }
            switch self.status {
            case .failure(let error):
                passStatusModel.passStatus = .notSubscribed
                print("Failed to check subscription status: \(error)")
            case .success(let status):
                passStatusModel.passStatus = status
            case .loading: break
            @unknown default: break
            }
        }
        .task {
            presenter.observeTransactionUpdates()
            presenter.checkForUnfinishedTransactions()
        }
    }

}

/*
#Preview {
    HomeRouter().createHome(authPresenter: AuthPresenter())
}*/

extension HomeView {
    @ViewBuilder
    var planView: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Image(systemName: "crown")
                VStack(alignment: .leading) {
                    Text(passStatusModel.passStatus == .notSubscribed ?
                         "subTitle":
                            "Unique Subscription Plan: \(passStatusModel.passStatus.description)")
                        .font(.system(size: 17))
                    Text(passStatusModel.passStatus == .notSubscribed ?
                         "subsDescription":
                            "subDescriptionBought")
                        .font(.system(size: 15))
                        .foregroundStyle(.gray)
                }
            }
            if passStatusModel.passStatus != .notSubscribed {
                Button("Handle Subscription \(Image(systemName: "chevron.forward"))") {
                    self.presentingSubscriptionSheet = true
                }
                .foregroundStyle(Color.blue)
                .accessibilityIdentifier("btnSubscriptionActiveHomeView")
            }
        }
    }
}
