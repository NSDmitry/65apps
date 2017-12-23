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
        tableView.delegate = self
    }
    
    func downloadImage(withURL url: URL, forCell cell: UITableViewCell) {
        guard let myCell = cell as? Cell else { return } 
        imageService.fetchImage(url: url, completion: { image in
            DispatchQueue.main.async {
                myCell.placeholderImageView.image = image
            }
        })
    }
    
    fileprivate func url(with indexPath: IndexPath) -> URL {
        return URL(string: baseURL + "\(indexPath.row + 1)")!
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? Cell else { return }
        let imageUrl = url(with: indexPath)
        downloadImage(withURL: imageUrl, forCell: cell)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? Cell, cell.placeholderImageView.image != nil else { return }
        imageService.cancellTask(url: url(with: indexPath))
    }
}
