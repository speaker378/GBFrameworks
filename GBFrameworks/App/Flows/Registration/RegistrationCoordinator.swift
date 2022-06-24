//
//  RegistrationCoordinator.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 24.06.2022.
//

import UIKit

final class RegistrationCoordinator: BaseCoordinator {
    override var storyboard: UIStoryboard { UIStoryboard(name: "Registration", bundle: nil) }
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?

    override func start() {
        showRegistrationModule()
    }

    private func showRegistrationModule() {
        guard let controller = storyboard.instantiateViewController(withIdentifier: "Registration") as? RegistrationViewController
        else { return }

        controller.endOfRegistration = { [weak self, toLoginModule] in
            toLoginModule()
            self?.onFinishFlow?()
        }

        rootController?.pushViewController(controller, animated: true)
    }

    private func toLoginModule() {
        rootController?.popViewController(animated: true)
    }
}
