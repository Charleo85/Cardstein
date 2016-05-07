//
//  Hand.swift
//  Cardstein
//
//  Created by CharlieWu on 3/8/16.
//  Copyright © 2016 CharlieWu. All rights reserved.
//

import Foundation

class Hand : CustomStringConvertible {
    private var cardSlots	: [Card?]
    
    var description: String {
        get {
            var desc = String()
            
            for cardSlot in self.cardSlots {
                if let card = cardSlot {
                    if !desc.isEmpty {
                        desc += ","
                    }
                    desc += card.description
                }
            }
            
            if duplicate {
                desc += " - Duplicate🙄"
            }else if cards.count == 5 {
                self.evaluate()
                desc += " - \(self.category)"
//            }else {
//                desc += " - Not Enough Cards"
            }
            
            if desc.isEmpty {
                desc = "Not Enough Cards"
            }
            
            return desc
        }
    }
    
    var cards : [Card] {
        get {
            var	cards = [Card]()
            
            for card in self.cardSlots {
                if let card = card {
                    cards.append(card)
                }
            }
            
            return cards
        }
    }
    
    init() {
        self.cardSlots = [Card?](count: Consts.Game.MaxHandCards, repeatedValue: nil)
    }
    
    init(new: [Card?]) {
        if new.count == 5 {
            self.cardSlots = new
        }else {
            self.cardSlots = [Card?](count: Consts.Game.MaxHandCards, repeatedValue: nil)
        }
    }
    
    init(newN: [Card]) {
        self.cardSlots = [Card?](count: Consts.Game.MaxHandCards, repeatedValue: nil)
        if newN.count == 5 {
            for i in 0...4{
            self.cardSlots[i] = newN[i]
            }
        }
    }
    
    var duplicate: Bool {
        get {
//            var	duplicate = false
            if cards.count < 2{
              return false
            }
            
            for i in 0..<cards.count {
                for j in i+1..<cards.count{
                    if cards[i] == cards[j]{
                        return true
                    }
                }
            }
            return false
        }
    }

    
    subscript (position: Int) -> Card? {
        get {
            return self.cardSlots[position]
        }
        set (newValue) {
            self.cardSlots[position] = newValue
        }
    }
    
//    func initialDrawFromDeck(deck: Deck) {
//        self.cardSlots = [Card?](count: Consts.Game.MaxHandCards, repeatedValue: nil)
//        self.drawFromDeck(deck)
//    }
//    
//    func drawFromDeck(deck: Deck) {
//        for (index, value) in self.cardSlots.enumerate() {
//            if (value == nil || !value!.hold) {
//                self.cardSlots[index] = deck.drawCard()
//            }
//        }
//    }
    
//    func heldCards() -> [Card] {
//        var heldCards	= [Card]()
//        
//        for cardSlot in self.cardSlots {
//            if let card = cardSlot {
////                if card.hold {
//                    heldCards.append(card)
////                }
//            }
//        }
//        
//        return heldCards
//    }
    var	category		= Category.None
    var isStraight		: Bool = false
    var isFlush			: Bool = false
    var	sortedCards		: [Card]!
    var sortedRanks		: [[Card]]!
    var sortedSuits		: [[Card]]!
    
