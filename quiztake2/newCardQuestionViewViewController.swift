//
//  newCardQuestionViewViewController.swift
//  quiztake2
//
//  Created by James Young on 10/20/21.
//

import UIKit

class NewCardQuestionView: UIViewController,UITextFieldDelegate {

    var pageView:CardPageViewController?
    @IBOutlet var questionTextRef: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionTextRef.delegate = self
        questionTextRef.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    private var questionText:String=""
    var entered=false
    @IBAction func questionEntered(_ sender: Any) {
        questionText=questionTextRef.text ?? ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        entered=true
        return true
        
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
