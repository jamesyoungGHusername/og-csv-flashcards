//
//  QuizReadyScreenVC.swift
//  quiztake2
//
//  Created by James Young on 10/26/21.
//
/*
 TO DO: code/fix behavior upon completing all cards in a deck.
 */

import UIKit

class QuizReadyScreenVC: UIViewController,UIPageViewControllerDelegate {
    
    @IBOutlet var readyScreenViewRef: UIView!
    private var cardVCS:[QuizPVC]=[]
    private var deck:Deck=Deck()
    private var begun:Bool=false
    private var completed=0
    @IBOutlet weak var titleTextRef: UILabel!
    @IBOutlet weak var startResumeFinishBRef: UIButton!
    @IBOutlet weak var backButtonRef: UIButton!
    @IBOutlet weak var progressTextRef: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextRef.text=deck.getName()
        startResumeFinishBRef.setTitle("Start", for: .normal)
        progressTextRef.text="\(completed)/\(deck.getCards().count) cards completed"
        //progressTextRef.text="By: "+NSFullUserName()
        self.view.backgroundColor=deck.getColor()
        addButtonShadow(b: startResumeFinishBRef)
        addButtonShadow(b: backButtonRef)
        
    }

    func setup(deck:Deck){
        var count=0
        for card in deck.getCards(){
            let qpvc=storyboard?.instantiateViewController(withIdentifier: "cardVC") as! QuizPVC
            qpvc.setup(c: card, color: deck.getColor(), pVC: self)
            qpvc.navigationItem.title="Card \(count+1)"
            qpvc.navigationItem.backButtonTitle="Back"
           
            qpvc.delegate=self
            cardVCS.append(qpvc)
            count+=1
        }
        
        self.deck=deck
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                  didFinishAnimating finished: Bool,
             previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool){
        let quizPageViewController=pageViewController as! QuizPVC
        print("did finish animating called")
        let questionPage=quizPageViewController.qAndA[0] as! QuestionDisplayViewController
        questionPage.answerTextRef.isHidden=true
        //quizPageViewController.pageControl.currentPage+=1
    }
    
    func advance(answeredCorrectly:Bool){
        let transition = CATransition()
            transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
     
        if answeredCorrectly && cardVCS.count>1{
            print("Correct answer, displaying next card")
            self.navigationController?.pushViewController(cardVCS[1], animated: true)
            removeLastCardFromStack()
            cardVCS.remove(at: 0)
            completed+=1
            progressTextRef.text="\(completed)/\(deck.getCards().count) cards completed"
        }else if cardVCS.count>1{
            print("Incorrect answer, shuffling card into deck and displaying next card")
            self.navigationController?.pushViewController(cardVCS[1], animated: false)
            let x=cardVCS[0]
            cardVCS.remove(at: 0)
            shuffleQVCIn(vc: x)
            removeLastCardFromStack()
        }else if !answeredCorrectly{
            let vc=storyboard?.instantiateViewController(withIdentifier: "cardVC") as! QuizPVC
            vc.setup(c: cardVCS[0].getCard(), color: deck.getColor(), pVC: self)
            vc.delegate=self
            vc.navigationItem.title="Try again"
            cardVCS.append(vc)
            self.navigationController?.pushViewController(cardVCS[1], animated: false)
            removeLastCardFromStack()
            cardVCS.remove(at: 0)
        }else{
            completed+=1
            progressTextRef.text="\(completed)/\(deck.getCards().count) cards completed"
            startResumeFinishBRef.isHidden=true
            navigationController?.popToViewController(self, animated: true)
        }
        
    }
    func removeLastCardFromStack(){
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        navigationArray.remove(at: navigationArray.count - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray
    }
    func update(){
        titleTextRef.text=deck.getName()
        progressTextRef.text="\(deck.getCards().count-cardVCS.count)/\(deck.getCards().count) cards completed"
        updateButtonText()
    }
    @IBAction func srfPressed(_ sender: Any) {
        begun=true
        if cardVCS.count>0{
            self.navigationController?.pushViewController(cardVCS[0], animated: true)
        }
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func unwindToReadyScreen(_ unwindSegue: UIStoryboardSegue) {
        print("unwind to ready screen called")
        let sourceViewController = unwindSegue.source

    }
    func shuffleQVCIn(vc:QuizPVC){
        cardVCS.insert(vc, at: Int.random(in: 1...cardVCS.count))

    }
    func updateButtonText(){
        if(cardVCS.isEmpty){
            
        }
    }
    func addButtonShadow(b:UIButton){
        b.layer.shadowColor=UIColor.opaqueSeparator.cgColor
        b.layer.shadowOffset=CGSize(width: 0.5, height: 0.5)
        b.layer.shadowOpacity=1
        b.layer.shadowRadius=0.0
        b.layer.masksToBounds=false
    }
}

