//
//  PDFDocumentModel.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI
import PDFKit

struct PDFDocumentModel: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String = ""
    var creationDate: Date = Date()
    var filePath: String = ""
    var thumbnail: Data? = nil
    
    init(from coreDataDocument: PDFDocuments) {
        self.id = coreDataDocument.id ?? UUID()
        self.name = coreDataDocument.name ?? ""
        self.creationDate = coreDataDocument.creationDate ?? Date()
        self.filePath = coreDataDocument.filePath ?? ""
        self.thumbnail = coreDataDocument.thumbnail
    }

    static func ==(lhs: PDFDocumentModel, rhs: PDFDocumentModel) -> Bool {
        return lhs.id == rhs.id
    }
}
