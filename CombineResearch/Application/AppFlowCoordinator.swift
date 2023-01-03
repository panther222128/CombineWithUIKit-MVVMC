//
//  AppFlowCoordinator.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let sceneDIContainer = appDIContainer.makeSceneDIContainer()
        let flow = sceneDIContainer.makeViewFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
}
