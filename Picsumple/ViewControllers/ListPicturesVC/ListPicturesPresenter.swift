//
//  ListPicturesPresenter.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit

final class ListPicturesPresenter: NSObject, PresenterProtocol {
    typealias V = ListPicturesView
    
    // MARK: - Properties
    
    unowned var view: V
    private (set) var photos = [Photo]() {
        didSet {
            guard let tableView = self.view.tableView else { return }
            tableView.reloadData()
            
            for (i, cell) in tableView.visibleCells.enumerated() {
                let cell: UITableViewCell = cell as UITableViewCell
                let tableHeight: CGFloat = tableView.bounds.size.height
                cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
                
                UIView.animate(withDuration: 1.5, delay: 0.05 * Double(i), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            }
        }
    }
    
    // MARK: - Init
    
    init(_ view: V) {
        self.view = view
        super.init()
    }
    
    func getPhotos() {
        Api.shared.getListOfPhotos { (result) in
            switch result {
            case .success(let photos as [Photo]):
                self.photos = photos
            case .success(_):
                break
            case .error(let error):
                break
            case .noConnection:
                break
            }
        }
    }
}

// MARK: - UITableView delegate

extension ListPicturesPresenter: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "picCell") as! PictureTableViewCell
        let photo = self.photos[indexPath.row] as PhotoMasterCell
        cell.setPhoto(photo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let rowNum = indexPath.row
        let vc = PictureDetailsViewController(photos: self.photos, numberInArray: rowNum)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        self.view.vc.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
