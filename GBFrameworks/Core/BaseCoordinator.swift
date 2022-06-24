//
//  BaseCoordinator.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 23.06.2022.
//

import UIKit

class BaseCoordinator {
    var storyboard: UIStoryboard { UIStoryboard(name: "LaunchScreen", bundle: nil) }
    var childCoordinators: [BaseCoordinator] = []

    func start() {}

    func addDependency(_ coordinator: BaseCoordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }

        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: BaseCoordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator
        else { return }

        for (index, element) in childCoordinators.reversed().enumerated() where
        element === coordinator
        {
            childCoordinators.remove(at: index)
            break
        }
    }

    func setAsRoot(_ controller: UIViewController) {
        if #available(iOS 13, *) {
            let sceneDelegate =
            UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = controller
        } else {
            UIApplication.shared.keyWindow?.rootViewController = controller
        }
    }
}
