//
//  ExamplesApp.swift
//  Examples
//
//  Created by Stanislau Parechyn on 24.12.2021.
//
import ComposableArchitecture
import SwiftUI
@_exported import UIClient

@main
struct ExamplesApp: App {
    let store: Store<MainState, MainAction> = .init(initialState: .init(),
                                                    reducer: MainReducer,
                                                    environment: .init())
    var body: some Scene {
        WindowGroup {
            MainView(store: store)
        }
    }
}
