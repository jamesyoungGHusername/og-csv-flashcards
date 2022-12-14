//
//  QuizPVC.swift
//  quiztake2
//
//  Created by James Young on 10/25/21.
//
/*
 TO DO
   
 */
import UIKit

class QuizPVC: UIPageViewController, UIPageViewControllerDataSource, AnswerDisplayViewControllerDelegate,QuestionDisplayViewControllerDelegate {
    
    override func viewWillDisappear(_ animated: Bool) {
        let questionPage=qAndA[0] as! QuestionDisplayViewController
        questionPage.answerTextRef.isHidden=false
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = qAndA.firstIndex(of:viewController) else {
                    return nil
                }
                
                let previousIndex = viewControllerIndex - 1
                
                guard previousIndex >= 0 else {
                    return nil
                }
                
                guard qAndA.count > previousIndex else {
                    return nil
                }
                
                return qAndA[previousIndex]
    }
    fileprivate func indexOfViewController(_ viewController: UIViewController) -> Int {
        return self.viewControllers?.firstIndex(of: viewController) ?? NSNotFound
        }
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if self.viewControllers?.count == 0 || index >= self.viewControllers!.count {
                return nil
            }
        return viewControllers?[index]
        }
    func nextCardTapped(_ b:Bool){
        readyScreenVC.advance(answeredCorrectly: b)
    }
    
    private var correct:Bool=false
    func correctAnswerEntered(_ b: Bool) {
        correct=b
        prepareAnswerPage()
        
    }
    func prepareAnswerPage(){
        let questionPage=qAndA[0] as! QuestionDisplayViewController
        let answerPage=qAndA[1] as! AnswerDisplayViewController
        if ready{
            answerPage.setCorrect(b: correct,givenAnswer: questionPage.answerTextRef.text!)
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      
        guard let viewControllerIndex = qAndA.firstIndex(of: viewController) else {
                    return nil
                }
                
                let nextIndex = viewControllerIndex + 1
                let orderedViewControllersCount = qAndA.count

                guard orderedViewControllersCount != nextIndex else {
                    return nil
                }
                
                guard orderedViewControllersCount > nextIndex else {
                    return nil
                }
                
                return qAndA[nextIndex]
    }
    private var readyScreenVC=QuizReadyScreenVC()
    private var currentCard:BaseCard=BaseCard.init()
    private var enteredAnswer:String=""
    private var ready=false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.view.bringSubviewToFront(pageControl)
        // Do any additional setup after loading the view.
    }
    
  
    

     
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear called")
        ready=true
        self.view.backgroundColor=backgroundColor
        dataSource=self
        let questionPage=qAndA[0] as! QuestionDisplayViewController
        let answerPage=qAndA[1] as! AnswerDisplayViewController
        questionPage.setCard(c: currentCard)
        questionPage.delegate=self
        questionPage.view.backgroundColor=backgroundColor
        answerPage.setCard(newCard: currentCard)
        answerPage.setReadyScreen(vc:readyScreenVC)
        answerPage.delegate=self
        answerPage.view.backgroundColor=backgroundColor
        if let firstViewController = qAndA.first {
                setViewControllers([firstViewController],
                    direction: .forward,
                    animated: false,
                    completion: nil)
            }
        //configurePageControl()
        //self.view.bringSubviewToFront(pageControl)
    }
    lazy var qAndA:[UIViewController]={
        return[self.newQuestionPage(),self.newAnswerPage()]}()
    func setup(vc:QuizReadyScreenVC){
        readyScreenVC=vc
    }
    func newQuestionPage()->QuestionDisplayViewController{
        let vc=(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "questionVC")) as! QuestionDisplayViewController
       
        return vc
    }
   
    func newAnswerPage()->AnswerDisplayViewController{
        return UIStoryboard(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "answerVC") as! AnswerDisplayViewController
    }
    var backgroundColor=UIColor.systemBackground
    func setup(c:BaseCard,color:UIColor,pVC:QuizReadyScreenVC){
        currentCard=c
        backgroundColor=color
        readyScreenVC=pVC
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.qAndA.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first else { fatalError("Unable to get the page controller's current view controller.") }
                
                return indexOfViewController(currentViewController)
    }
    func getCard()->BaseCard{
        return currentCard
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
protocol AnswerDisplayViewControllerDelegate{
    func nextCardTapped(_ b:Bool)
}
protocol QuestionDisplayViewControllerDelegate{
    func correctAnswerEntered(_ b:Bool)
   
}
