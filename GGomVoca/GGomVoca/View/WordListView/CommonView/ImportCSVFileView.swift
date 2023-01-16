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
    
    var vocabulary: Vocabulary
    
    @State private var openFile: Bool = false
    // loadCSV method에 사용되는 states
    @State private var fileName: String = ""
    @State private var fileURL: URL? = nil
    
    // 불러온 csvData 저장
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
                        HStack {
                            Spacer()
                            VStack(spacing: 15) {
                                Image(systemName: "icloud.and.arrow.up")
                                    .font(.largeTitle)
                                Text("csv 파일 업로드")
                                    .font(.title3)
                            }
                            .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                } else {
                    ScrollView {
                        Grid {
                            ForEach(Array(csvData.rows), id: \.self) { row in
                                GridRow(alignment: .center) {
                                    Text(row[0] as? String ?? "")
                                    Text(row[1] as? String ?? "")
                                    Text(row[2] as? String ?? "")
                                }
                                .multilineTextAlignment(.center)
                                Divider()
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding(20)
            .frame(minHeight: 400)
            .background(Color(red: 246 / 255, green: 246 / 255, blue: 246 / 255))
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
                            
                            addNewWord(vocabulary: vocabulary, word: word, meaning: meaning, option: option)
                            
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
                fileName = fileURL?.lastPathComponent ?? ""
                
                if let fileURL {
                    csvData = loadCSV(fileURL: fileURL)
                }
                
            } catch {
                print("error reading docs", error.localizedDescription)
            }
        }
    }
    // MARK: CSV 파일 내용 불러오기
    func loadCSV(fileURL: URL) -> DataFrame {
        var wordDF: DataFrame = [:]
        do {
            let columnNames = ["word", "option", "meaning"]
            let columnTypes: [String : CSVType] = ["word": .string, "option": .string, "meaning": .string]
            let readingOption = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")

            wordDF = try DataFrame(contentsOfCSVFile: fileURL, columns: columnNames, types: columnTypes, options: readingOption)
            
        } catch {
            print(error.localizedDescription)
        }
        
        return wordDF
    }
    
    // MARK: 단어 하나씩 추가 하는 메서드
    func addNewWord(vocabulary:Vocabulary, word: String, meaning: String, option: String = "") {
        let newWord = Word(context: viewContext)
        newWord.id = UUID()
        newWord.word = word
        newWord.meaning = meaning
        newWord.option = option
        newWord.vocabulary = vocabulary
        newWord.vocabularyID = vocabulary.id
        
        saveContext()
    }
    // MARK: saveContext
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
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
