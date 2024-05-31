//
//  gameViewModel.swift
//  tic-tac-toe
//
//  Created by Sumit Chandora on 14/10/23.
//

import Foundation
import SwiftUI


class GameViewModel: ObservableObject {
    var grids = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var move: [Move?] = Array(repeating: nil, count: 9)
    @Published var boardDisabled = false
    var winningMoves: Set<Set<Int>> = Set([[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]])
    @Published var alertItem: AlertProperties?
    
    func afterTappingOnBoard(i: Int){
        if isCircleOccupied(moves: move, i: i){ return }
        move[i] = Move(move: .human, index: i)
        boardDisabled = true
        if checkWinner(player: .human) {
            alertItem = AlertBox.humanWin
            return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            if draw(){
                alertItem = AlertBox.draw
                return }
            let random = computerMove(move: move)
            move[random] = Move(move: .computer, index: random)
            if checkWinner(player: .computer) { alertItem = AlertBox.computerWin
                return }
            boardDisabled = false
        }
        
        func isCircleOccupied(moves:[Move?], i: Int) -> Bool {
            return moves.contains(where: {$0?.index == i})
        }
        
        func computerMove(move: [Move?]) -> Int {
            let computerMoves = move.compactMap { $0 }.filter({ $0.move == .computer })
            let computerIndex = computerMoves.map { $0.index }
            var randomMove = Int.random(in: 0..<9)
            for win in winningMoves {
                // 1.)  if AI win then win
                let winPossibilitiesCheck = win.subtracting(computerIndex)
                if winPossibilitiesCheck.count == 1 {
                    let availableMove = !isCircleOccupied(moves: move, i: winPossibilitiesCheck.first!)
                    if availableMove {
                        return winPossibilitiesCheck.first!
                    }
                }
            }
            for win in winningMoves {
                // 2.)  if AI can't win then block X
                let humanMoves = move.compactMap { $0 }.filter({ $0.move == .human })
                let humanIndex = humanMoves.map { $0.index }
                //  for win in winningMoves {
                let winPossibilitiesOfX = win.subtracting(humanIndex)
                if winPossibilitiesOfX.count == 1 {
                    let available = !isCircleOccupied(moves: move, i: winPossibilitiesOfX.first!)
                    if available {
                        return winPossibilitiesOfX.first!
                    }
                }
            }
            // 3.)  if can't win can't block take center
            let centerIndex = 4
            let centerAvailable = !isCircleOccupied(moves: move, i: 4)
            if centerAvailable {
                return centerIndex
            }
            // 4.) if doing nothing take a random place
            
            while isCircleOccupied(moves: move, i: randomMove) {
                randomMove = Int.random(in: 0..<9)
            }
            return randomMove
        }
    }
    func checkWinner(player: Players) -> Bool {
        let nonNilMoves = move.compactMap({ $0 }).filter { $0.move == player }
        let winMap = Set(nonNilMoves.map { $0.index })
        for win in winningMoves where win.isSubset(of: winMap){
            return true
        }
        return false
    }
    func draw() -> Bool {
        let size = move.compactMap{ $0 }
        if size.count == 9 {
            return true
        }
        return false
    }
    func replay(){
        move = Array(repeating: nil, count: 9)
        boardDisabled = false
    }
}

enum Players {
    case human, computer
}
struct Move {
    var move: Players
    var index: Int
    var XorO: String {
        return (move == .human ? "xmark" : "circle")
    }
}

