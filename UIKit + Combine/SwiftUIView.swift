//
//  SwiftUIView.swift
//  UIKit + Combine
//
//  Created by Damir Lutfullin on 12.11.2020.
//

import SwiftUI
import Combine

struct SwiftUIView: View {
    @ObservedObject var tempViewModel = TempViewModel()
    
    var body: some View {
        VStack (alignment: .leading) {
            TextField("city", text: $tempViewModel.city)
                .autocapitalization(.words)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accentColor(.blue)
            Text(
                tempViewModel.currentWeather.main?.temp != nil ? " температура: \((tempViewModel.currentWeather.main?.temp!.description)!)" : ""
            )
            Spacer()
        }
        .font(.title)
        .padding()
    
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
