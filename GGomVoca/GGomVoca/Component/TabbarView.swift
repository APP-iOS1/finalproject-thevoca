//
//  TabbarView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI

struct TabbarView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Vocabulary.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Vocabulary.createdAt, ascending: true)],
        animation: .default)
    private var vocabularies: FetchedResults<Vocabulary>
    
    var body: some View {
        TabView {
            DependencyManager.shared.resolve(DisplaySplitView.self)
                .tabItem {
                    Image(systemName: "list.star")
                    Text("단어장")
                }
            
//            MyNoteView()
//                .tabItem {
//                    Image(systemName: "note.text")
//                    Text("마이노트")
//                }
            
            WordSearchingView()
                .tabItem {
                    Image(systemName: "rectangle.and.text.magnifyingglass")
                    Text("내단어찾기")
                }
            
//            SettingsView()
//                .tabItem {
//                    Image(systemName: "gearshape")
//                    Text("설정")
//                }
            //DependencyManager.shared.resolve(PracticeVocaListView.self)
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
