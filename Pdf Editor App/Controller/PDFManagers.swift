//
//  PDFManagers.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import PDFKit
import SwiftUI

func generatePDF(from images: [UIImage], name: String) -> Bool {
    let pdfDocument = PDFDocument()
    @ObservedObject var fileManagerClass: Documents = .shared
    
    let a4PageWidth: CGFloat = 612
    let a4PageHeight: CGFloat = 792
    let a4PageSize = CGSize(width: a4PageWidth, height: a4PageHeight)
    
    for (index, image) in images.enumerated() {
        // Scale the image to fit A4 dimensions
        let scaledImage = scaleImageToFitA4(image: image, pageSize: a4PageSize)
        
        // If the image is taller than one page, split it into multiple pages
        let pages = splitImageIntoPages(image: scaledImage, pageSize: a4PageSize)
        
        // Add each page to the PDF
        for pageImage in pages {
            if let pdfPage = PDFPage(image: pageImage) {
                pdfDocument.insert(pdfPage, at: pdfDocument.pageCount)
            }
        }
    }
    
    // Generate the file path for the PDF
    let fileManager = FileManager.default
    let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let pdfPath = documentsPath.appendingPathComponent("\(name).pdf")
    let thumbnail = generateThumbnail(for: pdfDocument)
    
    if pdfDocument.write(to: pdfPath) {
        fileManagerClass.savedDocuments.append(PDFDocumentModel(name: name, filePath: "\(pdfPath)", thumbnail: thumbnail))
        print("PDF saved to \(pdfPath)")
        return true
    } else {
        print("Failed to save PDF")
        return false
    }
    
}

// Helper function to scale an image to fit A4 dimensions
func scaleImageToFitA4(image: UIImage, pageSize: CGSize) -> UIImage {
    let aspectWidth = pageSize.width / image.size.width
    let aspectHeight = pageSize.height / image.size.height
    let aspectRatio = min(aspectWidth, aspectHeight)
    
    let scaledSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)
    UIGraphicsBeginImageContext(scaledSize)
    image.draw(in: CGRect(origin: .zero, size: scaledSize))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return scaledImage!
}

// Helper function to split an image into multiple pages if it exceeds A4 height
func splitImageIntoPages(image: UIImage, pageSize: CGSize) -> [UIImage] {
    var pages: [UIImage] = []
    var currentY: CGFloat = 0
    
    while currentY < image.size.height {
        let heightRemaining = image.size.height - currentY
        let heightToDraw = min(heightRemaining, pageSize.height)
        
        // Create a new context for the page
        UIGraphicsBeginImageContext(pageSize)
        let drawRect = CGRect(x: 0, y: 0, width: pageSize.width, height: heightToDraw)
        image.draw(at: CGPoint(x: 0, y: -currentY), blendMode: .copy, alpha: 1.0)
        let pageImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let pageImage = pageImage {
            pages.append(pageImage)
        }
        
        currentY += pageSize.height
    }
    
    return pages
}

func generateThumbnail(for pdfDocument: PDFDocument) -> Data? {
    guard let page = pdfDocument.page(at: 0) else { return nil }
    let pageBounds = page.bounds(for: .mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageBounds.size)
    let image = renderer.image { ctx in
        UIColor.white.set()
        ctx.fill(pageBounds)
        page.draw(with: .mediaBox, to: ctx.cgContext)
    }
    return image.pngData()
}
