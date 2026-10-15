//
//  AppDelegate.swift
//  culturas_peruanas_UIKit
//
//  Created by Tecsup on 15/10/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Barra de navegación con fondo vino y textos en blanco en toda la app
        let apariencia = UINavigationBarAppearance()
        apariencia.configureWithOpaqueBackground()
        apariencia.backgroundColor = .vino
        apariencia.titleTextAttributes = [.foregroundColor: UIColor.white]
        apariencia.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        let barra = UINavigationBar.appearance()
        barra.standardAppearance = apariencia
        barra.scrollEdgeAppearance = apariencia
        barra.compactAppearance = apariencia
        barra.tintColor = .white
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

