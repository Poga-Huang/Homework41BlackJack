//
//  GameViewControllerExtension.swift
//  Homework41BlackJack
//
//  Created by 黃柏嘉 on 2021/12/20.
//

import Foundation
import UIKit

extension GameViewController{
    //生成卡片
    func createCards(){
        let suits = ["♣️", "♦️", "♥️", "♠️"]
        let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
        for suit in suits {
            for rank in ranks {
                let card = Card()
                card.suit = suit
                card.rank = rank
                cards.append(card)
             }
        }
    }
    //初始化遊戲
    func gameInit(){
        //初始化兩個牌盒
        CPUCards = [Card]()
        myCards = [Card]()
        
        //初始化我方的索引值
        index = 1
        
        //只顯示兩張牌
        for i in 0...4{
            if i < 2{
                CPUCardView[i].isHidden = false
                myCardView[i].isHidden = false
                cards.shuffle()
                CPUCards.append(cards[i])
                cards.shuffle()
                myCards.append(cards[i])
                CPUSuitLabel[i].text = CPUCards[i].suit
                CPURankLabel[i].text = CPUCards[i].rank
                mySuitLabel[i].text = myCards[i].suit
                myRankLabel[i].text = myCards[i].rank
                CPUSumLabel.text = "\(CPUSum)"
                mySumLabel.text = "\(mySum)"
            }else{
                CPUCardView[i].isHidden = true
                myCardView[i].isHidden = true
            }
        }
        //全部歸零
        for stepper in stepperArray{
            stepper.value = 0
        }
        for label in LabelArray{
            label.text = "x0"
        }
        betLabel.text = "$0"
    }
    //計算點數
    func calculateCardPoint(card:Card)->Int{
        switch card.rank{
        case "A":
            return 1
        case "J","Q","K":
            return 10
        default:
            return Int(card.rank) ?? 0
        }
    }
    
    //發牌
    func getCard(){
        //卡片數5張以內
        if index < 4{
            index += 1
            print(index)
            cards.shuffle()
            myCards.append(cards[Int.random(in: 0...51)])
            myCardView[index].isHidden = false
            mySuitLabel[index].text = myCards[index].suit
            myRankLabel[index].text = myCards[index].rank
            mySumLabel.text = "\(mySum)"
            
            //抽完牌直接先判斷
            if index == 4 && mySum <= 21{
                //過五關
                gameAlert(title: "恭喜!!", message: "過五關")
                myProperty += total
                
            }else if mySum == 21{
                //直接提早滿21點
                gameAlert(title: "恭喜！！", message: "21點獲勝")
                myProperty += total
            }else if mySum > 21{
                //爆了
                myProperty -= total
                if checkBankruput() == false{
                    gameAlert(title: "喔歐....", message: "爆了")
                }else{
                    gameAlert(title: "破產", message: "重新開始遊戲")
                    myProperty = 1000
                }
            }
            betTotalLabel.text = "$\(myProperty)"
        }
    }
    //開牌
    func showCard(){
        //先判斷電腦目前是否不足16點，如果16點以上就不用進行抽牌直接開牌
        if CPUSum <= 16{
            for i in 2...4{
                cards.shuffle()
                CPUCards.append(cards[Int.random(in: 0...51)])
                CPUCardView[i].isHidden = false
                CPUSuitLabel[i].text = CPUCards[i].suit
                CPURankLabel[i].text = CPUCards[i].rank
                CPUSumLabel.text = "\(CPUSum)"
                
                if CPUSum == 21{
                    myProperty -= total
                    if checkBankruput() == false{
                        gameAlert(title: "喔歐....", message: "電腦21點")
                    }else{
                        gameAlert(title: "破產", message: "重新開始遊戲")
                        myProperty = 1000
                    }
                    break
                }else if CPUSum > 21{
                    gameAlert(title: "恭喜!", message: "電腦爆了")
                    myProperty += total
                    break
                }else if i == 4 && CPUSum <= 21{
                    myProperty -= total
                    if checkBankruput() == false{
                        gameAlert(title: "喔歐....", message: "電腦過五關")
                    }else{
                        gameAlert(title: "破產", message: "重新開始遊戲")
                        myProperty = 1000
                    }
                }
            }
            betTotalLabel.text = "$\(myProperty)"
        }else{
            if CPUSum < mySum{
                gameAlert(title: "恭喜", message: "\(mySum)大於\(CPUSum)")
                myProperty += total
            }else if CPUSum > mySum{
                myProperty -= total
                if checkBankruput() == false{
                    gameAlert(title: "喔歐....", message: "\(CPUSum)大於\(mySum)")
                }else{
                    gameAlert(title: "破產", message: "重新開始遊戲")
                    myProperty = 1000
                }
            }else{
                gameAlert(title: "平手", message: "下一局")
            }
            betTotalLabel.text = "$\(myProperty)"
        }
    }
    
    //通知使用者
    func gameAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { okAction in
            alert.dismiss(animated: true, completion: nil)
            self.gameInit()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func alert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { okAction in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //確認是否出金
    func checkBet()->Bool?{
        if total == 0{
            alert(title: "Warning", message: "尚未出金")
           return false
        }else if total > myProperty{
            alert(title: "Warning", message: "財產不足")
            return nil
        }else{
            return true
        }
    }
    //確認是否破產
    func checkBankruput()->Bool{
        if myProperty <= 0{
            return true
        }else{
            return false
        }
    }
}
