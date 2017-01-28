//
//  MemeTableViewController.swift
//  ImagePickerExperiment
//
//  Created by MinGeon Ju on 2017. 1. 28..
//  Copyright © 2017년 MinGeon Ju. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController{
    var memes: [Meme]!
    var memesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        memesCount = memes.count
        
        //dump(memes)
        
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellID = "MemeTableCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! MemeTableViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        dump(cell.topText)
        
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.memedImageView.image = meme.memedImage
        //cell.textLabel!.text = victoryStatusDescription(match)
        //cell.detailTextLabel!.text = "\(match.p1) vs. \(match.p2)"
        
        return cell
    }
}
