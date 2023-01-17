//
//  DataFrame+.swift
//  GGomVoca
//
//  Created by Roen White on 2023/01/17.
//

import Foundation
import TabularData

extension DataFrame {
    // MARK: CSV 파일 내용 불러오기
    static func loadCSV(fileURL: URL) -> DataFrame {
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

}
