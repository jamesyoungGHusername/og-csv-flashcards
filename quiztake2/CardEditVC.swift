//
//  CardEditVC.swift
//  quiztake2
//
//  Created by James Young on 10/21/21.
//

import UIKit
/*
 TODO
 */
class CardEditVC: UIViewController,UITextViewDelegate {
    private var card:BaseCard=BaseCard.init(q: "Empty", a: "Empty")
    private var editingExisting=false
    private var existingCardIndex=0
    private var prevView:NewDeckViewController=NewDeckViewController.init()
    @IBOutlet weak var QuestionLabelRef: UILabel!
    @IBOutlet weak var AnswerLabelRef: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundColor()
        self.questionTextRef.delegate=self
        self.answerTextRef.delegate=self
        if editingExisting{
            questionTextRef.text=card.getQuestion()
            answerTextRef.text=card.getAnswer()
        }
        questionTextRef.returnKeyType=UIReturnKeyType.next
        answerTextRef.returnKeyType=UIReturnKeyType.done
        questionTextRef.becomeFirstResponder()
        QuestionLabelRef.textColor=UIColor.systemGray4
        AnswerLabelRef.textColor=UIColor.systemGray4
        addLabelShadow(l: QuestionLabelRef)
        addLabelShadow(l: AnswerLabelRef)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            nextFirstResponder()
        }
        return true
    }
    func nextFirstResponder(){
        if questionTextRef.isFirstResponder{
            questionTextRef.resignFirstResponder()
            answerTextRef.becomeFirstResponder()
        }else if answerTextRef.isFirstResponder{
            answerTextRef.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setQuestion(s:String){
        card.setQuestion(newQuestion: s)
        questionTextRef.text=card.getQuestion()
    }
    func setCard(newCard:BaseCard,i:Int){
        card=BaseCard.init(card: newCard)
        editingExisting=true
        existingCardIndex=i
        
    }
    func setup(vc:NewDeckViewController,c:BaseCard,i:Int){
        prevView=vc
        card=c
        existingCardIndex=i
        editingExisting=true
    }
    func setup(vc:NewDeckViewController){
        prevView=vc
    }
    func getCard()->BaseCard{
            return card
    }
    /*@objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollViewRef.contentInset
        contentInset.bottom = keyboardFrame.size.height - 20
        scrollViewRef.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollViewRef.contentInset = contentInset
    }
    */
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height

        questionTextRef.contentInset.bottom = keyboardSize
        answerTextRef.contentInset.bottom = keyboardSize
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        questionTextRef.contentInset.bottom = 0
        answerTextRef.contentInset.bottom = 0
    }
    @IBOutlet weak var subViewRef: UIView!
    @IBOutlet weak var questionTextRef: UITextView!
    @IBOutlet weak var answerTextRef: UITextView!
    @IBOutlet weak var scrollViewRef: UIScrollView!
    
    func setBackgroundColor(c:UIColor){
        subViewRef.backgroundColor=c
    }
    func setBackgroundColor(){
        subViewRef.backgroundColor=prevView.newDeck.getColor()
        if(subViewRef.backgroundColor==UIColor.systemBackground){
            subViewRef.backgroundColor=UIColor.systemGray4
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
   
            card.setQuestion(newQuestion:questionTextRef.text ?? "Empty")

            card.setAnswer(newAnswer: answerTextRef.text ?? "Empty")

        if editingExisting{
            prevView.newDeck.getCards()[existingCardIndex].setQuestion(newQuestion: card.getQuestion())
            
            prevView.newDeck.getCards()[existingCardIndex].setAnswer(newAnswer: card.getAnswer())
        }else if !(questionTextRef.text == "") || !(answerTextRef.text == ""){
            prevView.newDeck.addCard(card: card)
        }
        prevView.tableView.reloadData()
        if !editingExisting{
            prevView.scrollToBottom()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    func addLabelShadow(l:UILabel){
        l.layer.shadowColor=UIColor.opaqueSeparator.cgColor
        l.layer.shadowOffset=CGSize(width: 0.5, height: 0.5)
        l.layer.shadowOpacity=1
        l.layer.shadowRadius=0.0
        l.layer.masksToBounds=false
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
