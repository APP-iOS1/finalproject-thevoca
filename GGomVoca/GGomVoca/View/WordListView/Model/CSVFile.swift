//
//  CSVFile.swift
//  GGomVoca
//
//  Created by tae on 2023/01/20.
//
import SwiftUI
import UniformTypeIdentifiers

struct CSVFile: FileDocument {
    
    static var readableContentTypes = [UTType.commaSeparatedText]
    static var writableContentTypes = [UTType.commaSeparatedText]
    
    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
