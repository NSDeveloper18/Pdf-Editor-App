//
//  FileManagers.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI
import PDFKit
import CoreData

class AppPathHelper {
    static func getBasePath() -> String {
        // Retrieve the application's base path
        let basePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // Extract the parent directory of the document directory
        let applicationBasePath = basePath
        return applicationBasePath.absoluteString
    }
}

func mergePDFs(documents: [PDFDocumentModel], outputFileName: String) -> URL? {
    let mergedPDF = PDFDocument()
    let basePath = AppPathHelper.getBasePath()
    for document in documents {
        if let pdfDocument = PDFDocument(url: URL(string: "\(basePath)PDFs/\(document.filePath)")!) {
            print("mergePDFs: \(basePath)PDFs/\(document.filePath)")
            for pageIndex in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: pageIndex) {
                    mergedPDF.insert(page, at: mergedPDF.pageCount)
                }
            }
        } else {
            print("Failed to load document: \(document.name)")
            return nil
        }
    }
    
    return saveMergedPDF(to: outputFileName, document: mergedPDF)
}

func saveMergedPDF(to fileName: String, document: PDFDocument) -> URL? {
//    let fileManager = FileManager.default
//    guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let basePath = AppPathHelper.getBasePath()
    let pdfPath = URL(string: "\(basePath)PDFs/\(fileName)")!

    if document.write(to: pdfPath) {
        print("PDF saved to \(pdfPath)")
        
        // Save to CoreData
        let newDocument = PDFDocuments(context: Documents.shared.container.viewContext)
        newDocument.name = fileName
        newDocument.creationDate = Date()
        newDocument.filePath = "\(fileName)"
        newDocument.thumbnail = generateThumbnail(for: document)
        
        do {
            try Documents.shared.container.viewContext.save()
            Documents.shared.fetchSavedDocuments()  // Refresh the savedDocuments list
            return pdfPath
        } catch {
            print("Failed to save document to CoreData: \(error.localizedDescription)")
            return nil
        }
    } else {
        print("Failed to save PDF")
        return nil
    }
}

func deleteFile(at filePath: String) {
    let basePath = AppPathHelper.getBasePath()
    let filePaths = "\(basePath)PDFs/\(filePath)"
    guard let fileURL = URL(string: filePaths) else {
        print("Invalid file path: \(filePaths)")
        return
    }

    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Successfully deleted file at \(fileURL.path)")
            
            // Remove from CoreData by filePath
            if let document = Documents.shared.savedDocuments.first(where: { $0.filePath == filePath }) {
                // Find the Core Data object based on filePath
                let fetchRequest: NSFetchRequest<PDFDocuments> = PDFDocuments.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "filePath == %@", filePath)
                
                let results = try Documents.shared.container.viewContext.fetch(fetchRequest)
                if let objectToDelete = results.first {
                    Documents.shared.container.viewContext.delete(objectToDelete)
                    try Documents.shared.container.viewContext.save()
                    Documents.shared.fetchSavedDocuments()  // Refresh the savedDocuments list
                }
            }
        } catch {
            print("Failed to delete file: \(error.localizedDescription)")
        }
    } else {
        print("File not found.")
    }
}


