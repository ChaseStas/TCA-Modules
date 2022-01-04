import AudioToolbox
import ComposableArchitecture
import SafariServices
import StoreKit
import UIKit

extension UIClient {
    public static let live: Self = {
        .init(copyToClipboard: { value in
            .fireAndForget {
                UIPasteboard.general.string = value
            }
        },
        dismissKeyboard: {
            .fireAndForget {
                UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map { $0 as? UIWindowScene }
                    .compactMap({ $0 })
                    .first?.windows
                    .filter { $0.isKeyWindow }
                    .first?.endEditing(true)
            }
        }, openURL: { stringUrl, type in
            .fireAndForget {
                guard let url = URL(string: stringUrl) else { return }

                switch type {
                case .inApp:
                    let vc = SFSafariViewController(url: url)
                    vc.modalPresentationStyle = .fullScreen
                    let topVC = UIApplication.topViewController()
                    topVC?.present(vc, animated: true, completion: nil)

                case .safari:
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }, openReviewInAppStore: { appId in
            .fireAndForget {
                guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)?action=write-review") else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }, presentShareActivity: { items in
            .fireAndForget {
                let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
        }, rateUs: {
            .fireAndForget {
                if #available(iOS 14.0, *) {
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                } else {
                    SKStoreReviewController.requestReview()
                }
            }
        }, vibrate: { type in 
            .fireAndForget {
                if case let .system(system) = type {

                    switch system {
                    case .strong:
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

                    case .strongBoom:
                        AudioServicesPlaySystemSound(1520)

                    case .weak:
                        AudioServicesPlaySystemSound(1521)

                    case .weakBoom:
                        AudioServicesPlaySystemSound(1519)

                    }

                } else if case let .haptic(haptic) = type {

                    switch haptic {
                    case .impact:
                        UIImpactFeedbackGenerator().impactOccurred()

                    case let .impactIntensifity(value):
                        UIImpactFeedbackGenerator().impactOccurred(intensity: CGFloat(value))

                    case .notification(.error):
                        UINotificationFeedbackGenerator().notificationOccurred(.error)

                    case .notification(.success):
                        UINotificationFeedbackGenerator().notificationOccurred(.success)

                    case .notification(.warning):
                        UINotificationFeedbackGenerator().notificationOccurred(.warning)

                    case .selection:
                        UISelectionFeedbackGenerator().selectionChanged()
                    }

                }
            }
        })
    }()
}
