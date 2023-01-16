//
//  VocabularyCell.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI

struct VocabularyCell: View {
   // @EnvironmentObject var vocabularyStore: VocabularyStore
    @Environment(\.managedObjectContext) private var viewContext
    // 과정의 타입 (함수)
    // 과일 -> 주스 (믹서기 과정이 클로져)
    var cellClosure: () -> ()
    var deleteCompletion : () -> ()
    var vocabulary: Vocabulary
    @State var isShowingDeleteAlert: Bool = false
    
    var body: some View {
        HStack {
            NavigationLink(destination: {
                if vocabulary.nationality! == "JA" {
                    JPWordListView(vocabulary: vocabulary)
                        .onAppear(perform: {
                            manageVocabulary(voca: vocabulary)
                            print("gesture")})
                } else {
                    FRWordListView(vocabulary: vocabulary)
                        .onAppear(perform: {
                            manageVocabulary(voca: vocabulary)
                            print("gesture")})
                }
            }, label: { VStack { Text(vocabulary.name ?? "")}})

        }

        .swipeActions(edge: .leading) {
            Button {
                updateFavorite(id: vocabulary.id!)
                cellClosure()
                print("clickclick")
            } label: {
                Image(systemName: vocabulary.isFavorite ? "star.slash" : "star")
            }
            .tint(vocabulary.isFavorite ? .gray : .yellow)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                //updateData(id: vocabulary.id!)
                isShowingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            
            Alert(title: Text("단어장을 삭제하면, \n 포함된 단어도 모두 삭제됩니다.\n 단어장을 삭제 하시겠습니까?"), primaryButton: .destructive(Text("삭제"), action: {
                updateData(id: vocabulary.id!)
                //deleteRecentVocabulary(vocaId: vocabulary.id!)
                deleteCompletion() //삭제 후 업데이트
                
            }), secondaryButton: .cancel(Text("취소")))
        }
    }
    func updateFavorite(id: UUID) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = viewContext
        let vocabularyFetch = Vocabulary.fetchRequest()
        vocabularyFetch.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        //vocabularyFetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let results = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(forEntityName: "User")
//        fetchRequest.predicate = NSPredicate(format: "username = %@", "name1")
        
        do {
//            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = results[0] // as! NSManagedObject
            objectUpdate.setValue(!objectUpdate.isFavorite, forKey: "isFavorite")
            print(objectUpdate)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func updateData(id: UUID) {

        let managedContext = viewContext
        let vocabularyFetch = Vocabulary.fetchRequest()
        vocabularyFetch.predicate = NSPredicate(format: "id = %@", id as CVarArg)
    
        let results = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        
        do {
            let objectUpdate = results[0] // as! NSManagedObject
            objectUpdate.setValue("\(Date())", forKey: "deleatedAt")
            
//            objectUpdate.setValue("", forKey: "nationality")
            try self.viewContext.save()
            print("변경 결과 : \(objectUpdate.deleatedAt)" )
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    //최근 목록 초기화
    func initRecentVocabulary(){
        var results = getRecentVocabulary()
        if results.count == 0 {
            let recentVocabulary = RecentVocabulary(context: viewContext)
            recentVocabulary.vocabularies = []
        }
    }
    func addRecentVocabulary(voca: Vocabulary) { //name: String, nationality: String
//        withAnimation {
//            let recentVocabulary = RecentVocabulary(context: viewContext)
//            recentVocabulary.vocabularies = [voca]
//        }
        
        print("addRecentVocabulary")
        let managedContext = viewContext
        let vocabularyFetch = RecentVocabulary.fetchRequest()

        let results = (try? self.viewContext.fetch(vocabularyFetch) as [RecentVocabulary]) ?? []
        print("addRecentVocabulary results : \(results)")

        do {
//            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = results[0] // as! NSManagedObject
            var arr = objectUpdate.vocabularies
//            if objectUpdate.vocabularies?.count ?? 0 >= 3{
//                //drop
//                arr = NSSet(object: arr?.dropFirst(2))
//                //arr?.dropFirst(2)
//            }
            var aa = arr?.allObjects as [Vocabulary]
            aa.append(voca)
            var nsSet = NSSet(array: aa)
            print("addRecentVocabulary append : \(voca)")
            objectUpdate.setValue(nsSet, forKey: "vocabularies")

            print(objectUpdate)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        
    }
    // 3개의 단어장 불러오기
    func getRecentVocabulary() -> [Vocabulary] {
        let vocabularyFetch = RecentVocabulary.fetchRequest()
        var results = (try? self.viewContext.fetch(vocabularyFetch) as [RecentVocabulary])
        var arr = (results?.first?.vocabularies?.allObjects ?? []) as [Vocabulary]
        return arr
    }
    // 3개 이후 지우기
    func deleteVocabulary() {
        
        let managedContext = viewContext
        let vocabularyFetch = RecentVocabulary.fetchRequest()

        let results = (try? self.viewContext.fetch(vocabularyFetch) as [RecentVocabulary]) ?? []

        do {

            let objectUpdate = results[0] // as! NSManagedObject
            var arr = objectUpdate.vocabularies?.dropFirst(2)
            objectUpdate.setValue(arr, forKey: "vocabularies")

            print(objectUpdate)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        

    }
    // 3개 가져오고 지우기 (관리)
    func manageVocabulary(voca: Vocabulary) {
        
        initRecentVocabulary() //초기화
        
        var data = getRecentVocabulary()
//        if data.count >= 3{
//            deleteVocabulary()
//        }
        addRecentVocabulary(voca: voca)
        print("results")
    }
    
    // 특정최근 본 단어장 삭제
    func deleteRecentVocabulary(vocaId : UUID) {
        
        let managedContext = viewContext
        let vocabularyFetch = RecentVocabulary.fetchRequest()
       
        let results = try? (self.viewContext.fetch(vocabularyFetch) ?? []) as [RecentVocabulary]

        do {
//            let test = try managedContext.fetch(fetchRequest)
            if results?.count == 0 {
                return
            }
            let objectUpdate = results?[0] // as! NSManagedObject
            var arr = (objectUpdate?.vocabularies?.allObjects ?? []) as [Vocabulary]
            guard let removeIndex = arr.firstIndex(where: {$0.id == vocaId}) else { return }
            arr.remove(at: removeIndex)
            objectUpdate?.setValue( arr, forKey: "vocabularies")
//            objectUpdate.setValue("", forKey: "nationality")
            print(objectUpdate)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        
        withAnimation {
//            viewContext.delete(voca)
//            saveContext()
        }
    }
    
    func saveContext() {
        do {
            print("saveContext")
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}



//struct VocabularyCell_Previews: PreviewProvider {
//    static var previews: some View {
//        VocabularyCell(vocabulary: .constant(Vocabulary()))
//    }
//}
