//
//  DetailViewController.swift
//  Lexicon
//
//  Created by Ibrahim Mehkri  on 2018-05-07.
//  Copyright © 2018 BigNerdRanch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailWord: Word!
       

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var pronunLabel: UILabel!
    @IBOutlet weak var infLabel: UILabel!
    @IBOutlet weak var posLabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var idiomLabel: UILabel!
    @IBOutlet weak var valLabel: UILabel!
    @IBOutlet weak var commLabel: UILabel!
    @IBOutlet weak var compLabel: UILabel!
    @IBOutlet weak var defCommLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView(){
        wordLabel.text = detailWord.form
        pronunLabel.text = detailWord.pronunciation
        infLabel.text = detailWord.inflection
        posLabel.text = detailWord.pos
        defLabel.text = detailWord.definition
        usageLabel.text = detailWord.usage
        exampleLabel.text = detailWord.examples
        valLabel.text = detailWord.valency
        idiomLabel.text = detailWord.idioms
        commLabel.text = detailWord.comment
        compLabel.text = detailWord.compound
        defCommLabel.text = detailWord.definitionComm
    }
}
