//
//  MergeDocumentsView.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI

struct MergeDocumentsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var fileManager: Documents = .shared
    @State private var selectedDocuments: [PDFDocumentModel] = []
    @State var name = ""
    @State var save = false
    @State var lessAlert = false
    @FocusState var isKeyboardFocused: Bool
    var body: some View {
        VStack {
            Text("Выберите документ для объединения")
                .font(.headline)
                .padding(.bottom)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(fileManager.savedDocuments) { document in
                    Button(action: {
                        toggleDocumentSelection(document)
                    }) {
                        HStack(alignment: .center) {
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
                                Spacer()
                                Text("Дата: \(document.creationDate.formatted(.dateTime))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: selectedDocuments.contains(where: { $0.id == document.id })
                                  ? "checkmark.circle.fill"
                                  : "circle")
                            .font(.system(size: 22))
                        }
                        .padding()
                        .frame(height: 60)
                    }
                    
                    Divider()
                }
                
            }
            Spacer()
            
            Button(action: {
                if selectedDocuments.count >= 2 {
                    save = true
                }
                else {
                    lessAlert = true
                }
            }, label: {
                HStack {
                    Spacer()
                    Text("Объединить")
                        .foregroundStyle(Color(.white))
                    Spacer()
                }
            })
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            
            .alert("Введите имя для PDF файла", isPresented: $save, actions: {
                TextField("Имя PDF-файла", text: $name)
                Button("Отмена", role: .destructive, action: {
                    
                })
                Button("Oк", role: .cancel, action: {
                    if let mergedURL = mergePDFs(documents: selectedDocuments, outputFileName: "\(name == "" ? "MergedDocument" : name).pdf") {
                        print("Merged document saved to \(mergedURL)")
                        dismiss()
                    } else {
                        print("Failed to merge documents")
                        dismiss()
                    }
                })
            })
            
            .alert("Выберите как минимум 2 файлов", isPresented: $lessAlert, actions: {
                Button("Oк", role: .cancel, action: {
                    
                })
            })
        }
        .padding()
    }
    
    private func toggleDocumentSelection(_ document: PDFDocumentModel) {
        if let index = selectedDocuments.firstIndex(where: { $0.id == document.id }) {
            selectedDocuments.remove(at: index)
        } else {
            selectedDocuments.append(document)
        }
    }
}
