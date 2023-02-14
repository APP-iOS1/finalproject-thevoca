//
//  DependencyManager.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/02.
//

import Foundation

import Swinject
//애플리케이션의 모든 종속성에 대한 중앙 레지스트리 역할을 하는 싱글톤 객체
class DependencyManager {
    static let shared = DependencyManager()
    
    private let container = Container()
    

    func register(){
        registerViews()
        registerViewModels()
        registerServices()
        registerRepositories()
    }
    //MARK: View
    func registerViews() {
        // 종속성은 register 사용하여 등록
        
        //단어장 리스트 뷰
        container.register(DisplaySplitView.self) { resolver in
            let viewModel = resolver.resolve(DisplaySplitViewModel.self)
            return DisplaySplitView(viewModel: viewModel!) }
        
        
        
    }
    
    //MARK: ViewModel
    func registerViewModels() {
        
        container.register(DisplaySplitViewModel.self) { resolver in
            let service = resolver.resolve(VocabularyService.self)!
            return DisplaySplitViewModel(vocabularyList: [], service: service)
        }
        
        //wordListViewModel
        container.register(ENENWordListViewModel.self) { resolver in
            let service = resolver.resolve(WordListService.self)!
            return ENENWordListViewModel( service: service)
        }
        
        //MARK: wordListViewModel
        container.register(KOWordListViewModel.self) { resolver in
            let service = resolver.resolve(WordListService.self)!
            return KOWordListViewModel( service: service)
        }
        
        container.register(ENENWordListViewModel.self) { resolver in
            let service = resolver.resolve(WordListService.self)!
            return ENENWordListViewModel( service: service)
        }
        
        container.register(JPWordListViewModel.self) { resolver in
            let service = resolver.resolve(WordListService.self)!
            return JPWordListViewModel( service: service)
        }
        
        container.register(FRFRWordListViewModel.self) { resolver in
            let service = resolver.resolve(WordListService.self)!
            return FRFRWordListViewModel( service: service)
        }
    }
    
    //MARK: Model (Service)
    func registerServices() {
        container.register(VocabularyService.self) { resolver in
            let coreDataRepository = resolver.resolve(CoreDataRepository.self)!
            let cloudDataRepository = resolver.resolve(CloudKitRepository.self)!
            return VocabularyServiceImpl(coreDataRepo: coreDataRepository,
                                         cloudDataRepo: cloudDataRepository)
        }
        
        container.register(WordListService.self) { resolver in
            let coreDataRepository = resolver.resolve(CoreDataRepository.self)!
            let cloudDataRepository = resolver.resolve(CloudKitRepository.self)!
            return WordListServiceImpl(coreDataRepo: coreDataRepository,
                                         cloudDataRepo: cloudDataRepository)
        }
        
//        container.register(WordTestService.self){ resolver in
//            let coreDataRepository = resolver.resolve(CoreDataRepository.self)!
//            let cloudDataRepository = resolver.resolve(CloudKitRepository.self)!
//            return WordTestServiceImpl(
//            
//        }
        
    }
    //MARK: Model (Repository)
    func registerRepositories() {
        container.register(CoreDataRepository.self) { _ in CoreDataRepositoryImpl(context: PersistenceController.shared.container.viewContext) }
        container.register(CloudKitRepository.self) { _ in CloudKitRepositoryImpl() }
    }
    
    
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }

}
