import AdSupport
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif

import ComposableArchitecture
import UIKit

private var tries: Int = 5

extension IDFA {
    public static let live: Self = {
        .init(request: {
            .future { response in
                dispatchPrecondition(condition: .onQueue(.main))

                if #available(iOS 14.5, *) {
                    let status = ATTrackingManager.trackingAuthorizationStatus
                    guard status == .notDetermined else {
                        if status == .denied {
                            response(.success(nil))
                        } else {
                            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                            response(.success(idfa))
                        }
                        return
                    }

                    ATTrackingManager.requestTrackingAuthorization { (status) in
                        switch status {

                        case .authorized:
                            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                            response(.success(idfa))

                        case .denied:
                            response(.success(nil))

                        default:
                            response(.success(nil))
                        }
                    }
                }
            }
        }, status: {
            if #available(iOS 14, *) {
                return ATTrackingManager.trackingAuthorizationStatus.convertToLocalIDFA()
            }
            return .authorized
        })
    }()
}
