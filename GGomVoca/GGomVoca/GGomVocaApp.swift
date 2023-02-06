//
//  GGomVocaApp.swift
//  GGomVoca
//
//  Created by Roen White on 2022/12/19.
//

import SwiftUI

@main
struct GGomVocaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
            // environment -> view에 접근
            DisplaySplitView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    /*
     DI 
     */
    init(){
        DependencyManager.shared.register()
    }
}
