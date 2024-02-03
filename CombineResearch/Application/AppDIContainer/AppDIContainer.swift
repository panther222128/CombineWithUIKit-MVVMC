//
//  AppDIContainer.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation

final class AppDIContainer {

    lazy var appConfiguration = AppConfiguration()
    
    lazy var apiDataTransferService: DataTransferService = {
        let configuration = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
        let apiDataNetwork = DefaultNetworkService(configuration: configuration)
        return DefaultDataTransferService(networkService: apiDataNetwork)
    }()
    
    lazy var imageDataTransferService: DataTransferService = {
        let configuration = ApiDataNetworkConfig(baseURL: URL(string: " ")!)
        let imageDataNetwork = DefaultNetworkService(configuration: configuration)
        return DefaultDataTransferService(networkService: imageDataNetwork)
    }()
    
    func makeSceneDIContainer() -> SceneDIContainer {
        let dependencies = SceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService, imageDataTransferService: imageDataTransferService)
        return SceneDIContainer(dependencies: dependencies)
    }
    
}
