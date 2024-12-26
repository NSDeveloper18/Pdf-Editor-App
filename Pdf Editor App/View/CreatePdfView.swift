//
//  CreatePdfView.swift
//  Pdf Editor App
//
//  Created by Shakhzod Botirov on 26/12/24.
//

import SwiftUI

struct CreatePdfView: View {
    @State var images: [UIImage] = []
    @State var isImagePickerPresented = false
    @State var name = ""
    @FocusState var isKeyboardFocused: Bool
    @ObservedObject var fileManagerClass: Documents = .shared
    @State var saved = false
    @State var saving = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Text("Добавьте изображения, чтобы создать PDF")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .overlay() {
                                VStack {
                                    HStack {
                                        Button {
                                            images.remove(at: index)
                                        } label: {
                                            Image(systemName: "x.circle.fill")
                                                .foregroundColor(.red)
                                                .background(.white)
                                                .cornerRadius(50)
                                                .frame(height: 50)
                                               
                                                .offset(x: -10, y: -20)
                                        }
                                       
                                        
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                    }
                }
                .padding()
            }

            TextField("Имя PDF-файла", text: $name)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .focused($isKeyboardFocused)
            
            if !isKeyboardFocused {
                VStack {
                    Button {
                        isImagePickerPresented = true
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "photo")
                                .foregroundColor(Color(.white))
                            Text("Добавить фотографии")
                                .foregroundColor(Color(.white))
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(images: $images)
                    }
                    
                    Button {
                        if !images.isEmpty && name != "" {
                            saving = true
                            saved = generatePDF(from: images, name: "\(name).pdf")
                        }
                    } label: {
                        if saving {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .tint(.white)
                                Spacer()
                            }
                        }
                        else {
                            HStack {
                                Spacer()
                                Image(systemName: "note.text.badge.plus")
                                    .foregroundColor(Color(.white))
                                Text("Создать PDF")
                                    .foregroundColor(Color(.white))
                                Spacer()
                            }
                        }
                    }
                    .disabled(images.isEmpty || name == "")
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .opacity((images.isEmpty || name == "") ? 0.5 : 1.0)
                    .alert("PDF файл сохранен ✅", isPresented: $saved, actions: {
                        Button("Ok", role: .cancel, action: {
                            dismiss()
                        })
                    })
                    .onChange(of: saved) { _ in
                       saving = false
                    }
                }
            }
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
        .navigationTitle("Создать PDF")
    }
}

#Preview {
    CreatePdfView()
}
