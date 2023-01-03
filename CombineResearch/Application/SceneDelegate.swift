//
//  SceneDelegate.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let appDIContainer = AppDIContainer()
    private var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        self.appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController, appDIContainer: appDIContainer)
        
        self.appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    }

}

