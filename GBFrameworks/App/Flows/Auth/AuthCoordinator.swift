//
//  AuthCoordinator.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 23.06.2022.
//

import UIKit

final class AuthCoordinator: BaseCoordinator {
    override var storyboard: UIStoryboard { UIStoryboard(name: "Auth", bundle: nil) }
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?

    override func start() {
        showAuthModule()
    }

    private func showAuthModule() {
        guard let controller = storyboard.instantiateViewController(withIdentifier: "Auth") as? AuthViewController
        else { return }

        controller.onRegistration = { [weak self] in
            let coordinator = RegistrationCoordinator()
            coordinator.rootController = self?.rootController
            coordinator.start()
        }

        controller.onLogin = { [weak self] in
            self?.onFinishFlow?()
        }

        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
}
