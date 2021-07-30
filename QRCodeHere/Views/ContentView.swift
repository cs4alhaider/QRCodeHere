//
//  ContentView.swift
//  QRCodeHere
//
//  Created by Abdullah Alhaider on 22/12/2019.
//  Copyright © 2019 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text("Open sourced with 💙 at ")
                            +
                            Text("GitHub")
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    .onTapGesture(perform: vm.openGithub)
                    
                    HStack {
                        Spacer()
                        
                        if let qrImage = vm.qrImage,
                           let qrImageDraggable = vm.createQRDraggable() {
                            vm.image(from: qrImage)
                                .padding(.bottom, 25)
                                .onDrag { qrImageDraggable }
                        } else {
                            Text("The text is too large to fit in a QR code.\nTry making it shorter.")
                                .foregroundColor(.secondary)
                                .frame(width: .frame(.qrCodeView), height: .frame(.qrCodeView))
                                .multilineTextAlignment(.center)
                                .border(Color.secondary, width: 1)
                                .padding(.bottom, 25)
                        }
                        
                        Spacer()
                    }
                }
                
                Section {
                    Text("Start typing your text, URL to generate the QR code..")
                        .multilineTextAlignment(.center)
                        .lineLimit(0)
                    HStack {
                        TextField("Enter your text here", text: $vm.text.onChange(vm.saveQRContent))
                        if !vm.pasteboardString.isEmpty {
                            Button("Paste", action: vm.appendCopidString)
                        }
                    }
                    watermarkView
                }
                .frame(minWidth: 335)
                
                Section {
                    Divider()
                        .padding(.vertical)
                }
                
                BottomSection()
            }
            
            MenuView()
                .frame(width: 55)
                .offset(x: 38, y: -30)
        }
        .padding(35)
        .onAppear(perform: vm.updateQRContent)
    }
    
    var watermarkView: some View {
        Section {
            HStack {
                TextField("Enter your watermark here", text: $vm.watermark.onChange(vm.saveWatermarkContent))
                if !vm.watermark.isEmpty {
                    Button("Remove watermark") {
                        vm.watermark = ""
                        vm.saveWatermarkContent("")
                    }
                }
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
