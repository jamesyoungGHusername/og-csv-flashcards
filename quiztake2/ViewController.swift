//
//  ViewController.swift
//  quiztake2
//
//  Created by James Young on 10/10/21.
//
/*
 TO DO
 rework presentation style to incorporate page view, allow flip for instant feedback, but then shuffle incorrect cards back into deck to be repeated, remove completed cards from rotation
 
 */

import UIKit

class ViewController: UIViewController {
    var testDeck=Deck("Sample Deck","TEST CATEGORY 1", cardArray:[BaseCard(q:"what is 2+2?",a:"4"),BaseCard(q:"who's cool?",a:"you are"),BaseCard(q: "is coding fun?", a: "yes")])
    
    @IBOutlet weak var question: UILabel!
    
    

    
    
    @IBOutlet weak var navItemRef: UINavigationItem!
    @IBOutlet weak var qaFlipLabel: UILabel!
    @IBOutlet weak var prevButtonRef: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        updateCardView()
        
    }


    
    @IBOutlet weak var flipButtonRef: UIButton!
    func updateCardView(){
        
        drawNavBar()
        answerTextField.text=""
        drawQState()
        drawTitleState()
        drawNextButton()
        drawPrevButton()
        drawFlipButton()
        drawAnswerTextField()
        
        drawBackgroundState()
    }
    func drawNavBar(){
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = testDeck.getColor()
        navItemRef.standardAppearance = appearance;
        navItemRef.scrollEdgeAppearance = navItemRef.standardAppearance
        navItemRef.title=testDeck.getName()
    }
    func drawAnswerTextField(){
        if !testDeck.getCurrentCard().isFaceUp(){
            answerTextField.isHidden=true
        }else if testDeck.getCurrentCard().isCompleted(){
            answerTextField.isHidden=true
        }else{
            answerTextField.isHidden=false
        }
    }
    func drawFlipButton(){
        
        if !testDeck.getCurrentCard().isFaceUp(){
            flipButtonRef.isHidden=true
            
        }else{
           
            flipButtonRef.isHidden=false
            
        }
        
    }
    func drawNextButton(){
        
        if !testDeck.getCurrentCard().isFaceUp() && testDeck.hasNext(){
            
            nextButtonRef.isHidden=false
        }else{
            nextButtonRef.isHidden=true
        }
        
    }
    func drawPrevButton(){

        prevButtonRef.isHidden=false
    }
    func drawTitleState(){
        qaFlipLabel.textColor=UIColor.black
        qaFlipLabel.text="Question "+String(testDeck.getCurrentCardIndex()+1)+":"
        if !testDeck.getCurrentCard().isFaceUp() && testDeck.getCurrentCard().isCompleted(){
            qaFlipLabel.text="CORRECT"
        }else if !testDeck.getCurrentCard().isFaceUp(){
            qaFlipLabel.text="INCORRECT"
        }else if testDeck.getCurrentCard().getAttempts()>0{
            qaFlipLabel.textColor=UIColor.systemRed
            qaFlipLabel.text="TRY AGAIN"
        }
    }
    
    @IBOutlet weak var leftNavButtonRef: UIBarButtonItem!
    
    func drawBackgroundState(){

        self.view.backgroundColor=UIColor.systemGray4
        if testDeck.getCurrentCard().isCompleted(){
            self.view.backgroundColor=UIColor.systemGreen
        }else if !testDeck.getCurrentCard().isCompleted() && !testDeck.getCurrentCard().isFaceUp(){
            self.view.backgroundColor=UIColor.systemRed
        }

        
    }
    func drawQState(){
        if !testDeck.getCurrentCard().isFaceUp(){
            if testDeck.getCurrentCard().isCompleted(){
                question.text=testDeck.getCurrentCard().getAnswer()
            }else{
                question.text="Correct answer was: "+testDeck.getCurrentCard().getAnswer()
            }
        }else{
            question.text=testDeck.getCurrentCard().getQuestion()
        }
    }
    @IBOutlet weak var nextButtonRef: UIButton!
    
    @IBAction func prevTap(_ sender: Any) {
        testDeck.shuffleDeck()
        updateCardView()
    }
    @IBAction func nextTap(_ sender: Any) {
        if !nextButtonRef.isHidden {
            testDeck.nextCard()
            answerTextField.text=""
            answerTextField.isHidden=false
        }
        updateCardView()
    }
    @IBOutlet weak var answerTextField: UITextField!

    
    @IBAction func flipTap(_ sender: Any) {
        if !testDeck.getCurrentCard().isCompleted(){
            if  testDeck.getCurrentCard().isCorrect(answerTextField.text!) && testDeck.getCurrentCard().isFaceUp(){
                testDeck.getCurrentCard().setCompleted(c: true)
                testDeck.getCurrentCard().flip()
                nextButtonRef.isHidden=false
            }else if testDeck.getCurrentCard().getAttempts()>=2 && testDeck.getCurrentCard().isFaceUp(){
                testDeck.getCurrentCard().flip()
                nextButtonRef.isHidden=false
            }else{
                testDeck.getCurrentCard().useAttempt()
            }
        }
        updateCardView()

    }
    

}

