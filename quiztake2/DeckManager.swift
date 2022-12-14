//
//  DeckManager.swift
//  quiztake2
//
//  Created by James Young on 10/16/21.
//
/*
 TO DO

 
 */
import Foundation
import UIKit
class DeckManager{
    var decks:[Deck] = []
    var categories:[String]=[]
    var testString=""
    init(){
    }
    func calculateCategories(){
        categories=[]
        for deck in decks {
            if !categories.contains(deck.getCategory()){
                categories.append(deck.getCategory())
            }
        }
    }
    func getDecksInCategory(category:String)->[Deck]{
        var subList:[Deck]=[]
        for deck in decks {
            if deck.getCategory()==category{
                subList.append(deck)
            }
        }
        return subList
    }
    func getDecksInCategory(categoryIndex:Int)->[Deck]{
        var subList:[Deck]=[]
        for deck in decks {
            if deck.getCategory()==categories[categoryIndex]{
                subList.append(deck)
            }
        }
        return subList
    }
    func getCategories()->[String]{
        /**
         gets list of deck categories in order that they were saved.
         */
        return categories
    }
    func getDeck(i:Int)throws ->Deck{
            return decks[i]
    }
    func getDecks()->[Deck]{
        return decks
    }

    func loadDecks(){
        decks=[]
        //print("loadDecks called")
        do{
            let deckExtensions:[URL]=try getDeckURLs()
            for ext in deckExtensions {
                print("Path component: "+ext.lastPathComponent)
                loadDeck(ext: ext)
            }
        }catch{
            testString="error in getDeckURLs"
        }
    }
    func loadDeckFromImport(ext:URL,firstRow:Bool){
        do {
                try processImport(at: ext,firstRow: firstRow)
            } catch {
                print("error processing: \(ext): \(error)")
            }
    }
    func loadDeck(ext:URL){
        do {
                try processFile(at: ext)
            } catch {
                print("error processing: \(ext): \(error)")
            }
    }
    func processFile(at url:URL)throws{
        let s = try String(contentsOf: url)
        //print(s)
        try process(string: s,lastComp: url.lastPathComponent)
    }
    func processImport(at url:URL,firstRow:Bool) throws{
        let s = try String(contentsOf: url)
        //print(s)
        try decodeFromImport(string: s,lastComp: url.lastPathComponent,firstRow:firstRow)
    }
    func decodeFromImport(string:String,lastComp:String,firstRow:Bool) throws{
        let lines=cleanTable(table: string.split(whereSeparator: \.isNewline))
        print(lines)
        let loadedDeck:Deck=Deck()
        let color:UIColor=UIColor.systemBackground
        loadedDeck.setColor(color)
        loadedDeck.setName(name: lastComp)
        loadedDeck.setCategory(category: "Imported")
        for i in 0..<lines.count {
            let items=cleanLine(line:lines[i].split(separator: "\t", omittingEmptySubsequences: false),startIndex: getStartIndex(table: lines))
            print (items)
            if i==0 && items.count==6 && firstRow && items[2] != ""{
                loadedDeck.setName(name: String(items[0]))
                loadedDeck.setCategory(category: String(items[1]))
                loadedDeck.setColorFromRGB(r: CGFloat(truncating: NumberFormatter().number(from: String(items[2]))!), g: CGFloat(NumberFormatter().number(from: String(items[3]))!), b: CGFloat(NumberFormatter().number(from: String(items[4]))!), a: CGFloat(NumberFormatter().number(from: String(items[5]))!))
                var red:CGFloat=0
                var green:CGFloat=0
                var blue:CGFloat=0
                var alpha:CGFloat=0
                loadedDeck.getColor().getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                if(red==1 && green==1 && blue==1 && alpha==1){
                    loadedDeck.setColor(UIColor.systemBackground)
                }
            }else if i==0 && firstRow && items.count>1{
                loadedDeck.setName(name: String(items[0]))
                loadedDeck.setCategory(category: String(items[1]))
            }else if items.count>1 && i>0{
                loadedDeck.addCard(card: BaseCard(q: String(items[0]).trimmingCharacters(in: .whitespaces), a: String(items[1]).trimmingCharacters(in: .whitespaces)))
            }
        }
        loadedDeck.setLocation(l: lastComp)
        decks.append(loadedDeck)
    }
    func process(string:String,lastComp:String) throws{
        let lines=cleanNonImportedTable(table: string.split(whereSeparator: \.isNewline))
        
        let loadedDeck:Deck=Deck()

        for i in 0..<lines.count {

            let items=cleanNonImportedLine(s:lines[i],startIndex: getStartIndex(table: lines))
            if i==0{
                
                loadedDeck.setName(name: String(items[0]))

                loadedDeck.setCategory(category: String(items[1]))
               
                if items.count==6{
                    loadedDeck.setColorFromRGB(r: CGFloat(truncating: NumberFormatter().number(from: String(items[2]))!), g: CGFloat(NumberFormatter().number(from: String(items[3]))!), b: CGFloat(NumberFormatter().number(from: String(items[4]))!), a: CGFloat(NumberFormatter().number(from: String(items[5]))!))
                    var red:CGFloat=0
                    var green:CGFloat=0
                    var blue:CGFloat=0
                    var alpha:CGFloat=0
                    loadedDeck.getColor().getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                    if(red==1 && green==1 && blue==1 && alpha==1){
                        loadedDeck.setColor(UIColor.systemBackground)
                    }
                }else{
                    let color:UIColor=UIColor.systemBackground
                    loadedDeck.setColor(color)
                }
                
                
            }else{
                if items.count>1{
                    loadedDeck.addCard(card: BaseCard(q: String(items[0]).trimmingCharacters(in: .whitespaces), a: String(items[1]).trimmingCharacters(in: .whitespaces)))
                }
            }
        }
        loadedDeck.setLocation(l: lastComp)
        decks.append(loadedDeck)
    }
    func cleanNonImportedLine(s:String,startIndex:Int)->[String]{
        var line=s.split(separator: "\t", omittingEmptySubsequences: false)
        var str:[String]=[]
        print(line)
        if (line.count==1){
            line=[]
            print("old format detected")
            var inQuotes=false
            var p=Array(s)
            for c in 0..<p.count{
                if p[c]=="\""{
                    inQuotes = !inQuotes
                }
                if p[c]=="," && !inQuotes{
                    p[c]="\t"
                }
            }
            for part in String(p).split(separator: "\t", omittingEmptySubsequences: false){
                str.append(String(part))
            }
            print(str)
            return str
        }
        for part in line{
            str.append(String(part))
        }
        print(str)
        return str
    }
    func cleanNonImportedTable(table:[String.SubSequence])->[String]{
        var placeholder:[String]=[]
        var clean:[String]=[]
        for l in table{
            var empty=true
            for c in l{
                if c != "\t"{
                    empty=false
                }
            }
            if !empty{
                placeholder.append(String(l))
            }
        }
        
        return placeholder
    }
    func cleanTable(table:[String.SubSequence])->[String]{
        print ("cleaning table ")
        print(table)
        var placeholder:[String]=[]
        var clean:[String]=[]
        for l in table{
            var empty=true
            for c in l{
                if c != ","{
                    empty=false
                }
            }
            if !empty{
                placeholder.append(String(l))
            }
        }
        for i in 0..<placeholder.count {
            var inQuotes=false
            var p=Array(placeholder[i])
            for c in 0..<p.count{
                if p[c]=="\""{
                    inQuotes = !inQuotes
                }
                if p[c]=="," && !inQuotes{
                    p[c]="\t"
                }
            }
            clean.append(String(p))
        }
        return clean
    }
    
