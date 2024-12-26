//
//  SavedDocumentsView.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI

struct SavedDocumentsView: View {
    @ObservedObject var fileManager: Documents = .shared
    @State private var isMerging = false
    @State private var selectedDocument: PDFDocumentModel?
    var body: some View {
        VStack {
            List {
                ForEach(fileManager.savedDocuments.indices, id: \.self) { index in
                    let document = fileManager.savedDocuments[index]
                    NavigationLink(destination: PDFReaderView(document: document)) {
                        
                        HStack {
                            if let thumbnailData = document.thumbnail, let uiImage = UIImage(data: thumbnailData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .rotationEffect(Angle(degrees: 180))
                                    .scaleEffect(x: -1, y: 1)
                                    .cornerRadius(5)
                                    .shadow(color: Color(.black).opacity(0.4), radius: 1)
                                
                            } else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                            }
                            VStack(alignment: .leading) {
                                Text(document.name)
                                    .font(.headline)
                                Text("Дата: \(document.creationDate.formatted(.dateTime))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button("Поделиться") {
                                shareDocument(document)
                            }
                            Button("Удалить") {
                                deleteFile(at: document.filePath)
//                                fileManager.savedDocuments.remove(at: index)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Сохраненные документы")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CreatePdfView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isMerging) {
                MergeDocumentsView()
            }
            Button {
                isMerging = true
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                        .foregroundColor(Color(.white))
                    
                    Text("Объединить")
                        .foregroundColor(Color(.white))
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            NavigationLink {
                CreatePdfView()
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(Color(.white))
                    
                    Text("Создать PDF")
                        .foregroundColor(Color(.white))
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)

        }
        
    }

    func shareDocument(_ document: PDFDocumentModel) {
        let url = URL(fileURLWithPath: document.filePath)
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
    }
}

#Preview {
    SavedDocumentsView()
}
