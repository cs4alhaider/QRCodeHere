//
//  MenuView.swift
//  QRCodeHere
//
//  Created by Abdulaziz AlObaili on 03/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        MenuButton("􀌇") {
            Button("Quit", action: quit)
        }
        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
        .padding()
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.secondary)
    }

    func quit() {
        NSApp.terminate(self)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
