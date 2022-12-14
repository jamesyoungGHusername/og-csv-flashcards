//
//  QuestionDisplayViewController.swift
//  quiztake2
//
//  Created by James Young on 10/25/21.
//

import UIKit

class QuestionDisplayViewController: UIViewController, UITextFieldDelegate{
    private var card:BaseCard=BaseCard.init()
    var delegate:QuestionDisplayViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRef.backgroundColor=bckgrndClr
        scrollViewRef.backgroundColor=bckgrndClr
        internalViewRef.backgroundColor=bckgrndClr
        questionTextRef.backgroundColor=bckgrndClr
        questionTextRef.text=card.getQuestion()
        self.answerTextRef.delegate=self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        self .questionTextRef.layoutManager.allowsNonContiguousLayout = false
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        //answerTextRef.becomeFirstResponder()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
   
    }
    func setCard(c:BaseCard){
        card=c
    }
    
    @IBOutlet weak var bottomConstraintForKeyboard: NSLayoutConstraint!
    @IBOutlet weak var questionTextHeightConstraint: NSLayoutConstraint!
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let botSafeAreaConst=viewRef.safeAreaInsets.bottom
        print(botSafeAreaConst)
        scrollViewRef.contentInset.bottom = keyboardSize - botSafeAreaConst
        questionTextRef.contentInset.top=keyboardSize - botSafeAreaConst
        questionTextRef.verticalScrollIndicatorInsets.top=keyboardSize - botSafeAreaConst
        scrollViewRef.contentInset.top=keyboardSize * -1 + botSafeAreaConst
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        print("keyboard will hide called")
        questionTextRef.verticalScrollIndicatorInsets.top=0
        scrollViewRef.contentInset.bottom = 0
        questionTextRef.contentInset.top=0
        scrollViewRef.contentInset.top=0
       
      
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //delegate?.correctAnswerEntered(answerTextRef.text!==card.getAnswer())
        //textField code

        textField.resignFirstResponder()  //if desired
        delegate?.correctAnswerEntered(answerTextRef.text?.trimmingCharacters(in: .whitespaces)==card.getAnswer())
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        //print(answerTextRef.text!)
        //print(card.getAnswer())
        delegate?.correctAnswerEntered(answerTextRef.text?.trimmingCharacters(in: .whitespaces)==card.getAnswer())
    }
    @IBOutlet weak var questionTextRef: UITextView!
    @IBOutlet var viewRef: UIView!
    @IBOutlet weak var scrollViewRef: UIScrollView!
    @IBOutlet weak var internalViewRef: UIView!
    
    @IBOutlet weak var answerTextRef: UITextField!
    @IBAction func answerText(_ sender: Any) {
        
    }
    private var bckgrndClr:UIColor=UIColor.systemBackground
    func setBckgrndClr(newColor:UIColor){
        bckgrndClr=newColor
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
