//
//  ContentView.swift
//  watch WatchKit Extension
//
//  Created by Piotr FLEURY on 20/02/2022.
//

import SwiftUI
import OSLog

struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    @State var scrollAmount = 0.0
    
    var crownValueBinding: Binding<Double> {
      Binding<Double>(
        get: { self.scrollAmount },
        set: { newValue in
            self.scrollAmount = newValue
            self.viewModel.shuffle()
        }
      )
    }
    
    func valueTapped(value: Int) {
        viewModel.swap(value: value)
    }
    
    var body: some View {
        ZStack {
//            LinearGradient(
//                colors: [
//                        .gray,
//                        .green,
//                ], startPoint: .top, endPoint: .bottom
//            ).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    HStack {
                        TileView(value: viewModel.data[0], action: valueTapped)
                        TileView(value: viewModel.data[1], action: valueTapped)
                        TileView(value: viewModel.data[2], action: valueTapped)
                    }
                    HStack {
                        TileView(value: viewModel.data[3], action: valueTapped)
                        TileView(value: viewModel.data[4], action: valueTapped)
                        TileView(value: viewModel.data[5], action: valueTapped)
                    }
                    HStack {
                        TileView(value: viewModel.data[6], action: valueTapped)
                        TileView(value: viewModel.data[7], action: valueTapped)
                        TileView(value: viewModel.data[8], action: valueTapped)
                    }
                    Text("Moves: \(viewModel.moves)")
                    Button(action: {
                        viewModel.shuffle()
                    }) {
                        HStack {
                            Image(systemName: "shuffle")
                            Text("Shuffle")
                        }
                    }
                    Button(action: {
                        viewModel.reset()
                    }) {
                        Image(systemName: "arrow.clockwise")
                        HStack {
                            Text("Reset")
                        }
                    }
                }
                
                
            }
            .focusable()
        .digitalCrownRotation(self.crownValueBinding)
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
