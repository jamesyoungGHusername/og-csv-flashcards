//
//  Deck.swift
//  quiztake2
//
//  Created by James Young on 10/10/21.
//
/*
 TO DO

 
 */

import Foundation
import UIKit
class Deck{
    //deck class contains array of cards, identifying details, and index of current card being displayed
    private var cards:[BaseCard] = []
    private var name=""
    private var notes=""
    private var currentCard=0
    private var category=""
    private var color:UIColor
    private var repeatNameID=0
    private var location=""
    var complete:Bool
    convenience init(){
        self.init("","",cardArray: [])
    }
    convenience init(_ d:Deck){
        self.init(d.getName(),d.getCategory(),cardArray:d.getCards())
    }
    init (_ name: String,_ category: String,cardArray:Array<BaseCard>){
        self.name=name
        self.category=category
        self.cards=cardArray
        self.currentCard=0
        color=UIColor.white
        complete = !(name == "" || name == "[Unnamed]" || category == "" || category == "[Incomplete]" || cards.count==0)
    }
   /* func setURL(newURL:URL){
        filePath=newURL
    }
    func getURL()->URL{
        return filePath
    }
    */
    func getLocation()->String{
        return location
    }
    func setComplete()->Bool{
        var b = !(name == "" || name == "[Unnamed]" || category == "" || category == "[Incomplete]" || cards.count==0)
        for card in cards{
            if card.getAnswer()=="" || card.getQuestion()==""{
                b=false
            }
        }
        return b
    }
    func setLocation(l:String){
        location=l
    }
    func removeCardAt(_ i:Int){
        cards.remove(at: i)
    }
    func setName(name:String){
        self.name=name
    }
    func setCategory(category:String){
        self.category=category
    }
    func addCard(card:BaseCard){
        cards.append(card)
    }
    func getCurrentCard() -> BaseCard{
        return cards[currentCard]
    }
    func getCards()->[BaseCard]{
        return cards
    }
    func getCurrentCardIndex() ->  Int{
        return currentCard
    }
    func shuffleDeck(){
        cards.shuffle()
        for card in cards {
            card.setCompleted(c: false)
            card.setFaceUp(state: true)
            card.setAttempts(i: 0)
        }
        currentCard=0
    }
    func getCategory()->String{
        return category
    }
    func nextCard(){
        if currentCard<cards.count-1{
            currentCard+=1
        }
        
    }
    func hasNext() -> Bool{
        if currentCard<cards.count-1{
            return true
        }else{
            return false
        }
    }
    func prevCard(){
        if currentCard>0{
            currentCard-=1
        }
    }
    func getCompleted()->Int{
        var total=0
        for card in cards{
            if card.isCompleted(){
                total+=1
            }
        }
        return total
    }
    func setColor(_ c:UIColor){
        color=c
    }
    func setColorFromRGB(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat){
        color=UIColor(red: r, green: g, blue: b, alpha: a)
    }
    func getColor()->UIColor{
        return color
    }
    func getName()->String{
        return name
    }
    func getRepeatNameID()->Int{
        return repeatNameID
    }
    func setRepeatNameID(i:Int){
        repeatNameID=i
    }
    func removeCard(at: Int){
        cards.remove(at: at)
    }
    func shuffleCardIn(card:BaseCard){
        if cards.count>0{
            let i=Int.random(in: 0..<cards.count)
            cards.insert(card, at: i)
        }else{
            cards.append(card)
        }
        
    }
}
