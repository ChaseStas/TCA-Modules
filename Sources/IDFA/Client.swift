import AppTrackingTransparency
import ComposableArchitecture


@available(iOS 13, *)
public struct IDFA {
    // Call this request only on MAIN
    public var request: () -> Effect<String?, Never>
    public var status: () -> IDFA_AuthorizationStatus
}

public enum IDFA_AuthorizationStatus : UInt {
    case notDetermined = 0
    case restricted = 1
    case denied = 2
    case authorized = 3
}

@available(iOS 14, *)
extension ATTrackingManager.AuthorizationStatus {

    func convertToLocalIDFA() -> IDFA_AuthorizationStatus {
        switch self {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorized: return .authorized
        @unknown default: fatalError()
        }
    }
}
