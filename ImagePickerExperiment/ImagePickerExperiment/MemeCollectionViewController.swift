//
//  MemeCollectionViewController.swift
//  ImagePickerExperiment
//
//  Created by MinGeon Ju on 2017. 1. 28..
//  Copyright © 2017년 MinGeon Ju. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    @IBOutlet weak var flowLayout : UICollectionViewFlowLayout!
    
    var memes:[Meme]!
    var memesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        memesCount = memes.count
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memesCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.memedImageView?.image = meme.memedImage
        
        return cell
    }
}
