//
//  DeckListTableViewController.swift
//  quiztake2
//
//  Created by James Young on 10/16/21.
//
/*
 TO DO
    add "edit" button in top left which turns on an edit mode for existing decks, gives option to edit them or to delete them from memory.
 
 */

import UIKit

class DeckListTableViewController: UITableViewController{
    
    
    var dm=DeckManager.init()
    var deckID:Int=0
    var deckCategoryIndex:Int=0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.opaqueSeparator.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        dm.loadDecks()
        dm.calculateCategories()
        //let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        //self.tableView.addGestureRecognizer(longPress)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.tableFooterView?.isHidden = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding=0
        } else {
            // Fallback on earlier versions
        }
        
        
        tableView.reloadData()
    }
    // MARK: - Table view data source
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()

    }
    @IBAction func saved(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
        
    }
    /*@objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
            }
        }
    }
     */
    override func tableView(_ tableView: UITableView,
                            contextMenuConfigurationForRowAt indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
                suggestedActions in
            let editAction = UIAction(title: NSLocalizedString("Edit Deck", comment: ""),
                                      image: UIImage(systemName: "square.and.pencil")
                                     ) { action in
                self.performEditSegue(ip:indexPath)
            }
            let shareAction = UIAction(title: NSLocalizedString("Share", comment: ""),
                                       image: UIImage(systemName: "square.and.arrow.up")
                                      ) { action in
                 self.performShareAction(ip:indexPath)
             }
            let deleteAction = UIAction(title: NSLocalizedString("Delete Deck", comment: ""),
                                       image: UIImage(systemName: "trash"),
                                       attributes: .destructive) { action in
                self.performDelete(ip:indexPath)
            }
                
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        })
    }
    func performShareAction(ip:IndexPath){
        let fileManager = FileManager.default
        let path = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first
        let fileURL = path?.appendingPathComponent(getDeckAtIndexPath(ip: ip).getLocation())
        let items:[Any]=[fileURL]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popoverController = ac.popoverPresentationController {
                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }

        present(ac, animated: true)
    }
  
    func performDelete(ip:IndexPath){
        dm.removeDeck(deck: getDeckAtIndexPath(ip: ip))
        tableViewRef.reloadData()
    }
    func performEditSegue(ip:IndexPath){
        deckToBeEdited=getDeckAtIndexPath(ip: ip)
        performSegue(withIdentifier: "editDeckSegue", sender: nil)
    
    }
    var deckToBeEdited:Deck=Deck.init()
    func getDeckAtIndexPath(ip:IndexPath)->Deck{
        return dm.getDecksInCategory(categoryIndex: ip.section)[ip.row]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dm.getCategories().count
    }
    override func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat{
        return .leastNonzeroMagnitude
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dm.getDecksInCategory(categoryIndex: section).count
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.systemGray5
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    
        cell.textLabel?.text = dm.getDecksInCategory(categoryIndex: indexPath.section)[indexPath.row].getName()
        print(String(describing: dm.getDecksInCategory(categoryIndex: indexPath.section)[indexPath.row].getColor()))
        cell.backgroundColor=dm.getDecksInCategory(categoryIndex: indexPath.section)[indexPath.row].getColor()
        let l=cell.textLabel
        l?.layer.shadowColor=UIColor.opaqueSeparator.cgColor
        l?.layer.shadowOffset=CGSize(width: 0.5, height: 0.5)
        l?.layer.shadowOpacity=1
        l?.layer.shadowRadius=0.0
        l?.layer.masksToBounds=false
        return cell
    }
    
    
    @IBOutlet var tableViewRef: UITableView!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        deckID=indexPath.row
        deckCategoryIndex=indexPath.section
        tableViewRef.deselectRow(at: indexPath, animated: true)

        if dm.getDecksInCategory(categoryIndex: deckCategoryIndex)[deckID].setComplete(){
            print("complete")
            performSegue(withIdentifier: "deckTapped", sender: nil)
        }else {
            print("incomplete")
            deckToBeEdited=getDeckAtIndexPath(ip: indexPath)
            performSegue(withIdentifier: "editDeckSegue", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deckTapped"{
            let destination=segue.destination as! QuizReadyScreenVC
            destination.setup(deck: dm.getDecksInCategory(categoryIndex: deckCategoryIndex)[deckID])
           
        }
        if segue.identifier == "editDeckSegue"{
            let destination=segue.destination as! NewDeckViewController
            destination.setup(deck: deckToBeEdited, deckManager: dm, prevVC: self)
        }
       
    }
     
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < dm.getCategories().count {
            return dm.getCategories()[section]
            }


        return nil
    }

}
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


