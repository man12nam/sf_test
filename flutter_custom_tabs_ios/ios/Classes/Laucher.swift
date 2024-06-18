import SafariServices
import UIKit

open class Launcher {
    var url : String?
    var window : UIWindow?
    
    open func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
        completionHandler completion: ((Bool) -> Void)? = nil
    ) {
        UIApplication.shared.open(url, options: options, completionHandler: completion)
    }

    open func present(_ viewControllerToPresent: UIViewController, completion: ((Bool) -> Void)? = nil) {
        if let topViewController = UIWindow.keyWindow?.topViewController() {
            topViewController.present(viewControllerToPresent, animated: true) {
                let frame = topViewController!.view.frame
                topViewController!.view.frame = frame
                self.btn = UIButton(frame: CGRect(x: 0, y: UIWindow.keyWindow?.safeAreaInsets.top ?? 0, width: frame.width, height: 40))
//                if osTheme == .dark {
                self.btn!.backgroundColor = .systemBackground
                UIApplication.shared.statusBarUIView?.backgroundColor = .systemBackground
//                }else {
//                    self.btn!.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
//                }
                topViewController!.view.addSubview(self.btn!)
                topViewController!.view.bringSubviewToFront(self.btn!)
                self.btn!.layer.zPosition = topViewController!.view.layer.zPosition + 1

                completion?(true)
            }
        } else {
            completion?(false)
        }
    }

    open func dismissAll(completion: (() -> Void)? = nil) {
        guard let rootViewController = UIWindow.keyWindow?.rootViewController else {
            completion?()
            return
        }

        var presentedViewController = rootViewController.presentedViewController
        var presentedViewControllers = [UIViewController]()
        while presentedViewController != nil {
            if presentedViewController is SFSafariViewController {
                presentedViewControllers.append(presentedViewController!)
            }
            presentedViewController = presentedViewController!.presentedViewController
        }
        recursivelyDismissViewControllers(
            presentedViewControllers,
            animated: true,
            completion: completion
        )
    }
}

private extension UIWindow {
    static var keyWindow: UIWindow? {
        guard let delegate = UIApplication.shared.delegate as? FlutterAppDelegate else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
        return delegate.window
    }

    func topViewController() -> UIViewController? {
        recursivelyFindTopViewController(from: rootViewController)
    }
}

private func recursivelyFindTopViewController(from viewController: UIViewController?) -> UIViewController? {
    if let navigationController = viewController as? UINavigationController {
        return recursivelyFindTopViewController(from: navigationController.visibleViewController)
    } else if let tabBarController = viewController as? UITabBarController,
              let selected = tabBarController.selectedViewController
    {
        return recursivelyFindTopViewController(from: selected)
    } else if let presentedViewController = viewController?.presentedViewController {
        return recursivelyFindTopViewController(from: presentedViewController)
    } else {
        return viewController
    }
}

private func recursivelyDismissViewControllers(
    _ viewControllers: [UIViewController],
    animated flag: Bool,
    completion: (() -> Void)? = nil
) {
    var viewControllers = viewControllers
    guard let vc = viewControllers.popLast() else {
        completion?()
        return
    }

    vc.dismiss(animated: flag) {
        if viewControllers.isEmpty {
            completion?()
        } else {
            recursivelyDismissViewControllers(viewControllers, animated: flag, completion: completion)
        }
    }
}

extension UIApplication {
    var statusBarUIView: UIView? {
        
        if #available(iOS 13.0, *) {
            let tag = 3848245
            
            let keyWindow = UIApplication.shared.connectedScenes
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999
                
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
            
        } else {
            
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}

