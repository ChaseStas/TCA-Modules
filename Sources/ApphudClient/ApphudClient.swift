import ApphudSDK
import ComposableArchitecture
import Combine
import Foundation

enum ApphudDelegateAction: Equatable {
    case didChangeUserID(_ userID: String)
    case nonRenewingPurchasesUpdated(_ purchases: [ApphudNonRenewingPurchase])
    case subscriptionsUpdates(_ subscriptions: [ApphudSubscription])
}

struct ApphudClient {
    var delegate: (AnyHashable) -> Effect<ApphudDelegateAction, Never>
    var hasActiveSubscription: () -> Bool
    var isNonRenewingPurchaseActive: (String) -> Bool
    var paywalls: () -> [ApphudPaywall]?
    var purchase: (ApphudProduct) -> Effect<ApphudPurchaseResult, Never>
    var restore: () -> Effect<([ApphudSubscription],[ApphudNonRenewingPurchase]), Error>
    var setIDFA: (String) -> Effect<Never, Never>
    var start: (_ key: String) -> Effect<Never, Never>
    var submitPushNotificationsToken: (Data) -> Effect<Bool, Never>
    var subscribeToReceivePaywalls: () -> Effect<[ApphudPaywall], Never>
}

