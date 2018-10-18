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
            self.view.tableView?.reloadData()
        }
    }
    
    // MARK: - Init
    
    init(_ view: V) {
        self.view = view
        super.init()
        
        self.getPhotos()
    }
    
    private func getPhotos() {
        Api.shared.getListOfPhotos { (result) in
            switch result {
            case .success(let photos as [Photo]):
                self.photos = photos
            case .success(let _):
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
        
        let vc = PictureDetailsViewController()
        vc.photo = self.photos[indexPath.row] as PhotoMasterCell
        self.view.vc.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
