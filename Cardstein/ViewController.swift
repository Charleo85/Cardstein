//
//  ViewController.swift
//  Cardstein
//
//  Created by CharlieWu on 10/5/15.
//  Copyright © 2015 CharlieWu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var getBack24: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet weak var card_0: UISegmentedControl!
    
    @IBOutlet weak var card_1: UISegmentedControl!
    
    @IBOutlet weak var card_2: UISegmentedControl!
    
    @IBOutlet weak var card_3: UISegmentedControl!
    
    @IBOutlet weak var selectedCards: UILabel!
    
    @IBOutlet weak var result24: UILabel!
    
    @IBOutlet weak var Solve24: UIButton!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateLabel()

    }
			
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    var cards: [String] = ["","","",""]
    var cardsList: [Double] = [0,0,0,0]
    
    func updateLabel () -> Void {
    cards[0] = card_0.titleForSegmentAtIndex(card_0.selectedSegmentIndex)!
    cardsList[0] = Double (card_0.selectedSegmentIndex + 1)
    cards[1] = card_1.titleForSegmentAtIndex(card_1.selectedSegmentIndex)!
    cardsList[1] = Double (card_1.selectedSegmentIndex + 1)
    cards[2] = card_2.titleForSegmentAtIndex(card_2.selectedSegmentIndex)!
    cardsList[2] = Double (card_2.selectedSegmentIndex + 1)
    cards[3] = card_3.titleForSegmentAtIndex(card_3.selectedSegmentIndex)!
    cardsList[3] = Double (card_3.selectedSegmentIndex + 1)
    selectedCards.text = cards.description
    
    }

    @IBAction func getBack24(sender: AnyObject) {
        self.performSegueWithIdentifier("24toMain", sender: self)
    }
    
    @IBAction func card_0(sender: AnyObject) {
        cards[0] = card_0.titleForSegmentAtIndex(card_0.selectedSegmentIndex)!
        selectedCards.text = cards.description
        cardsList[0] = Double (card_0.selectedSegmentIndex + 1)
 
    }
    
    @IBAction func card_1(sender: AnyObject) {
        cards[1] = card_1.titleForSegmentAtIndex(card_1.selectedSegmentIndex)!
        selectedCards.text = cards.description
        cardsList[1] = Double (card_1.selectedSegmentIndex + 1)
 
    }

    @IBAction func card_2(sender: AnyObject) {
        cards[2] = card_2.titleForSegmentAtIndex(card_2.selectedSegmentIndex)!
        selectedCards.text = cards.description
        cardsList[2] = Double (card_2.selectedSegmentIndex + 1)

    }
    
    @IBAction func card_3(sender: AnyObject) {
        cards[3] = card_3.titleForSegmentAtIndex(card_3.selectedSegmentIndex)!
        selectedCards.text = cards.description
        cardsList[3] = Double (card_3.selectedSegmentIndex + 1)
 
    }
    
    @IBAction func Solve24(sender: AnyObject) {
        let solveResult = massCalc (cardsList)
        if solveResult.0 {
        result24.text = showOperation(solveResult.1)
        }else {
        result24.text = "放弃吧,少年！"

        }
    }
    
    func showOperation (ansList:[[Int]])-> String {
        let ans = ansList[0]
        let m = Int(cardsList[0])
        let n = Int(cardsList[1])
        let p = Int(cardsList[2])
        let q = Int(cardsList[3])
        
        let num_0 = ans[0]%6
        let num_1 = ans[1]%6
        let num_2 = ans[2]%6
        
        var result: String = ""
        var result_1: String = ""
        
        func addSecOperator (n:Int, p:Int) -> String{
            var resultSec: String = ""
            var resultTri: String = ""
            switch ans[1]/6 {
            case 0:resultSec = addOperator(num_1,s1: result,s2: String(n))
                    resultTri = addOperator(num_2,s1: resultSec,s2: String(p))
            case 1:resultSec = addOperator(num_1,s1: result,s2: String(p))
                    resultTri = addOperator(num_2,s1: resultSec,s2: String(n))
            case 2:resultSec = addOperator(num_1,s1: String(n),s2: String(p))
                    resultTri = addOperator(num_2,s1: resultSec,s2: result)
            default: print("error")
            }
            return resultTri
        }

        switch ans[0]/6 {
        case 0:result = addOperator(num_0,d1: m, d2: n)
        result_1 = addSecOperator(p,p: q)
        case 1:result = addOperator(num_0,d1: m, d2: p)
        result_1 = addSecOperator(q,p: n)
        case 2:result = addOperator(num_0,d1: m, d2: q)
        result_1 = addSecOperator(p,p: n)
        case 3:result = addOperator(num_0,d1: n, d2: q)
        result_1 = addSecOperator(m,p: p)
        case 4:result = addOperator(num_0,d1: n, d2: p)
        result_1 = addSecOperator(m,p: q)
        case 5:result = addOperator(num_0,d1: p, d2: q)
        result_1 = addSecOperator(m,p: n)
        default: print("error")
        }
        
        return result_1
    }
    
    func addOperator (num: Int, s1: String,s2: String) -> String {
        var result: String = ""
        switch num {
        case 0: result = "("+s1+"+"+s2+")"
        case 1: result = "("+s1+"-"+s2+")"
        case 2: result = "("+s1+"×"+s2+")"
        case 3: result = "("+s1+"÷"+s2+")"
        case 4: result = "("+s2+"-"+s1+")"
        case 5: result = "("+s2+"÷"+s1+")"
        default: print("error")
        }
        return result
    }
    
    func addOperator (num: Int, d1: Int,d2: Int) -> String {
        let s1 = String(d1)
        let s2 = String(d2)
        var result: String = ""
        switch num {
        case 0: result = "("+s1+"+"+s2+")"
        case 1: result = "("+s1+"-"+s2+")"
        case 2: result = "("+s1+"×"+s2+")"
        case 3: result = "("+s1+"÷"+s2+")"
        case 4: result = "("+s2+"-"+s1+")"
        case 5: result = "("+s2+"÷"+s1+")"
        default: print("error")
        }
        return result
    }
    
    func massCalc (cardsList : [Double])-> (Bool, [[Int]]){
        var booo = false
        var sets:[[Int]] = []
        let list = com4to3 (cardsList)
        for i in 0..<list.count {
            let x = list[i]
            for j in 0..<com3to2(x).count {
                let y = com3to2(x)[j]
                for k in 0..<Stepcalc(y).count {
                    let z = Stepcalc(y)[k]
                    if abs(z-24) < 0.0001{
                    booo = true
                    sets.append([i,j,k])
                    }
                }
                
            }
        }
        return (booo, sets)
    }
    
    func com4to3 (cardsList : [Double])-> [[Double]]{
        let m = cardsList[0]
        let n = cardsList[1]
        let p = cardsList[2]
        let q = cardsList[3]
        var result: [[Double]] = []
        let list_0 = Stepcalc(m,b: n)
        let list_1 = Stepcalc(m,b: p)
        let list_2 = Stepcalc(m,b: q)
        let list_3 = Stepcalc(n,b: q)
        let list_4 = Stepcalc(n,b: p)
        let list_5 = Stepcalc(p,b: q)
        for x in list_0 {result.append([x,p,q])}
        for x in list_1 {result.append([x,q,n])}
        for x in list_2 {result.append([x,p,n])}
        for x in list_3 {result.append([x,m,p])}
        for x in list_4 {result.append([x,m,q])}
        for x in list_5 {result.append([x,m,n])}
        return result
    }
    
    func com3to2 (cardsList : [Double])-> [[Double]]{
        let m = cardsList[0]
        let n = cardsList[1]
        let p = cardsList[2]
        var result: [[Double]] = []
        let list_0 = Stepcalc(m,b: n)
        let list_1 = Stepcalc(m,b: p)
        let list_2 = Stepcalc(n,b: p)
        for x in list_0 {result.append([x,p])}
        for x in list_1 {result.append([x,n])}
        for x in list_2 {result.append([x,m])}
        return result
    }
    
    func Stepcalc (a: Double,b: Double) -> [Double] {
        var resultsList: [Double] = [0,0,0,0,0,0]
        resultsList[0] = a+b
        resultsList[1] = a-b
        resultsList[2] = a*b
        resultsList[3] = a/b
        resultsList[4] = b-a
        resultsList[5] = b/a
        return resultsList
    }
    
    func Stepcalc (dArray: [Double]) -> [Double] {
        var resultsList: [Double] = [0,0,0,0,0,0]
        let m = dArray[0]
        let n = dArray[1]
        resultsList[0] = m+n
        resultsList[1] = m-n
        resultsList[2] = m*n
        resultsList[3] = m/n
        resultsList[4] = n-m
        resultsList[5] = n/m
        return resultsList
    }
    
    
    
    
 
}


