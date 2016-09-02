//
//  ViewController_Texas.swift
//  Cardstein
//
//  Created by CharlieWu on 10/26/15.
//  Copyright © 2015 CharlieWu. All rights reserved.
//

import UIKit

class ViewController_Texas: UIViewController {
    
    @IBOutlet weak var Previous: UIButton!
    @IBAction func Previous(sender: AnyObject) {
        Total.text = preValue?.description
        if preValue != nil {
        totalValue = preValue!
        Total.text = totalValue.description
        }
    }
    @IBOutlet weak var Next: UIButton!
    @IBAction func Next(sender: AnyObject) {
        preValue = totalValue
        if let bet = Int(Bet.text!) {
        totalValue += bet
        Total.text = totalValue.description
        Bet.text = "0"
        }
    }

    @IBOutlet weak var Bet: UITextField!
    @IBOutlet weak var Total: UILabel!  
    @IBOutlet weak var result: UILabel!

//    var eva :[Card?] = [Card(rank: Card.Rank.Ten, suit: Card.Suit.Diamond),Card(rank: Card.Rank.Ten, suit: Card.Suit.Heart),Card(rank: Card.Rank.Ten, suit: Card.Suit.Club),Card(rank: Card.Rank.Ten, suit: Card.Suit.Spade),Card(rank: Card.Rank.Nine, suit: Card.Suit.Diamond)]
    @IBOutlet weak var Refresh: UIButton!
    @IBAction func Refresh(sender: AnyObject) {
//        getCards()
        if self.duplicate(){
            result.text = "Duplicate🙄"
        }else{
            result.text = getHand().description
        }
//        print(Hand(new: cards).compareHand(Hand(new: eva)))
//        let hand = Hand(new: eva)
//        hand.evaluate()
//        result.text = hand.description
        
//        let res = predict()
//        result.text = result.text! + "\n" + res.win.description + " , " + res.lose.description
        
//        var	cards : [Card] = []
//        for cardview in cardViews! {
//            if cardview.card != nil {
//            cards.append(cardview.card!)
//            }
//        }
//        let deck = Deck(toRemove: cards)
//        print(deck.draw(cards))
    }
    @IBOutlet weak var Hide: UIButton!
    @IBAction func Hide(sender: AnyObject) {
        hide()
    }
    @IBOutlet weak var SuitSelector: UISegmentedControl!
    @IBAction func SuitSelector(sender: AnyObject) {
        deactivate()
        update()
    }
    @IBOutlet weak var RankSelector: UISegmentedControl!
    @IBAction func RankSelector(sender: AnyObject) {
        deactivate()
        update()
    }
    
    @IBOutlet weak var table1: CardView!
    @IBOutlet weak var table2: CardView!
    @IBOutlet weak var table3: CardView!
    @IBOutlet weak var table4: CardView!
    @IBOutlet weak var table5: CardView!
    
    @IBOutlet weak var hand1: CardView!
    @IBOutlet weak var hand2: CardView!
    
    var cardViews = [CardView]()
    var table = [CardView]()
    var onHand = [CardView]()
    var deactivedCard: CardView?
    var activedCard: CardView?
    var preValue: Int?
    var totalValue = 0
//    var cards = [Card?](count: Consts.Game.MaxHandCards, repeatedValue: nil)
    //to opitmize
//    var hands : [[Card?]]!
    func allHands() -> [[Card?]] {
            var hands = [[Card?]]()
            var	cards = [Card?]()
            for cardview in cardViews {
                    cards.append(cardview.card)
                }
            for i in 0...2 {
                for j in i+1 ... 3 {
                    for k in j+1 ... 4 {
                        for p in k+1 ... 5 {
                            for q in p+1 ... 6 {
                                let hand : [Card?] = [cards[i],cards[j],cards[k],cards[p],cards[q]]
                                hands.append(hand)
                            }
                        }
                    }
                }
            }
                    return hands
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table = [table1,table2,table3,table4,table5]
        onHand = [hand1,hand2]
        cardViews = table + onHand
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    func update() {
        for cardview in cardViews {
            if cardview.enabled {
                cardview.card = Card(rank: Card.Rank(rawValue: RankSelector.selectedSegmentIndex)!, suit: Card.Suit(rawValue: SuitSelector.selectedSegmentIndex)!)
                cardview.update()
                deactivedCard = cardview
            }
        }
    }
    
    func hide(){
        for cardview in cardViews {
            if cardview.enabled {
                cardview.hide()
            }
        }
    }
    
    func deactivate(){
        for cardview in cardViews {
            if cardview.enabled {
                if cardview != deactivedCard{
                    deactivedCard?.enabled = false
                    deactivedCard?.update()
                }
            }
        }
    }
    
    func getHand() -> Hand {
        let hands = allHands()
        var b = 0
//        if hands.count == 1 {
//            return bestHand
//        }
//        bestHand.evaluate()
        if Hand(new : hands[0]).cards.count != 5{
            return Hand()
        }
        for i in 1..<hands.count {
            let bestHand = Hand(new : hands[b])
            let chand = Hand(new : hands[i])
            if bestHand.compareHand(chand){
                b = i
                print(b, chand)
            }
        }
        return Hand(new : hands[b])
    }
    
    func duplicate() -> Bool {
        var cards: [Card?] = []
        for cardview in cardViews {
            cards.append(cardview.card)
        }
        return Hand(new: cards).duplicate
    }
    
    func predict() -> (win: Int, lose: Int){
        var win: Int = 0
        var lose: Int = 0
        var	onHands = [Card]()
        for cardview in onHand {
            if cardview.card != nil {
                onHands.append(cardview.card!)
            }
        }
        var	tables = [Card]()
        for cardview in table {
            if cardview.card != nil {
                tables.append(cardview.card!)
            }
        }
        let cards = tables + onHands
        let deck = Deck(toRemove: cards)
        let hands = deck.draw(cards)
        let opponent = deck.draw(tables)
//        var b = 0
        switch (table.count){
        case 3,4:
            for hand in hands{
                let myhand = Hand(newN : hand)
                for oppo in opponent {
                    let chand = Hand(newN : oppo)
                    if myhand.compareHand(chand){
                        lose++
                    }else{
                        win++
                    }
                }
            }
        case 5:
            let myhand = getHand()
            for hand in opponent {
                let chand = Hand(newN : hand)
                if myhand.compareHand(chand){
                    lose++
                }else{
                    win++
                }
            }
        default:
            break
        }
//        if (cards.count > 1 && cards.count < 5 ) {
//        for i in 1..<hands.count {
//            let bestHand = Hand(newN : hands[b])
//            let chand = Hand(newN : hands[i])
//            if bestHand.compareHand(chand){
//                lose++
//                b = i
//                print(b, chand)
//            }else{
//                win++
//            }
//        }
//        }
        return (win, lose)
    }

    
    @IBOutlet var backTexas: UIScreenEdgePanGestureRecognizer!

    @IBAction func getbackTexas(sender: AnyObject) {
        self.performSegueWithIdentifier("TexastoMain", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
