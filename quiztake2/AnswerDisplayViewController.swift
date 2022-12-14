//
//  AnswerDisplayViewController.swift
//  quiztake2
//
//  Created by James Young on 10/25/21.
//

import UIKit

class AnswerDisplayViewController: UIViewController {
    private var card:BaseCard=BaseCard.init()
    private var readyScreen=QuizReadyScreenVC()
    private var correct:Bool=false
    var delegate:AnswerDisplayViewControllerDelegate?
    private var ready=false
    override func viewDidLoad() {
        super.viewDidLoad()
        ready=true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func setCard(newCard:BaseCard){
        card=newCard
    }
    func getCard()->BaseCard{
        return card
    }
    @IBOutlet weak var answerTextRef: UITextView!
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        delegate?.nextCardTapped(correct)
    }
    
    func setReadyScreen(vc:QuizReadyScreenVC){
        readyScreen=vc
    }
    func setCorrect(b: Bool, givenAnswer:String){
        if ready{
            correct=b
            var msg:String=""
            if correct{
                msg.append("Correct\n\n")
            }else{
                msg.append("Incorrect\n\n")
            }
            msg.append("Your answer:\n\""+givenAnswer+"\"\n\n")
            msg.append("Correct answer:\n\""+card.getAnswer()+"\"")
            
            answerTextRef.text=msg
    
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
