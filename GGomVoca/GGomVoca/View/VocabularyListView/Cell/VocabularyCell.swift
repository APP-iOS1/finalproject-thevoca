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
                            manageRecentVocabulary(voca: vocabulary)
                            print("gesture")})
                } else {
                    FRWordListView(vocabulary: vocabulary)
                        .onAppear(perform: {
                            manageRecentVocabulary(voca: vocabulary)
                            print("gesture")})
                }
            }, label: { VStack { Text(vocabulary.name ?? "")}})

        }
        //단어장 즐겨찾기 추가 스와이프
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
        //단어장 삭제 스와이프
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
                updateDeletedData(id: vocabulary.id!)
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
    
    /*
     단어장 삭제 후 반영 함수
     */
    func updateDeletedData(id: UUID) {

        let managedContext = viewContext
        let vocabularyFetch = Vocabulary.fetchRequest()
        vocabularyFetch.predicate = NSPredicate(format: "id = %@", id as CVarArg)
    
        let results = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        
        do {
            let objectUpdate = results[0] // as! NSManagedObject
            objectUpdate.setValue("\(Date())", forKey: "deleatedAt")
            
            //
            deleteRecentVoca(id: "\(id)")
            
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
    /*
      최근 본 단어장 (UserDefault) 삭제
     */
    func deleteRecentVoca(id : String){
        var before =  UserManager.shared.recentVocabulary // [voca1, voca2]
        if let idx = before.firstIndex(of: "\(id)"){
            before.remove(at: idx)
        }
        UserManager.shared.recentVocabulary = before
    }


    // 3개 가져오고 지우기 (관리)
    func manageRecentVocabulary(voca: Vocabulary) {
        
        //중복되는 최근 단어장 제거
        deleteRecentVoca(id: "\(voca.id!)")
        var before =  UserManager.shared.recentVocabulary // [voca1, voca2]
        
        before.insert("\(voca.id!)", at: 0)
        
        if before.count >= 4{
            before.removeLast()
        }

        UserManager.shared.recentVocabulary = before
        
        print( "manageRecentVocabulary() :\(UserManager.shared.recentVocabulary)")
        
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
