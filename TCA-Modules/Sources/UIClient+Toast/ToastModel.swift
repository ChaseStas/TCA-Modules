import Foundation
import Toast

public struct ToastModel {
    var duration: TimeInterval = ToastManager.shared.duration
    var message: String?
    var title: String?
    var position: ToastPosition = .top

    public init(
        duration: TimeInterval = ToastManager.shared.duration,
        message: String? = nil,
        title: String? = nil,
        position: ToastPosition = .top) {
        self.duration = duration
        self.message = message
        self.title = title
        self.position = position
    }

    public init(_ error: Error) {
        self.message = error.localizedDescription
    }

    public init(_ message: String) {
        self.message = message
    }
}

extension ToastModel: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self.init(message: value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(message: value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(message: value)
    }
}
