//
//  ViewController.swift
//  Task1
//
//  Created by D. Serov on 10/12/2017.
//  Copyright © 2017 Dmitry Serov. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cellIdentifier = "Cell"
    var countOfCells = 100
    let baseURL = "http://placehold.it/375x150?text="
    let imageService = ImageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    func downloadImage(withURL url: URL, forCell cell: UITableViewCell) {
        guard let myCell = cell as? Cell else { return } 
        imageService.fetchImage(url: url, completion: { image in
            DispatchQueue.main.async {
                myCell.placeholderImageView.image = image
            }
        })
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell
        let url = URL(string: baseURL + "\(indexPath.row + 1)")!
        downloadImage(withURL: url, forCell: cell)
        
        return cell
    }
}

