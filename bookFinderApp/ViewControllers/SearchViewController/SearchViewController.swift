//
//  SearchViewController.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/06.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel
    private let searchController = UISearchController()
    private let headerView: SearchedListHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let view = SearchedListHeaderView(frame: frame)
        
        return view
    }()
    
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
        subscribeUI()
        bind()
    }

    private func setUp() {
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = true
        
        
        let cellNib = UINib(nibName: SearchedItemCell.reuseID, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SearchedItemCell.reuseID)
        tableView.rowHeight = 60
        
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.frame = .init(x: 0, y: 0, width: 30, height: 30)
        indicatorView.startAnimating()
        tableView.tableFooterView = indicatorView
        tableView.tableFooterView?.isHidden = true
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
//        tableView.tableHeaderView = headerView
    }
    
    private func subscribeUI() {
        searchController.searchBar.rx.text
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribe(with: self, onNext: { owner, text in
                owner.viewModel.search(term: text ?? String())
            })
            .disposed(by: disposeBag)
            
        tableView.rx.modelSelected(BookListItem.self)
            .subscribe(with: self, onNext: { owner, item in
                if let infoURL = item.infoURL {
                    UIApplication.shared.open(infoURL, options: [:])
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        viewModel.listObservable(event: tableView.rx.willDisplayCell)
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchedItemCell.reuseID,
                cellType: SearchedItemCell.self)
            ) { index, element, cell in
                cell.configure(item: element)
            }
            .disposed(by: disposeBag)
        
        if let tableFooterViewIsHidden = tableView.tableFooterView?.rx.isHidden {
            viewModel.loadingHiddenObservable
                .bind(to: tableFooterViewIsHidden)
                .disposed(by: disposeBag)
        }
        
        viewModel.totalCountObservable
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, count in
                owner.headerView.configure(totalCount: count)
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return headerView
    }
}
