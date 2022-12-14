//
//  BaseCard.swift
//  quiztake2
//
//  Created by James Young on 10/10/21.
//

import Foundation

class BaseCard{
    //basic card class, all other cards inherit from this.
    //contains question and answer, whether it's been completed, and whether it's face up or not.
    var question=""
    var answer=""
    var attempts=0
    var completed=false;
    var faceUp=true;

    convenience init(){
        self.init(q:"",a:"")
    }
    convenience init(card:BaseCard) {
        self.init(q:card.getQuestion(),a:card.getAnswer())
    }
    init(q:String,a:String){
        question=q
        answer=a
    }

    func hasAllText()->Bool{
        return (getQuestion() != "" && getAnswer() != "")
    }
    func isCorrect(_ s:String)->Bool{
        return s==answer
    }
    func setQuestion(newQuestion: String){
        question=newQuestion
    }
    func getQuestion() -> String{
        return question
    }
    func getAnswer() ->String{
        return answer
    }
    func setAnswer(newAnswer:String){
        answer=newAnswer
    }
    func isCompleted() -> Bool{
        return completed
    }
    func setCompleted(c:Bool){
        completed=c
    }
    func isFaceUp()->Bool{
        return faceUp;
    }
    func setFaceUp(state:Bool){
        faceUp=state
    }
    func flip(){
        faceUp = !faceUp;
    }
    func getAttempts() -> Int{
        return attempts
    }
    func useAttempt(){
        attempts+=1
    }
    func setAttempts(i:Int){
        attempts=i
    }
    
}
