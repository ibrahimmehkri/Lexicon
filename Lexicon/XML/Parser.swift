//
//  Parser.swift
//  Lexicon
//
//  Created by Ibrahim Mehkri  on 2018-05-06.
//  Copyright © 2018 BigNerdRanch. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum WordResult{
    case success([Word])
    case failure(Error)
}

class Parser: NSObject, XMLParserDelegate
{
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LexiconModel")
        container.loadPersistentStores(completionHandler: {(description, error) in
            if let error = error
            {
                print("Error setting up Core Data (\(error))")
            }
        })
        return container
    }()
    
    var currentElement = ""
    var form = ""
    var pronunciation = ""
    var inflection = ""
    var pos = ""
    var definition = ""
    var usage = ""
    var examples = ""
    var idioms = ""
    var definitionComm = ""
    var compound = ""
    var valency = ""
    var comment = ""
    
    func parseXMLFile()
    {
        let path = Bundle.main.url(forResource: "LEXIN", withExtension: "xml")
        let parser = XMLParser.init(contentsOf: path!)
        parser?.delegate = self
        parser?.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "lemma-entry"{
            form = ""
            pronunciation = ""
            inflection = ""
            pos = ""
            definition = ""
            usage = ""
            examples = ""
            idioms = ""
            definitionComm = ""
            compound = ""
            valency = ""
            comment = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "form":    form += string
        case "pronunciation": pronunciation += string
        case "inflection":  inflection += string
        case "pos": pos += string
        case "definition":  definition += string
        case "usage":   usage += string
        case "valency": valency += string
        case "example": examples += ",\(string)"
        case "compound":    compound += string
        case "idiom":   idioms += ",\(string)"
        case "comment": comment += ",\(string)"
        case "definition_comm": definitionComm += string
        default:    break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "lemma-entry" {
            self.writeOnContext()
        }
    }
    
    func writeOnContext(){
        let context = persistentContainer.viewContext
        var word:Word!
        context.performAndWait {
            word = Word(context: context)
            word.form = form
            word.pronunciation = pronunciation
            word.inflection = inflection
            word.definition = definition
            word.comment = comment
            word.compound = compound
            word.definitionComm = definitionComm
            word.examples = examples
            word.idioms = idioms
            word.pos = pos
            word.usage = usage
            word.valency = valency
        }
    }
    
    func save(){
        if persistentContainer.viewContext.hasChanges{
            do{
                try self.persistentContainer.viewContext.save()
            } catch let error {
                print("\(error)")
            }
        }
    }
    
    func fetchWordList(completion: @escaping (WordResult)->Void){
        let request: NSFetchRequest<Word> = Word.fetchRequest()
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do{
                let allWords = try viewContext.fetch(request)
                completion(.success(allWords))
            }catch let error {
                completion(.failure(error))
            }
        }
    }
}
