//
//  ContentView.swift
//  BetterRest
//
//  Created by Zi on 18/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 0.0
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted()) Hours:", value: $sleepAmount, in: 4...12, step: 0.25)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
