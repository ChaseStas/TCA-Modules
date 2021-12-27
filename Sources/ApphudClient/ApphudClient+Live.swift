import ApphudSDK
import ComposableArchitecture
import Combine
import Foundation

private struct Dependencies {
    let subscriber: Effect<ApphudDelegateAction, Never>.Subscriber
    let delegate: ApphudDelegate
}

private var dependency: Dependencies?

extension ApphudClient {
    static let live: Self = {
        .init(
            delegate: { id in
                .run { subscriber in
                    let delegate = ApphudDelegateClass(subscriber: subscriber)
                    Apphud.setDelegate(delegate)
                    let dep = Dependencies(subscriber: subscriber,
                                           delegate: delegate)
                    dependency = dep

                    return AnyCancellable {
                        dependency = nil
                    }
                }
            },
            hasActiveSubscription: {
                Apphud.hasActiveSubscription()
            },
            isNonRenewingPurchaseActive: { id in
                Apphud.isNonRenewingPurchaseActive(productIdentifier: id)
            },
            paywalls: {
                Apphud.paywalls
            },
            purchase: { product in
                .future { response in
                    Apphud.purchase(product, callback: {
                        response(.success($0))
                    })
                }
            },
            restore: {
                .future { response in
                    Apphud.restorePurchases { subs, nonRew, error in
                        if let error = error {
                            response(.failure(error))
                        } else {
                            response(.success((subs ?? [], nonRew ?? [])))
                        }
                    }
                }
            },
            setIDFA: { idfa in
                .fireAndForget {
                    Apphud.setAdvertisingIdentifier(idfa)
                }
            },
            start: { apiKey in
                .fireAndForget {
                    Apphud.start(apiKey: apiKey)
                }
            },
            submitPushNotificationsToken: { data in
                .future { response in
                    Apphud.submitPushNotificationsToken(token: data) { value in
                        response(.success(value))
                    }
                }
            },
            subscribeToReceivePaywalls: {
                NotificationCenter.default.publisher(for: Apphud.didFetchProductsNotification())
                    .delay(for: 0.5, scheduler: DispatchQueue.main.eraseToAnyScheduler())
                    .map({ _ in
                        Apphud.paywalls ?? []
                    })
                    .eraseToEffect()
            })
    }()
}

fileprivate class ApphudDelegateClass: ApphudDelegate {
    private let subscriber: Effect<ApphudDelegateAction, Never>.Subscriber

    init(subscriber: Effect<ApphudDelegateAction, Never>.Subscriber) {
        self.subscriber = subscriber
    }

    func apphudDidChangeUserID(_ userID: String) {
        subscriber.send(.didChangeUserID(userID))
    }

    func apphudNonRenewingPurchasesUpdated(_ purchases: [ApphudNonRenewingPurchase]) {
        subscriber.send(.nonRenewingPurchasesUpdated(purchases))
    }

    func apphudSubscriptionsUpdated(_ subscriptions: [ApphudSubscription]) {
        subscriber.send(.subscriptionsUpdates(subscriptions))
    }
}
