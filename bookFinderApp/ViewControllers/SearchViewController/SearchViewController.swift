//
//  SearchViewController.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/06.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel
    private let searchController = UISearchController()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SearchViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    private func setUp() {
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
   

}
