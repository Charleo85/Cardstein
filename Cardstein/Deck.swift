//
//  Deck.swift
//  Cardstein
//
//  Created by CharlieWu on 3/9/16.
//  Copyright © 2016 CharlieWu. All rights reserved.
//

import Foundation

class Deck : CustomStringConvertible {
    private var deck : [UInt8?]
    
    
    init() {
        deck = []
        for i in 0..<Consts.Game.MaxDeckCards {
            let p = UInt8(i)
            self.deck.append(p)
        }
    }
    
    init(toRemove: [Card]){
        deck = []
        for i in 0..<Consts.Game.MaxDeckCards {
            let p = UInt8(i)
            self.deck.append(p)
        }
        for card in toRemove{
            let i = Int(card.bitFlag)
            deck[i] = nil
        }
    }
    
    var description: String {
        get {
            var desc = String()
            for card in deck {
                if card != nil {
                    desc += (card?.description)!
                }else{
                    desc += "nil"
                }
                desc += ","
            }
            return desc
        }
    }
    
    func draw (input: [Card]) -> [[Card]]{
        var output = [[Card]]()
        var cards = [Card]()
        for card in input {
                cards.append(card)
        }
        let num = 5 - cards.count

        switch (num) {
            case 1:
                for i in 0...51 {
                    if deck[i] != nil {
                        let iCard = Card(bitFlag: deck[i]!)
                        cards.append(iCard)
                        output.append(cards)
                        cards.removeLast()
                    }
                }
            case 2:
                for i in 0...50 {
                    if deck[i] != nil {
                        let iCard = Card(bitFlag: deck[i]!)
                        cards.append(iCard)
                        for j in i+1 ... 51{
                            if deck[j] != nil {
                                let jCard = Card(bitFlag: deck[j]!)
                                cards.append(jCard)
                                output.append(cards)
                                cards.removeLast()
                            }
                        }
                        cards.removeLast()
                    }
                }
            case 3:
                for i in 0...49 {
                    if deck[i] != nil {
                        let iCard = Card(bitFlag: deck[i]!)
                        cards.append(iCard)
                        for j in i+1 ... 50{
                            if deck[j] != nil {
                                let jCard = Card(bitFlag: deck[j]!)
                                cards.append(jCard)
                                for k in j+1 ... 51{
                                    if deck[k] != nil {
                                        let kCard = Card(bitFlag: deck[k]!)
                                        cards.append(kCard)
                                        output.append(cards)
                                        cards.removeLast()
                                    }
                                }
                                cards.removeLast()
                            }
                        }
                        cards.removeLast()
                    }
            }
            case 0:
                for i in 0...51 {
                    if deck[i] != nil {
                    let iCard = Card(bitFlag: deck[i]!)
                        for j in 0...4{
                            var jCard = [Card]()
                            for k in 0...4{
                                if k != j {
                                    jCard.append(cards[k])
                                }else{
                                    jCard.append(iCard)
                                }
                            }
                            output.append(jCard)
                        }
                    }
                }
                for i in 0...50 {
                    if deck[i] != nil {
                    let iCard = Card(bitFlag: deck[i]!)
                        for j in i+1...51{
                            if deck[j] != nil {
                                let jCard = Card(bitFlag: deck[j]!)
                                for k in 0...3{
                                    for p in k+1...4{
                                        var cardss = [Card]()
                                        for q in 0...4{
                                        if q == p {
                                            cardss.append(iCard)
                                        }else if q == k {
                                            cardss.append(jCard)
                                        }else{
                                            cardss.append(cards[q])
                                            }
                                    }
                                        output.append(cardss)
                                    }
                                }
                            }
                            }
                        }
                }
//            case -1:
//            
            default:
                break
        }

        return output
    }


}