//
//  ImportCSVFileView.swift
//  GGomVoca
//
//  Created by Roen White on 2022/12/21.
//

import SwiftUI
import TabularData

struct ImportCSVFileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    var viewModel: ImportCSVFileViewModel = ImportCSVFileViewModel()
    var vocabulary: Vocabulary
    
    /// - View Properties...
    @State private var openFile: Bool = false
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    /// - loadCSV method에 사용되는 states
    @State private var fileName: String = ""
    @State private var fileURL: URL? = nil
    
    /// - 불러온 csvData 저장
    @State private var csvData: DataFrame = [:]
    
    var body: some View {
        VStack {
            if !csvData.isEmpty {
                Text("파일 내용 확인하기")
            }
            
            VStack {
                if csvData.isEmpty {
                    Button {
                        openFile.toggle()
                    } label: {
                        VStack(spacing: 15) {
                            Image(systemName: "icloud.and.arrow.up")
                                .font(.largeTitle)
                            Text("csv 파일 업로드")
                                .font(.title3)
                        }
                        .foregroundColor(.gray)
                        .verticalAlignSetting(.center)
                        .horizontalAlignSetting(.center)
                    }
                } else {
                    ScrollView {
                        ForEach(Array(csvData.rows), id: \.self) { row in
                            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                                Group {
                                    Text(row[0] as? String ?? "")
                                    Text(row[1] as? String ?? "")
                                    Text(row[2] as? String ?? "")
                                }
                                .eachDeviceFontSize()
                                .multilineTextAlignment(.center)
                            }
                            Divider()
                        }
                        .padding()
                    }
                }
            }
            .padding(20)
            .frame(minHeight: 400)
            .background(Color("offwhite"))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray, style: StrokeStyle(lineCap: .round, lineJoin: .miter, dash: [5, 10], dashPhase: 0))
                    .padding()
            )
            
            if !csvData.isEmpty {
                Button {
                    if !csvData.isEmpty {
                        for line in csvData.rows {
                            let word = line[0] as? String ?? ""
                            let option = line[1] as? String ?? ""
                            let meaning = line[2] as? String ?? ""
                            var meaningArray: [String] = []
                            // MARK: 복수 개의 뜻을 가지고 있을 경우, 배열로 생성
                            if meaning.contains(",") {
                                // MARK: comma를 기준으로 배열로 변환
                                meaningArray = meaning.components(separatedBy: ",")
                                
                                // MARK: 각 단어가 좌우 공백이 포함되어 있을 경우, 공백 제거
                                for index in meaningArray.indices {
                                    meaningArray[index] = meaningArray[index].trimmingCharacters(in: .whitespaces)
                                }
                                
                            } else {
                                meaningArray.append(meaning)
                            }
                            
                            viewModel.addNewWord(vocabulary: vocabulary, word: word, meaning: meaningArray, option: option)
                            
                            dismiss()
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "tray.and.arrow.down")
                        Text("가져온 단어 추가하기")
                    }
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("단어 가져오기")
        // MARK: file을 가져오는 메서드, 파일 경로와 파일 이름 가져옴
        .fileImporter(isPresented: $openFile, allowedContentTypes: [.commaSeparatedText]) { result in
            do {
                fileURL = try result.get()
                //that's used to request access to a security-scoped resource.
                if fileURL!.startAccessingSecurityScopedResource() {
                    guard String(data: try Data(contentsOf: fileURL!), encoding: .utf8) != nil else { return }
                    
                    fileName = fileURL?.lastPathComponent ?? ""
                    if let fileURL {
                        csvData = DataFrame.loadCSV(fileURL: fileURL)
                    }
                    do { fileURL!.stopAccessingSecurityScopedResource() }
                    
                } else {
                    // Handle denied access
                    print("denied access")
                }
                
            } catch {
                print("error reading docs", error.localizedDescription)
            }
        }
    }
}

//struct ImportCSVFileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            ImportCSVFileView(isShowingImportWordView: .constant(true))
//        }
//    }
//}
