//
//  ListPicturesViewController.swift
//  Picsumple
//
//  Created by Dilz Osmani on 17/10/2018.
//  Copyright © 2018 com.picsumpl.test. All rights reserved.
//

import UIKit
import SnapKit

protocol ListPicturesView: ViewProtocol {
    var tableView: UITableView? { get set }
}

final class ListPicturesViewController: UIViewController, MVPViewController {
    typealias P = ListPicturesPresenter
    
    // MARK: - Properties
    
    lazy var presenter: P = .init(self)
    weak var tableView: UITableView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.title = "Pictures"
        
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(UINib(nibName: "PictureTableViewCell", bundle: nil), forCellReuseIdentifier: "picCell")
        tableView.delegate = presenter
        tableView.dataSource = presenter
        self.tableView = tableView
        
        // Start a request
        self.presenter.getPhotos()
    }
    
}

// MARK: - View extension

extension ListPicturesViewController : ListPicturesView {
    var vc: UIViewController {
        return self
    }
}