    func evaluate() -> Void {
        category	= Category.None
        sortedCards	= cards
        sortedRanks	= [[Card]](count: Card.Rank.NumRanks, repeatedValue: [Card]())
        sortedSuits	= [[Card]](count: Card.Suit.NumSuits, repeatedValue: [Card]())
        
        if sortedCards!.count == 5 {	// exactly 5 cards required to make a hand
            
            var lastCard		: Card? = nil
            
            sortedCards!.sortInPlace{ $0 > $1 }
            for card in sortedCards! {
                // --->>> count ranks
                sortedRanks[card.rank.rawValue].append(card)
                
                // --->>> count suits
                sortedSuits[card.suit.rawValue].append(card)
                // --->>> straight test
                isStraight = true
                if (isStraight) {
                    if let lastCard = lastCard {
                        if let nextExpected = lastCard.rank.nextLower() {
                            if card.rank != nextExpected {
                                // test special case for the ace. if last was an ace, this card should be a five
                                if lastCard.rank != Card.Rank.Ace || card.rank != Card.Rank.Five {
                                    isStraight = false
                                }
                            }
                        }
                        else {
                            isStraight = false
                        }
                    }
                    lastCard = card
                }
            }
            
            // --->>> Sort ranks and suits
            sortedRanks.sortInPlace { (p1, p2) -> Bool in
                var orderedBefore = p1.count > p2.count
                
                if !orderedBefore {
                    orderedBefore = p1.count > 0 && p1.count == p2.count && p1[0].rank > p2[0].rank
                }
                
                return orderedBefore
            }
            sortedSuits.sortInPlace { (p1, p2) in p1.count > p2.count }
            
            //			print("rankCounts: \(sortedRanks)\nsuitCounts: \(sortedSuits)")

            // --->>> Flush?
            isFlush = sortedSuits[0].count == Consts.Game.MaxHandCards
            
            // --->>> Straight Flush?
            if isFlush && isStraight {
//                sortedCards.iterate { $0.pin = true }	// pin all
                category = sortedCards![4].rank == Card.Rank.Ten ? Category.RoyalFlush : Category.StraightFlush
            }
            else {
                let highestRankCount	= sortedRanks[0].count
                
                if highestRankCount == 4 {
//                    sortedRanks[0].iterate { $0.pin = true }
//                    for card in sortedRanks[0] { card.pin = true }
                    
                    category = Category.FourOfAKind
                }
                else {
                    if highestRankCount == 3 && sortedRanks[1].count == 2 {
//                        sortedRanks[0].iterate { $0.pin = true }
//                        sortedRanks[1].iterate { $0.pin = true }
                        category = Category.FullHouse
                    }
                    else if isFlush {
//                        sortedCards.iterate { $0.pin = true }	// pin all
                        category = Category.Flush
                    }
                    else if isStraight {
//                        sortedCards.iterate { $0.pin = true }	// pin all
                        category = Category.Straight
                    }
                    else if highestRankCount == 3 {
//                        sortedRanks[0].iterate { $0.pin = true }
                        category = Category.ThreeOfAKind
                    }
                    else if highestRankCount == 2 {
                        if sortedRanks[1].count == 2 {
//                            sortedRanks[0].iterate { $0.pin = true }
//                            sortedRanks[1].iterate { $0.pin = true }
                            category = Category.TwoPair
                        }else {//if sortedRanks[0].count == 2 {
                            category = Category.OnePair
                        }
//                        else if sortedRanks[0][0].rank >= Card.Rank.Jack {
//                            sortedRanks[0].iterate { $0.pin = true }
//                            category = Category.highcard
//                        }
                    }
                }
            }
        }
//        return category
    }
    
