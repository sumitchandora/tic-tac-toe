//
//  ContentView.swift
//  tic-tac-toe
//
//  Created by Sumit Chandora on 14/10/23.
//

import SwiftUI

struct TikTacToe: View {
    @State var last = 2
    @StateObject var viewModel = GameViewModel()
    var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                ZStack {
                    LinearGradient(colors: [.primary], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                    VStack {
                        Spacer()
                        LazyVGrid(columns: viewModel.grids){
                            ForEach(0..<9) {i in
                                ZStack {
                                    ShapeOfBoard(proxy: proxy)
                                    MoveImage(image: viewModel.move[i]?.XorO ?? "")
                                }.onTapGesture {
                                    viewModel.afterTappingOnBoard(i: i)
                                }
                            }
                        }
                        Spacer()
                    }
                }.toolbar {
                    ToolbarItem(placement: .principal){
                        HStack {
                            Spacer().frame(width: 40.0)
                            Text("TikTacToe")
                                .font(.system(size: 50))
                                .bold()
                                .foregroundStyle(LinearGradient(colors: [.purple, .pink, .gray], startPoint: .leading, endPoint: .trailing))
                        }
                    }
                }
            }
        }.disabled(viewModel.boardDisabled)
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: { viewModel.replay()}))
            })
    }
}




struct ShapeOfBoard: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .frame(width: proxy.size.width / 3)
            .foregroundColor(.purple)
    }
}

struct MoveImage: View {
    let image: String
    var body: some View {
        Image(systemName: image)
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundColor(.white)
            .bold()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TikTacToe()
    }
}
