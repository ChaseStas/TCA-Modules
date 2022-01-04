import ComposableArchitecture

public struct UIClient {

    public enum VibrationType: Equatable {

        // Haptic uses UI___Generator classes
        case haptic(Haptic)

        // System uses AudioServicesPlaySystemSound
        case system(System)

        public enum Haptic: Equatable {
            case impact
            case impactIntensifity(Double)
            case notification(FeedbackType)
            case selection

            public enum FeedbackType: Equatable {
                case error
                case success
                case warning
            }
        }

        public enum System: Equatable {
            case strong
            case strongBoom
            case weak
            case weakBoom
        }
    }

    public enum URLOpenType: Hashable {
        case inApp
        case safari
    }

    // Copy string to clipboard
    public var copyToClipboard: (String) -> Effect<Never, Never>

    // Dismiss keyboard if opened
    public var dismissKeyboard: () -> Effect<Never, Never>

    // Open url in app or in safari app
    public var openURL: (String, URLOpenType) -> Effect<Never, Never>

    // Open app store app with review view
    public var openReviewInAppStore: (_ appId: String) -> Effect<Never, Never>

    // Present system rate us view
    public var rateUs: () -> Effect<Never, Never>

    // Play vibration with selected type
    public var vibrate: (VibrationType) -> Effect<Never, Never>
}

