//
//  AppCoordinator.swift
//  GBFrameworks
//
//  Created by Сергей Черных on 23.06.2022.
//

import Foundation

final class AppCoordinator: BaseCoordinator {
    override func start() {
        UserDefaults.isLogin ? toMap() : toAuth()
    }

    private func toMap() {
        let coordinator = MapCoordinator()

        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }

        addDependency(coordinator)
        coordinator.start()
    }

    private func toAuth() {
        let coordinator = AuthCoordinator()

        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
