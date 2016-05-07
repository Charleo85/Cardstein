//
//  Card.swift
//  Cardstein
//
//  Created by CharlieWu on 3/7/16.
//  Copyright © 2016 CharlieWu. All rights reserved.
//

import Foundation

// MARK: - Globals

func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.rank == rhs.rank && lhs.suit == rhs.suit
}

func <(lhs: Card, rhs: Card) -> Bool {
    return lhs.rank < rhs.rank
}

func <(lhs: Card.Rank, rhs: Card.Rank) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

// MARK: - Card

class Card : Comparable, CustomStringConvertible {
    final let rank		: Rank
    final let suit		: Suit
    final let bitFlag	: UInt8
//    var pin				: Bool = false		// indicates a card that is part of the current hand's category
//    var hold			: Bool = false
    
    init(rank: Card.Rank, suit: Card.Suit) {
        self.rank = rank
        self.suit = suit
        self.bitFlag = self.rank.rankBit + self.suit.shiftVal
    }
    
    init(bitFlag: UInt8) {
        self.rank = Rank(rawValue: Int(bitFlag%13))!
        self.suit = Suit(rawValue: Int(bitFlag/13))!
        self.bitFlag = bitFlag
    }

    
//    func reset() {
//        self.pin = false
//        self.hold = false
//    }
    
    var description: String {
        get {
            return rank.description + suit.description
        }
    }
    
    var fullDescription: String {
        get {
            return rank.fullDescription + suit.fullDescription
        }
    }
    
    // MARK: - Rank
    
    enum Rank: Int, Comparable, CustomStringConvertible {
        case Two = 0, Three, Four, Five, Six, Seven, Eight, Nine, Ten
        case Jack, Queen, King, Ace
        
        static let MinRank = Two
        static let MaxRank = Ace
        static let NumRanks = MaxRank.rawValue + 1 //14
        
        var identifier: String {
            get {
                return self.description
            }
        }
        
        var description: String {
            get {
                switch self {
                case .Ace:
                    return "A"
                case .King:
                    return "K"
                case .Queen:
                    return "Q"
                case .Jack:
                    return "J"
                case .Ten:
                    return "T"
                case let someRank where someRank.rawValue >= Two.rawValue && someRank.rawValue <= Nine.rawValue:
                    return String(someRank.rawValue + 2)
                default:
                    return "?"
                }
            }
        }
        
        var fullDescription: String {
            get {
                switch self {
                case .Ace:
                    return "Ace"
                case .King:
                    return "King"
                case .Queen:
                    return "Queen"
                case .Jack:
                    return "Jack"
                case let someRank where someRank.rawValue >= Two.rawValue && someRank.rawValue <= Ten.rawValue:
                    return String(someRank.rawValue + 2)
                default:
                    return "?"
                }
            }
        }
        
        var rankBit: UInt8 {
            get {
                return UInt8(/*1 <<*/ self.rawValue)
            }
        }
        
        func nextHigher() -> Rank? {
            var next	: Rank? = nil
            
            if (self != Ace) {
                next = Rank(rawValue: self.rawValue + 1)
            }
            
            return next
        }
        
        func nextLower() -> Rank? {
            var prev	: Rank? = nil
            
            if (self != Two) {
                prev = Rank(rawValue: self.rawValue - 1)
            }
            
            return prev
        }
    }
    
    // MARK: - Suit
    
    enum Suit: Int, CustomStringConvertible {
        case Club = 0, Diamond, Heart, Spade
        
        static let MinSuit		= Club
        static let MaxSuit		= Spade
        static let NumSuits		= MaxSuit.rawValue + 1 //4
        
        var identifier: String {
            get {
                switch self {
                case .Club:
                    return "C"
                case .Diamond:
                    return "D"
                case .Heart:
                    return "H"
                case .Spade:
                    return "S"
                }
            }
        }
        
        var description: String {
            get {
                switch self {
                case .Club:
                    return "♣︎"
                case .Diamond:
                    return "♦︎"
                case .Heart:
                    return "♥︎"
                case .Spade:
                    return "♠︎"
                }
            }
        }
        
        var fullDescription: String {
            get {
                switch self {
                case .Club:
                    return "Club"
                case .Diamond:
                    return "Diamond"
                case .Heart:
                    return "Heart"
                case .Spade:
                    return "Spade"
                }
            }
        }
        
        var shiftVal: UInt8 {
            get {
                return UInt8(self.rawValue * 13)
            }
        }
    }
}
