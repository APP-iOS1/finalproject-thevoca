////
////  ContentView.swift
////  GGomVoca
////
////  Created by Roen White on 2022/12/19.
////
//
//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        entity: Vocabulary.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Vocabulary.createdAt, ascending: true)],
//        animation: .default)
//    private var vocabularies: FetchedResults<Vocabulary>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(vocabularies) { vocabulary in
//                    NavigationLink {
//                        if vocabulary.nationality == "FR" {
//                            FRWordListView(vocabularyID: vocabulary.id ?? UUID())
//                        } else {
//                            WordListView(vocabularyID: vocabulary.id ?? UUID())
//                        }
//                    } label: {
//                        Text(vocabulary.name ?? "")
//                    }
//                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                        Button(role: .destructive) {
//                            deleteVocabulary(vocabulary: vocabulary)
//                        } label: {
//                            Label("Delete", systemImage: "trash.fill")
//                        }
//                    }
//                }
//            }
//            .toolbar {
//#if os(iOS)
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: addVocabularyFR) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//                ToolbarItem {
//                    Button(action: addVocabularyJP) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addVocabularyFR() { //name: String, nationality: String
//        withAnimation {
//            let newVocabulary = Vocabulary(context: viewContext)
//            newVocabulary.id = UUID()
//            newVocabulary.name = "test" // name
//            newVocabulary.nationality = "FR" // nationality
//            newVocabulary.createdAt = "\(Date())"
//            newVocabulary.words = NSSet(array: [])
//            
//            saveContext()
//        }
//    }
//    private func addVocabularyJP() { //name: String, nationality: String
//        withAnimation {
//            let newVocabulary = Vocabulary(context: viewContext)
//            newVocabulary.id = UUID()
//            newVocabulary.name = "test" // name
//            newVocabulary.nationality = "JP" // nationality
//            newVocabulary.createdAt = "\(Date())"
//            newVocabulary.words = NSSet(array: [])
//            
//            saveContext()
//        }
//    }
//
//    private func deleteVocabulary(vocabulary: Vocabulary) {
//        withAnimation {
//            viewContext.delete(vocabulary)
//
//            saveContext()
//        }
//    }
//    
//    // MARK: saveContext
//    func saveContext() {
//        do {
//            try viewContext.save()
//        } catch {
//            print("Error saving managed object context: \(error)")
//        }
//    }
//    
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
