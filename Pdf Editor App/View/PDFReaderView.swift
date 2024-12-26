//
//  PDFReaderView.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI

struct PDFReaderView: View {
    let document: PDFDocumentModel
    var body: some View {
        VStack {
            Text("Просмотр PDF")
                .padding(.bottom)
            PDFKitRepresentedView(document: document.filePath)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
