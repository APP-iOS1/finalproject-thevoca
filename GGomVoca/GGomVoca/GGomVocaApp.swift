//
//  GGomVocaApp.swift
//  GGomVoca
//
//  Created by Roen White on 2022/12/19.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct GGomVocaApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // environment -> view에 접근
            DependencyManager.shared.resolve(DisplaySplitView.self)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    // MARK: DI
    init(){
        DependencyManager.shared.register()
        UserManager.shared.sync() 
    }
}
