import ApphudSDK
import ComposableArchitecture
import Combine
import Foundation
import StoreKit

public enum ApphudDelegateAction: Equatable {
    case didChangeUserID(_ userID: String)
    case didFetchStoreKitProducts(_ identifiers: [SKProduct])
    case nonRenewingPurchasesUpdated(_ purchases: [ApphudNonRenewingPurchase])
    case subscriptionsUpdates(_ subscriptions: [ApphudSubscription])
}

public struct ApphudClient {
    public var delegate: () -> Effect<ApphudDelegateAction, Never>
    public var hasActiveSubscription: () -> Bool
    public var isNonRenewingPurchaseActive: (String) -> Bool
    public var  paywalls: () -> [ApphudPaywall]?
    public var  purchase: (ApphudProduct) -> Effect<ApphudPurchaseResult, Never>
    public var  restore: () -> Effect<([ApphudSubscription],[ApphudNonRenewingPurchase]), Error>
    public var  setIDFA: (String) -> Effect<Never, Never>
    public var  start: (_ key: String) -> Effect<Never, Never>
    public var  submitPushNotificationsToken: (Data) -> Effect<Bool, Never>
    public var  subscribeToReceivePaywalls: () -> Effect<[ApphudPaywall], Never>
}

