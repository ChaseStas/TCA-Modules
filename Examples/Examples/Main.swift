//
//  Main.swift
//  Examples
//
//  Created by Stanislau Parechyn on 24.12.2021.
//

import ComposableArchitecture
import IDFA
import SwiftUI
import UIClient_Toast

struct MainState: Equatable {
    fileprivate let testURL: String = "https://google.com"

    let items: IdentifiedArrayOf<Section> = [
        .init(title: "UIClient", items: [
            .init(text: "Copy random text", action: .didTap(.copyToClipboard)),
            .init(text: "Rate us", action: .didTap(.rateUs)),
            .init(text: "Share activity", action: .didTap(.shareActivity)),
        ]),
        .init(title: "URLs", items: [
            .init(text: "Open URL in app", action: .didTap(.openUrlInApp)),
            .init(text: "Open URL in safari", action: .didTap(.openUrlInSafari))
        ]),
        .init(title: "System Vibration", items: [
            .init(text: "Strong", action: .didTap(.systemVibration(.strong))),
            .init(text: "Strong Boom", action: .didTap(.systemVibration(.strongBoom))),
            .init(text: "Weak", action: .didTap(.systemVibration(.weak))),
            .init(text: "Weak Boom", action: .didTap(.systemVibration(.weakBoom)))
        ]),
        .init(title: "Haptic Vibration", items: [
            .init(text: "Impact 1.0", action: .didTap(.hapticVibration(.impact))),
            .init(text: "Impact 0.7", action: .didTap(.hapticVibration(.impactIntensifity(0.7)))),
            .init(text: "Impact 0.5", action: .didTap(.hapticVibration(.impactIntensifity(0.5)))),
            .init(text: "Impact 0.3", action: .didTap(.hapticVibration(.impactIntensifity(0.3)))),
            .init(text: "Notification Error", action: .didTap(.hapticVibration(.notification(.error)))),
            .init(text: "Notification Success", action: .didTap(.hapticVibration(.notification(.success)))),
            .init(text: "Notification Warning", action: .didTap(.hapticVibration(.notification(.warning)))),
            .init(text: "Selection", action: .didTap(.hapticVibration(.selection)))
        ]),
        .init(title: "IDFA", items: [
            .init(text: "Request IDFA", action: .didTap(.requestIDFA))
        ])
    ]

    struct Section: Equatable, Identifiable {
        let id: UUID = .init()
        let title: String
        let items: [Item]

        struct Item: Equatable, Identifiable {
            let id: UUID = .init()
            let text: String
            let action: MainAction
        }
    }
}

enum MainAction: BindableAction, Equatable {
    case binding(BindingAction<MainState>)
    case didTap(Button)
    case response(Response)

    enum Button: Equatable {
        case copyToClipboard

        case openUrlInApp
        case openUrlInSafari
        case rateUs

        case requestIDFA
        case shareActivity

        case systemVibration(UIClient.VibrationType.System)
        case hapticVibration(UIClient.VibrationType.Haptic)
    }

    enum Response: Equatable {
        case idfa(String?)
    }
}

struct MainEnvironment {
    var idfa: IDFA = .live
    var mainQueue: AnySchedulerOf<DispatchQueue> = .main
    var uiClient: UIClient = .live
}

let MainReducer = Reducer<MainState, MainAction, MainEnvironment>.combine(
    .init{ state, action, env in

        switch action {

        case .didTap(.copyToClipboard):
            return env.uiClient.copyToClipboard("Test string\(Int.random(in: 0...500))").fireAndForget()

        case .didTap(.openUrlInApp):
            return env.uiClient.openURL(state.testURL, .inApp)
                .fireAndForget()

        case .didTap(.openUrlInSafari):
            return env.uiClient.openURL(state.testURL, .safari)
                .fireAndForget()

        case .didTap(.rateUs):
            return env.uiClient.rateUs()
                .fireAndForget()

        case .didTap(.requestIDFA):
            return env.idfa.request()
                .map({ .response(.idfa($0)) })
                .receive(on: env.mainQueue)
                .eraseToEffect()

        case .didTap(.shareActivity):
            return env.uiClient.presentShareActivity(["http://apple.com/"]).fireAndForget()

        case let .didTap(.hapticVibration(value)):
            return env.uiClient.vibrate(.haptic(value)).fireAndForget()

        case let .didTap(.systemVibration(value)):
            return env.uiClient.vibrate(.system(value)).fireAndForget()

        case let .response(.idfa(value)):
            return env.uiClient.showToast(.init(value ?? "no idfa")).fireAndForget()

        default: break
        }
        
        return .none
    }.binding()
)

struct MainView: View {
    let store: Store<MainState, MainAction>

    struct Item: View {
        let text: String
        let viewStore: ViewStore<MainState, MainAction>
        let action: MainAction

        var body: some View {
            Button(action: {
                viewStore.send(action)
            }, label: {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 50)
            })
        }
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.items, id: \.id) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.items, id: \.id) { item in
                            Item(text: item.text,
                                 viewStore: viewStore,
                                 action: item.action)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
}

#if DEBUG
enum MockUp {}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: MockUp.make())
    }
}

extension MockUp {
    static func make() -> Store<MainState, MainAction> {
        .init(initialState: .init(), reducer: MainReducer, environment: make())
    }

    static func make() -> MainEnvironment {
        .init(uiClient: .live)
    }
}
#endif
