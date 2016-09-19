//
//  LikedAlbumTableViewController.swift
//  Pokemon
//
//  Created by Evgeny on 9/6/16.
//  Copyright © 2016 Evgeny. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import ImageLoader
import RxDataSources

class  LikedAlbumTableViewController : UITableViewController {

    private let likedAlbumViewModel = LikedAlbumViewModel()
    private let bag = DisposeBag()
    
    var dataSourceTable: RxTableViewSectionedAnimatedDataSource<DataSection>?
    
    @IBOutlet weak var LikedAlbumView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likedAlbumViewModel.likedCellViewModelList.asObservable()
            .subscribeNext { (likedCellVMList :[CellViewModel]) in
            self.LikedAlbumView.reloadData()
        }
        .addDisposableTo(bag)
        
       
        self.LikedAlbumView.delegate = nil
        self.LikedAlbumView.dataSource = nil
        
        LikedAlbumView
            .rx_setDelegate(self)
            .addDisposableTo(bag)
        
        let dataSourceTable = RxTableViewSectionedAnimatedDataSource<DataSection>()
        
        likedAlbumViewModel.sections.asObservable()
            .bindTo(LikedAlbumView.rx_itemsWithDataSource(dataSourceTable))
        
        
        
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedAlbumViewModel.likedCellViewModelList.value.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let likedAlbumCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AllAlbumCell
        likedAlbumCell.setAlbumData(likedAlbumViewModel.likedCellViewModelList.value[indexPath.row])
        return likedAlbumCell
    }

 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        likedAlbumViewModel.initPhotoModelByRowIndex(indexPath.row)
        self.performSegueWithIdentifier("showAlbumPhotos2", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let photoController : PhotoCollectionViewController = segue.destinationViewController as! PhotoCollectionViewController
        photoController.photoViewModel = self.likedAlbumViewModel.photoViewModel.value
    }
}

