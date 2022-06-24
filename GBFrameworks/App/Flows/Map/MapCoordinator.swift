//
//  MainCoordinator.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 23.06.2022.
//

import UIKit

final class MapCoordinator: BaseCoordinator {
    override var storyboard: UIStoryboard { UIStoryboard(name: "Map", bundle: nil) }
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?

    override func start() {
        showMapModule()
    }

    private func showMapModule() {
        guard let controller = storyboard.instantiateViewController(withIdentifier: "Map") as? MapViewController
        else { return }

        controller.getOut = { [weak self] in
            self?.logout()
            self?.onFinishFlow?()
        }

        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }

    private func logout() {
        let coordinator = AuthCoordinator()
        coordinator.start()
        UserDefaults.isLogin = false
    }
}
