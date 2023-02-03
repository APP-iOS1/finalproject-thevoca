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
    // View
    func registerViews() {
        //CrewListView 종속성은 register 사용하여 등록
        container.register(PracticeVocaListView.self) { resolver in
            let viewModel = resolver.resolve(PracticeVocaListViewModel.self)
            return PracticeVocaListView(viewModel: viewModel!) }
    }
    
    // ViewModel
    func registerViewModels() {
        container.register(PracticeVocaListViewModel.self) { resolver in
            let service = resolver.resolve(VocabularyService.self)!
            return PracticeVocaListViewModel(service: service)
        }
    }
    
    // Model (Service)
    func registerServices() {
        container.register(VocabularyService.self) { resolver in
            let repository = resolver.resolve(CoreDataRepository.self)!
            return VocabularyServiceImpl(repo: repository)
        }
    }
    // Model (Repository)
    func registerRepositories() {
        container.register(CoreDataRepository.self) { _ in CoreDataRepositoryImpl(context: PersistenceController.shared.container.viewContext) }
    }
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }

}
