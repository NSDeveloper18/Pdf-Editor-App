//
//  Documents.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI
import CoreData
import PDFKit

class Documents: ObservableObject {
    static let shared = Documents()

    @Published var savedDocuments: [PDFDocumentModel] = []

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "PDFData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error.localizedDescription)")
            }
        }
        fetchSavedDocuments()
    }

    func fetchSavedDocuments() {
        let request: NSFetchRequest<PDFDocuments> = PDFDocuments.fetchRequest()
        do {
            let documents = try container.viewContext.fetch(request)
            savedDocuments = documents.map { PDFDocumentModel(from: $0) }
        } catch {
            print("Failed to fetch documents: \(error.localizedDescription)")
        }
    }
}
