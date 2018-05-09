//
//  ViewController.swift
//  Lexicon
//
//  Created by Ibrahim Mehkri  on 2018-04-16.
//  Copyright © 2018 BigNerdRanch. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ViewController: UIViewController
{
    
    var wordList = [Word]()
    var filteredList = [Word]()
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var parser: Parser!
    
    @IBAction func handleSignOut(_ sender: UIBarButtonItem)
    {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error {
            print(error.localizedDescription)
        }
        
           }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Words"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.updateDataSource()
    }
    
    func updateDataSource()
    {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.parser.fetchWordList(completion: {
            (WordResult) in
            switch WordResult{
            case let .success(allwords):
                let sortedWords = allwords.sorted(by: {$0.form! < $1.form!})
                self.wordList = sortedWords
                self.tableView.reloadData()
            case let .failure(error):
                print("error: \(error.localizedDescription)")
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetail"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let word: Word
                if isFiltering() {
                    word = filteredList[indexPath.row]
                } else {
                    word = wordList[indexPath.row]
                }
                let controller = segue.destination as! DetailViewController
                controller.detailWord = word
            }
        }
    }
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func searchBarIsEmpty() -> Bool
    {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All")
    {
        filteredList = wordList.filter({( word : Word) -> Bool in
            return (word.form?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func isFiltering() -> Bool
    {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isFiltering(){
            return filteredList.count
        } else {
            return wordList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var word:Word
        if isFiltering(){
            word = filteredList[indexPath.row]
        } else {
            word = wordList[indexPath.row]
        }
        cell.textLabel?.text = word.form
        return cell
    }
}
