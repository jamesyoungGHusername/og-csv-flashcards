//
//  NewDeckViewController.swift
//  quiztake2
//
//  Created by James Young on 10/17/21.
//
/*
 TO DO
    Code procedure for checking deck to execute upon exit of the screen. Change back button text dynamically to reflect this state (back) and then (save) once there's something to save.
        Update name and category when you hit enter.
 */
import UIKit

class NewDeckViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIColorPickerViewControllerDelegate, UITextFieldDelegate {
    var dm:DeckManager=DeckManager()
    var newDeck:Deck=Deck()
    var editingExisting:Bool=false
    var deckListView:DeckListTableViewController=DeckListTableViewController.init()
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var viewRef: UIView!
       //test does a comment change the version
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton=true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(NewDeckViewController.back(sender:)))
                self.navigationItem.leftBarButtonItem = newBackButton
        if !editingExisting{
            self.viewRef.backgroundColor=UIColor.systemGray6
        }else{
            titleTextRef.text=newDeck.getName()
            categoryTextRef.text=newDeck.getCategory()
            self.viewRef.backgroundColor=newDeck.getColor()
            navigationItem.title="Edit Deck"
        }
        
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.titleTextRef.delegate=self
        self.categoryTextRef.delegate=self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        addButtonShadow(b: addCardButtonRef)
        addButtonShadow(b: setColorButtonRef)
        addLabelShadow(l: titleLabelRef)
        addLabelShadow(l: categoryLabelRef)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var titleLabelRef: UILabel!
    
    @IBOutlet weak var categoryLabelRef: UILabel!
    func setup(deck:Deck,deckManager:DeckManager,prevVC:DeckListTableViewController){
        dm=deckManager
        newDeck=deck
        editingExisting=true
        deckListView=prevVC
        
    }
    @objc func back(sender: UIBarButtonItem) {
            
            if(newDeck.setComplete()){
                print("Complete")
            }else{
                print("Not complete")
            }
            newDeck.setName(name: titleTextRef.text!)
            newDeck.setCategory(category: categoryTextRef.text!)
            if newDeck.setComplete(){
                if editingExisting{
                    print("saving deck with overwrite")
                    dm.saveDeckWithOverwrite(deck: newDeck,location:newDeck.getLocation())
                }else{
                    print("saving deck")
                    dm.saveDeck(deck: newDeck)
                }
            }else {
                print("should show alert")
                let alert = UIAlertController(title: "Deck Incomplete", message: "Do you want to save your work?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    print("saving deck")
                    self.cleanDeck()
                    if(self.editingExisting){
                        self.dm.saveDeckWithOverwrite(deck: self.newDeck, location: self.newDeck.getLocation())
                    }else{
                        
                        self.dm.saveDeck(deck: self.newDeck)
                    }
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                    self.navigationController?.popViewController(animated: true)}))
                self.present(alert, animated: true)
            }
            _ = navigationController?.popViewController(animated: true)
        }
    func cleanDeck(){
        if newDeck.getName()==""{
            newDeck.setName(name: "[Unnamed]")
        }
        newDeck.setCategory(category: "[Incomplete]")
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if titleTextRef.isFirstResponder{
            textField.resignFirstResponder()
            newDeck.setName(name: titleTextRef.text!)
            categoryTextRef.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
            newDeck.setCategory(category: categoryTextRef.text!)
        }
        return true
    }
    @IBOutlet weak var addCardButtonRef: UIButton!
    @IBOutlet weak var setColorButtonRef: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.systemGray5
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newDeck.getCards().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
        cell.textLabel?.text=newDeck.getCards()[indexPath.row].getQuestion()
        if !newDeck.getCards()[indexPath.row].hasAllText(){
            cell.backgroundColor=UIColor.systemRed
            cell.textLabel?.text="[Incomplete] "+newDeck.getCards()[indexPath.row].getQuestion()
        }else{
            cell.backgroundColor=nil
        }
        return cell
    }
    func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                suggestedActions in
            let deleteAction = UIAction(title: NSLocalizedString("Delete Card", comment: ""),
                                       image: UIImage(systemName: "trash"),
                                       attributes: .destructive) { action in
                self.performDelete(index:indexPath)
            }
                
            return UIMenu(title: "", children: [deleteAction])
        })
    }
    func performDelete(index:IndexPath){
        newDeck.removeCardAt(index.row)
        tableView.reloadData()
    }
    var ip=IndexPath.init()
    func scrollToBottom(){
        if !newDeck.getCards().isEmpty{
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.newDeck.getCards().count-1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
        }
    }
    @IBAction func setColor(_ sender: Any) {
        let picker=UIColorPickerViewController()
        
        picker.selectedColor=self.view.backgroundColor!
        picker.delegate=self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var categoryTextRef: UITextField!
    @IBOutlet weak var titleTextRef: UITextField!
    @IBAction func saveTapped(_ sender: Any) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="editCardSegue"{
            let destination=segue.destination as? CardEditVC
            destination?.setup(vc: self, c: newDeck.getCards()[ip.row], i: ip.row)
        }else if segue.identifier=="addCardSegue"{
            let destination=segue.destination as? CardEditVC
            destination?.setup(vc: self)
        }else{
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ip=indexPath
        performSegue(withIdentifier: "editCardSegue", sender: nil)
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            self.view.backgroundColor = viewController.selectedColor
            newDeck.setColor(viewController.selectedColor)
        }
    
    @IBAction func addCardTapped(_ sender: Any) {
        performSegue(withIdentifier: "addCardSegue", sender: nil)
        //performSegue(withIdentifier: "addCardView", sender: nil)
    }
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            self.view.backgroundColor = viewController.selectedColor
    }
    
    func addButtonShadow(b:UIButton){
        b.layer.shadowColor=UIColor.opaqueSeparator.cgColor
        b.layer.shadowOffset=CGSize(width: 0.5, height: 0.5)
        b.layer.shadowOpacity=1
        b.layer.shadowRadius=0.0
        b.layer.masksToBounds=false
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
