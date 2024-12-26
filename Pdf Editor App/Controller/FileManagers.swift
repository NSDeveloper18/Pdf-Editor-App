//
//  FileManagers.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI
import PDFKit

func mergePDFs(documents: [PDFDocumentModel], outputFileName: String) -> URL? {
    let mergedPDF = PDFDocument()
    
    for document in documents {
        if let pdfDocument = PDFDocument(url: URL(string: document.filePath)!) {
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
    let fileManager = FileManager.default
    guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    let pdfPath = documentsPath.appendingPathComponent(fileName)

    if document.write(to: pdfPath) {
        print("PDF saved to \(pdfPath)")
        let newDocument = PDFDocumentModel(
            name: fileName,
            creationDate: Date(),
            filePath: pdfPath.absoluteString,
            thumbnail: generateThumbnail(for: document)
        )
        Documents.shared.savedDocuments.append(newDocument)
        return pdfPath
    } else {
        print("Failed to save PDF")
        return nil
    }
}

func deleteFile(at filePath: String) {
    guard let fileURL = URL(string: filePath) else {
        print("Invalid file path: \(filePath)")
        return
    }

    if FileManager.default.fileExists(atPath: fileURL.path) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Successfully deleted file at \(fileURL.path)")
        } catch {
            print("Failed to delete file: \(error.localizedDescription)")
        }
    } else {
        print("File not found, updating references.")
        // Update your savedDocuments or app state to reflect this.
    }
}
