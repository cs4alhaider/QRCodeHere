//
//  MenuView.swift
//  QRCodeHere
//
//  Created by Abdulaziz AlObaili on 03/07/2021.
//  Copyright © 2021 Abdullah Alhaider. All rights reserved.
//

import SwiftUI
import LaunchAtLogin

struct MenuView: View {
    var body: some View {
        MenuButton("􀍟") {
            Button("GitHub", action: String.stringURL(.githubRepo).openURL)
            LaunchAtLogin.Toggle()
            Divider()
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
