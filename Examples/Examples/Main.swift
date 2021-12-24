//
//  Main.swift
//  Examples
//
//  Created by Stanislau Parechyn on 24.12.2021.
//

import ComposableArchitecture
import SwiftUI

struct MainState: Equatable {
    fileprivate let testURL: String = "https://google.com"
//    @BindableState var route: Route?
//    enum Route: Equatable {
//
//    }
}

enum MainAction: BindableAction, Equatable {
    case binding(BindingAction<MainState>)
    case didTap(Button)

    enum Button: Equatable {
        case copyToClipboard

        case openUrlInApp
        case openUrlInSafari

        case rateUs

        case systemVibration(UIClient.VibrationType.System)
        case hapticVibration(UIClient.VibrationType.Haptic)
    }
}

struct MainEnvironment {
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

        case let .didTap(.hapticVibration(value)):
            return env.uiClient.vibrate(.haptic(value)).fireAndForget()

        case let .didTap(.systemVibration(value)):
            return env.uiClient.vibrate(.system(value)).fireAndForget()

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
                Section(header: Text("UIClient")) {

                    Item(text: "Copy random text",
                         viewStore: viewStore,
                         action: .didTap(.copyToClipboard))

                    Item(text: "Rate us",
                         viewStore: viewStore,
                         action: .didTap(.rateUs))
                }

                Section(header: Text("URLs")) {

                    Item(text: "Open URL in app",
                         viewStore: viewStore,
                         action: .didTap(.openUrlInApp))

                    Item(text: "Open URL in safari",
                         viewStore: viewStore,
                         action: .didTap(.openUrlInSafari))
                }

                Section(header: Text("System Vibration")) {

                    Item(text: "Strong",
                         viewStore: viewStore,
                         action: .didTap(.systemVibration(.strong)))

                    Item(text: "Strong Boom",
                         viewStore: viewStore,
                         action: .didTap(.systemVibration(.strongBoom)))

                    Item(text: "Weak",
                         viewStore: viewStore,
                         action: .didTap(.systemVibration(.weak)))

                    Item(text: "Weak boom",
                         viewStore: viewStore,
                         action: .didTap(.systemVibration(.weakBoom)))
                }

                Section(header: Text("Haptic Vibration")) {

                    Item(text: "Impact 1.0",
                         viewStore: viewStore,
                         action: .didTap(.hapticVibration(.impact)))


                    Item(text: "Impact 0.7",
                         viewStore: viewStore,
                         action: .didTap(.hapticVibration(.impactIntensifity(0.7))))


                    Item(text: "Impact 0.5",
                         viewStore: viewStore,
                         action: .didTap(.hapticVibration(.impactIntensifity(0.5))))

                    Item(text: "Impact 0.3",
                         viewStore: viewStore,
                         action: .didTap(.hapticVibration(.impactIntensifity(0.3))))

                    Item(text: "Notification Error",
                         viewStore: viewStore,
                         action: .didTap(.hapticVibration(.notification(.error))))
                    Item(text: "Notification Success",
                         viewStore: viewStore,
                         action: .didTap(.hapticVibration(.notification(.success))))

                    Item(text: "Notification Warning",
                         viewStore: viewStore,
                         action: .didTap(.hapticVibration(.notification(.warning))))

                    Item(text: "Selection",
                         viewStore: viewStore,
                         action: .didTap(.hapticVibration(.selection)))
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
