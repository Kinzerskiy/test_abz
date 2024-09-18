//
//  SceneDelegate.swift
//  test_abz
//
//  Created by Anton on 17.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private var applicationAssembly: ApplicationAssemblyProtocol?
    private var applicationRouter: ApplicationRouting?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        UIWindow.appearance().overrideUserInterfaceStyle = .light
        
        
        setupRouting()
        setupWindow()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        ViewModel.shared.reset()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        ViewModel.shared.reset()
    }
    
    // MARK: - private
    
    private func setupRouting() {
        let assembly: ApplicationAssembly = ApplicationAssembly.defaultAssembly()
        applicationAssembly = assembly
        let router: ApplicationRouting = assembly.assemblyApplicationRouter()
        applicationRouter = router
    }
    
    private func setupWindow() {
        window?.rootViewController = applicationRouter?.initialViewController()
        window?.makeKeyAndVisible()
        
        if Defaults.firstInitialization {
            applicationRouter?.showIntroForm(from: window?.rootViewController, animated: false, completion: nil)
        }
    }
    
    
}