    func compareHand ( cHand: Hand) -> Bool {
        self.evaluate()
        cHand.evaluate()
        if self.category.rawValue > cHand.category.rawValue{
            return false //larger category
        }else if self.category.rawValue == cHand.category.rawValue{
            switch self.category {
            case .None:
                for i in 0...4 {
                    if self.sortedCards[i] < cHand.sortedCards[i]{
                        return true
                    }
                }
                return false
            case .OnePair:
                if self.sortedRanks[0][0] > cHand.sortedRanks[0][0] {
                    return false
                }else if self.sortedRanks[0][0] == cHand.sortedRanks[0][0]{
                    for i in 0...2 {
                        if self.sortedRanks[i][0] < cHand.sortedRanks[i][0]{
                            return true
                        }
                    }
                    return false
                }
                return true
            case .TwoPair:
                if self.sortedRanks[0][0] > cHand.sortedRanks[0][0] {
                    return false
                }else if self.sortedRanks[0][0] == cHand.sortedRanks[0][0]{
                    if self.sortedRanks[1][0] > cHand.sortedRanks[1][0] {
                        return false
                    }else if self.sortedRanks[1][0] == cHand.sortedRanks[1][0]{
                        return self.sortedRanks[2][0] < cHand.sortedRanks[2][0]
                    }
                }
                return true
            case .ThreeOfAKind:
                if self.sortedRanks[0][0] > cHand.sortedRanks[0][0] {
                    return false
                }else if self.sortedRanks[0][0] == cHand.sortedRanks[0][0]{
                    for i in 0...1 {
                        if self.sortedRanks[i][0] < cHand.sortedRanks[i][0]{
                            return true
                        }
                    }
                    return false
                }
                return true
            case .Straight:
                return self.sortedCards[0] < cHand.sortedCards[0]
            case .Flush:
                return self.sortedCards[0] < cHand.sortedCards[0]
            case .FullHouse:
                if self.sortedRanks[0][0] > cHand.sortedRanks[0][0] {
                    return false
                }else if self.sortedRanks[0][0] == cHand.sortedRanks[0][0]{
                    return self.sortedRanks[1][0] < cHand.sortedRanks[1][0]
                }
                return true
            case .FourOfAKind:
                if self.sortedRanks[0][0] > cHand.sortedRanks[0][0] {
                    return false
                }else if self.sortedRanks[0][0] == cHand.sortedRanks[0][0]{
                    return self.sortedRanks[1][0] < cHand.sortedRanks[1][0]
                }
                return true
            case .StraightFlush:
                return self.sortedCards[0] < cHand.sortedCards[0]
            case .RoyalFlush:
                return false
            }
        }
        return true
    }
    
    
//    func fastEval() -> Category {
//        // normally I don't return in the middle of functions, but this just doesn't
//        // look nice sprinkled with all the breaks and ifs we'd need otherwise
//        var	rankBits		= UInt64(0)
//        var	workBits		: UInt64
//        var cBits			= UInt(0)
//        var dBits			= UInt(0)
//        var hBits			= UInt(0)
//        var sBits			= UInt(0)
//        
//        for cardSlot in self.cardSlots {
//            if let card = cardSlot {
//                rankBits |= card.bitFlag
//            }
//        }
//        
//        workBits = rankBits
//        for rawSuit in 0..<4 {
//            let suitRankBits	= UInt(workBits & Consts.Hands.SuitMask64)
//            
//            if suitRankBits != 0 {
//                var straightMask	= Consts.Hands.RoyalStraightMask		// 0x1f00
//                
//                while straightMask >= Consts.Hands.To6StraightMask {		// >= 0x001f
//                    if suitRankBits == straightMask {
//                        return suitRankBits == Consts.Hands.RoyalStraightMask ? Category.RoyalFlush : Category.StraightFlush
//                    }
//                    straightMask >>= 1
//                }
//                
//                if suitRankBits == Consts.Hands.A5StraightMask {		// 0x100f
//                    return Category.StraightFlush
//                }
//                
//                if suitRankBits.bitCount() == Consts.Game.MaxHandCards {
//                    // if we have a flush that isn't a straight, the only higher hand is 4 of a kind or a full house which we can't have if we have a flush
//                    return Category.Flush
//                }
//                
//                // Why not use an array like a sane person? Well, arrays are slow and I've been unable to find a way to make them
//                // as fast as I'd like. Also, assigning here using this switch is fractionally quicker than shifting and masking
//                // later on
//                switch rawSuit {
//                case Card.Suit.Club.rawValue:		cBits = suitRankBits
//                case Card.Suit.Diamond.rawValue:	dBits = suitRankBits
//                case Card.Suit.Heart.rawValue:		hBits = suitRankBits
//                case Card.Suit.Spade.rawValue:		sBits = suitRankBits
//                default:							break
//                }
//            }
//            workBits >>= UInt64(Card.Rank.NumRanks)
//        }
//        
//        if (cBits & dBits & hBits & sBits) != 0 {
//            return Category.FourOfAKind
//        }
//        else {
//            let match3		= (cBits & dBits & hBits) | (cBits & dBits & sBits)	| (cBits & hBits & sBits) | (dBits & hBits & sBits)
//            var match2		= (cBits & dBits) | (cBits & hBits) | (cBits & sBits)
//            
//            match2 |= (dBits & hBits) | (dBits & sBits) | (hBits & sBits)	// have to break this up otherwise the compiler complains
//            match2 &= ~match3
//            
//            if match3 != 0 && match2 != 0 {
//                return Category.FullHouse
//            }
//            else {
//                var straightMask	= Consts.Hands.RoyalStraightMask		// 0x1f00
//                let	allSuits		= cBits | dBits | hBits | sBits
//                
//                while straightMask >= Consts.Hands.To6StraightMask {		// >= 0x001f
//                    if allSuits == straightMask {
//                        return Category.Straight
//                    }
//                    straightMask >>= 1
//                }
//                
//                if allSuits == Consts.Hands.A5StraightMask {				// 0x100f
//                    return Category.Straight
//                }
//                
//                if match3 != 0 {
//                    return Category.ThreeOfAKind
//                }
//                else {
//                    let pairCount = match2.bitCount()
//                    
//                    if pairCount != 0 {
//                        if pairCount > 1 {
//                            return Category.TwoPair
//                        }
//                        else {
//                            if match2 >= Card.Rank.Jack.rankBit {
//                                return Category.OnePair
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        
//        return Category.None
//    }
    enum Result: Int, CustomStringConvertible {
        case Win = 0
        case Tie
        case Lose
        
        var description: String {
            get {
                switch self {
                case .Win:
                    return "Win"
                case .Tie:
                    return "Tie"
                case .Lose:
                    return "Lose"
                }
            }
        }
    }
    
    /* --- Category --- */
    
