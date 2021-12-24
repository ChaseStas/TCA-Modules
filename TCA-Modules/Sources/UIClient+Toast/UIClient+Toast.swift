import ComposableArchitecture
import UIKit

#if canImport(UIClient)
import UIClient
#endif

public extension UIClient {
    func showAlert(_ model: ToastModel) -> Effect<Never, Never> {
        .fireAndForget {
            #if RELEASE
            #else
            guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow) else { return }
            window.rootViewController?.view
                .makeToast(model.message,
                           duration: model.duration,
                           position: model.position,
                           title: model.title)
            #endif
        }
    }
}