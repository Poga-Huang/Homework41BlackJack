//
//  ViewController.swift
//  Homework41BlackJack
//
//  Created by 黃柏嘉 on 2021/12/19.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {
    
    //賭金
    @IBOutlet weak var betTotalLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var tenDollarsQtyLabel: UILabel!
    @IBOutlet weak var tenDollarsStepper: UIStepper!
    @IBOutlet weak var fiftyDollarsQtyLabel: UILabel!
    @IBOutlet weak var fiftyDollarsStepper: UIStepper!
    @IBOutlet weak var oneHundredDollarsQtyLabel: UILabel!
    @IBOutlet weak var oneHundredDollarsStepper: UIStepper!
    @IBOutlet var stepperArray: [UIStepper]!
    @IBOutlet var LabelArray: [UILabel]!
    
    
    //電腦方
    @IBOutlet var CPUCardView: [UIView]!
    @IBOutlet var CPURankLabel: [UILabel]!
    @IBOutlet var CPUSuitLabel: [UILabel]!
    @IBOutlet weak var CPUSumLabel: UILabel!
    //己方
    @IBOutlet var myCardView: [UIView]!
    @IBOutlet var myRankLabel: [UILabel]!
    @IBOutlet var mySuitLabel: [UILabel]!
    @IBOutlet weak var mySumLabel: UILabel!
    
    //賭金變數
    var tenDollarsCount:Int{
        return Int(tenDollarsStepper.value)
    }
    var fiftyDollarsCount:Int{
        return Int(fiftyDollarsStepper.value)
    }
    var oneHundredDollarsCount:Int{
        return Int(oneHundredDollarsStepper.value)
    }
    var total:Int{
        return (tenDollarsCount*10)+(fiftyDollarsCount*50)+(oneHundredDollarsCount*100)
    }
    
    var CPUSum:Int{
        var CPUSum = 0
        for i in CPUCards{
            CPUSum += calculateCardPoint(card: i)
        }
        return CPUSum
    }
    var mySum:Int{
        var mySum = 0
        for i in myCards{
            mySum += calculateCardPoint(card: i)
        }
        return mySum
    }
    
    //牌組變數
    
    var cards = [Card]()
    var CPUCards = [Card]()
    var myCards = [Card]()
    //初始籌碼
    var myProperty = 1000
    var index = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //產生出52張牌
        createCards()
        gameInit()
    }
    
    
    //控制賭金數量
    @IBAction func betControl(_ sender: UIStepper) {
        tenDollarsQtyLabel.text = "x\(tenDollarsCount)"
        fiftyDollarsQtyLabel.text = "x\(fiftyDollarsCount)"
        oneHundredDollarsQtyLabel.text = "x\(oneHundredDollarsCount)"
        betLabel.text = "$\(total)"
    }
    
    @IBAction func Hit(_ sender: UIButton) {
        //檢查是否有出賭金
        if checkBet() == true{
            getCard()
        }
    }
    @IBAction func Stand(_ sender: UIButton) {
        if checkBet() == true{
            showCard()
        }
    }
}