    enum Category: Int, CustomStringConvertible {
        case None = 0
        case OnePair
        case TwoPair
        case ThreeOfAKind
        case Straight
        case Flush
        case FullHouse
        case FourOfAKind
        case StraightFlush
        case RoyalFlush
        
        static let WinningCategories	= [RoyalFlush, StraightFlush, FourOfAKind, FullHouse, Flush, Straight, ThreeOfAKind, TwoPair, OnePair]
        static let NumCategories		= RoyalFlush.rawValue + 1
        
        var description: String {
            get {
                switch self {
                case .None:
                    return "None😢"
                case .OnePair:
                    return "One Pair"
                case .TwoPair:
                    return "Two Pair"
                case .ThreeOfAKind:
                    return "Three of a Kind"
                case .Straight:
                    return "Straight 💪"
                case .Flush:
                    return "Flush ✌️"
                case .FullHouse:
                    return "Full House 👍"
                case .FourOfAKind:
                    return "Four of a Kind 👏"
                case .StraightFlush:
                    return "Straight Flush 😎"
                case .RoyalFlush:
                    return "Royal Flush 🤑"
                }
            }
        }
    }
}

struct Consts {
        struct Notifications {
            static let RefreshEV			: String = "QS_EVRefreshNotification"
        }
        
        struct Game {
            static let MaxDeckCards			: Int = 52
            static let MaxHandCards			: Int = 5
        }
        
        struct Views {
            static let PinAnimationTime		: NSTimeInterval = 0.50
            static let RevealAnimationTime	: NSTimeInterval = 0.30
            static let CardViewTagStart		: Int = 1000
        }
        
//        struct Hands {
//            static let SuitMask				= UInt(0x1fff)		// 13 bits
//            static let SuitMask64			= UInt64(0x1fff)	// 13 bits
//            static let RoyalStraightMask	= UInt(Card.Rank.Ace.rankBit | Card.Rank.King.rankBit | Card.Rank.Queen.rankBit | Card.Rank.Jack.rankBit | Card.Rank.Ten.rankBit)
//            static let To6StraightMask		= UInt(Card.Rank.Six.rankBit | Card.Rank.Five.rankBit | Card.Rank.Four.rankBit | Card.Rank.Three.rankBit | Card.Rank.Two.rankBit)
//            static let A5StraightMask		= UInt(Card.Rank.Five.rankBit | Card.Rank.Four.rankBit | Card.Rank.Three.rankBit | Card.Rank.Two.rankBit | Card.Rank.Ace.rankBit)
//            static let AllStraightMasks		: [UInt] = [
//                RoyalStraightMask,
//                UInt(Card.Rank.King.rankBit | Card.Rank.Queen.rankBit | Card.Rank.Jack.rankBit | Card.Rank.Ten.rankBit | Card.Rank.Nine.rankBit),
//                UInt(Card.Rank.Queen.rankBit | Card.Rank.Jack.rankBit | Card.Rank.Ten.rankBit | Card.Rank.Nine.rankBit | Card.Rank.Eight.rankBit),
//                UInt(Card.Rank.Jack.rankBit | Card.Rank.Ten.rankBit | Card.Rank.Nine.rankBit | Card.Rank.Eight.rankBit | Card.Rank.Seven.rankBit),
//                UInt(Card.Rank.Ten.rankBit | Card.Rank.Nine.rankBit | Card.Rank.Eight.rankBit | Card.Rank.Seven.rankBit | Card.Rank.Six.rankBit),
//                UInt(Card.Rank.Nine.rankBit | Card.Rank.Eight.rankBit | Card.Rank.Seven.rankBit | Card.Rank.Six.rankBit | Card.Rank.Five.rankBit),
//                UInt(Card.Rank.Eight.rankBit | Card.Rank.Seven.rankBit | Card.Rank.Six.rankBit | Card.Rank.Five.rankBit | Card.Rank.Four.rankBit),
//                UInt(Card.Rank.Seven.rankBit | Card.Rank.Six.rankBit | Card.Rank.Five.rankBit | Card.Rank.Four.rankBit | Card.Rank.Three.rankBit),
//                To6StraightMask,
//                A5StraightMask
//            ]
//        }
}

//extension UInt {
//        func bitCount() -> Int {
//            var workVal	= self
//            var count	= 0
//            
//            while workVal != 0 {
//                workVal &= workVal - 1
//                count++
//            }
//            
//            return count
//        }
//}
//
//extension Array {
//        func iterate(apply: (Element) -> ()) {
//            for item in self { apply(item) }
//        }
//}