    func cleanLine(line:[String.SubSequence],startIndex:Int)->[String]{
        print("cleaning line ")
        print(line)
        var clean:[String]=[]
        for i in line{
            clean.append(String(i))
        }
        for _ in 0..<startIndex{
            clean.removeFirst()
        }
        return clean
    }
    func getStartIndex(table:[String])->Int{
        var startIndex=0
        for i in 0..<table.count{
            let items=table[i].split(separator: "\t", omittingEmptySubsequences: false)
            print("Getting start index for")
            print(items)
            var rowStart=0
            for j in 0..<items.count{
                print(String(items[j]))
                if String(items[j]) != ""{
                    break
                }else{
                    print("Blank entry at ")
                    print(rowStart)
                    rowStart+=1
                    if i==0{
                        startIndex=rowStart
                    }
                    if rowStart>startIndex{
                        startIndex=rowStart
                    }
                }
            }
        }
        
        return startIndex
    }
    func getDeckURLs() throws -> [URL]{
        let fileManager = FileManager.default
        var csvFiles:[URL]=[]
        do{
            let path = fileManager.urls(for: .documentDirectory, in: .allDomainsMask).first
            let directoryContents = try fileManager.contentsOfDirectory(at: path!, includingPropertiesForKeys: nil)
                //print(directoryContents)
            csvFiles = directoryContents.filter{ $0.pathExtension == "csv" }
            return csvFiles
            
        }catch{
            testString="Error reading decks"
            return csvFiles
        }
        
    }
    
