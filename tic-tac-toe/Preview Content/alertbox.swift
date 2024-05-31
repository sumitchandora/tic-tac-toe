//
//  alertBox.swift
//  tic-tac-toe
//
//  Created by Sumit Chandora on 14/10/23.
//

import SwiftUI

struct AlertProperties: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}


struct AlertBox {
    static var humanWin = AlertProperties(title: Text("Congrats you win 🎊"), message: Text("You beat the computer"), buttonTitle:  Text("Dismiss"))
    static var computerWin = AlertProperties(title: Text("Computer wins"), message: Text("You loss the game"), buttonTitle: Text("Dismiss"))
    static var draw = AlertProperties(title: Text("Match draw."), message: Text("No-one wins"), buttonTitle: Text("Try Again"))
}
