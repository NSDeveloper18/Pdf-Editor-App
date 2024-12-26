//
//  PDFDocumentModel.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI

struct PDFDocumentModel: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String = ""
    var creationDate: Date = Date()
    var filePath: String = ""
    var thumbnail: Data? = nil
    
    static func ==(lhs: PDFDocumentModel, rhs: PDFDocumentModel) -> Bool {
        return lhs.id == rhs.id
    }
}
