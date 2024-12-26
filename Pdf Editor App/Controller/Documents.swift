//
//  Documents.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI

class Documents: ObservableObject {
    static let shared = Documents()
    @Published var savedDocuments: [PDFDocumentModel] = []
}
