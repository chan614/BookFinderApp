//
//  ListViewController.swift
//  bookFinderApp
//
//  Created by 박지찬 on 2022/05/06.
//

import UIKit

class ListViewController: UISearchController {

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    private func setUp() {
        let cellNib = UINib(nibName: ListItemCell.reuseID, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: ListItemCell.reuseID)
        tableView.rowHeight = 60
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