    func saveDeck(deck: Deck,count:Int){
       
        testString="saveDeckCalled"
        var red:CGFloat=0
        var green:CGFloat=0
        var blue:CGFloat=0
        var alpha:CGFloat=0
        deck.getColor().getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        var csvString=""
        let fileManager = FileManager.default
        if !nameExists(name:deck.getName()+"(\(count))"){
                do {
                        deck.setName(name: deck.getName()+"(\(count))")
                        csvString.append(deck.getName()+"\t"+deck.getCategory()+"\t\(red)\t\(green)\t\(blue)\t\(alpha)\n")
                        for card in deck.getCards(){
                            csvString.append(card.getQuestion()+"\t"+card.getAnswer()+"\n");
                        }
                        let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                        let fileURL = path.appendingPathComponent(deck.getName()+"Flashcards.csv")
                        try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                    } catch {
                        testString="error creating file"
                    }
        }else{
            saveDeck(deck: deck, count: count+1)
        }
    }
    
        func saveDeck(deck: Deck){
            testString="saveDeckCalled"
            var red:CGFloat=0
            var green:CGFloat=0
            var blue:CGFloat=0
            var alpha:CGFloat=0
            deck.getColor().getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            var csvString=deck.getName()+"\t"+deck.getCategory()+"\t\(red)\t\(green)\t\(blue)\t\(alpha)\n"
            for card in deck.getCards(){
                csvString.append(card.getQuestion()+"\t"+card.getAnswer()+"\n");
            }
            let fileManager = FileManager.default
            if !nameExists(name: deck.getName()){
                print("name doesnt exist")
                    do {
                            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                            let fileURL = path.appendingPathComponent(deck.getName()+"Flashcards.csv")
                            testString=fileURL.path
                            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                        } catch {
                            testString="error creating file"
                        }
            }else{
                saveDeck(deck: deck,count:(1))
            }
        
    }
   
    func saveDeckWithOverwrite(deck:Deck,location:String){
        removeDeck(deck: deck)
        saveDeck(deck: deck)
    }
    func nameExists(newDeck:Deck)->Bool{
        var b:Bool=false
        for deck in decks {
            if deck.getName()==newDeck.getName(){
                
                print("Name to check: "+newDeck.getName())
                print("Checking against: "+deck.getName())
                b=true
            }
        }
        return b
    }
    func nameExists(name:String)->Bool{
        var existingNames:[String]=[]
        do{
            for f in try getDeckURLs(){
                existingNames.append(f.lastPathComponent)
            }
        }catch{
            print("error checking DeckNames")
        }
        if existingNames.contains((name+"Flashcards.csv")){
            return true
        }else{
            return false
        }
    }
    func categoryExists(c:String)->Bool{
        //doesnt work sometimes for some reason.
        return getCategories().contains(c)
    }
    func removeDeck(deck:Deck){
        decks.remove(at: decks.firstIndex(where: {$0===deck})!)
        calculateCategories()
        deleteSavedDeck(at: deck.getLocation())
    }
    func saveDecks(){
        for deck in decks {
            saveDeckWithOverwrite(deck: deck,location:deck.getLocation())
        }
    }
    func deleteSavedDeck(at:String){
        print("In delete saved deck")
        do {
            let fileManager = FileManager.default
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent(at)
            try fileManager.removeItem(at: fileURL)
        }
        catch let error as NSError {
                print("An error took place: \(error)")
        }
    }
    func nameExistsInCategory(newDeck:Deck)->Bool{
        //doesnt work in some circumstances for some reason
        calculateCategories()
        if categoryExists(c: newDeck.getCategory()){
            var names:[String]=[]
            for i in getDecksInCategory(category: newDeck.getCategory()){
                names.append(i.getName())
            }
            return names.contains(newDeck.getName())
        }
        return false
    }


}
