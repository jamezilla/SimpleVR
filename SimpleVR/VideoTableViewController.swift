//
//  VideoTableViewController.swift
//  SimpleVR
//
//  Created by James Hughes on 8/20/17.
//  Copyright © 2017 James Hughes. All rights reserved.
//

import UIKit

class VideoTableViewController: UITableViewController {
    
    let urls: [URL] = Bundle.main.urls(forResourcesWithExtension: "mp4", subdirectory: "Videos") ?? []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        // push down the table cells so you can easily select them from inside the cardboard viewer
        let height = UIScreen.main.bounds.height - CGFloat(urls.count * 44) - 20
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: height))
        tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < urls.count else {
            fatalError()
        }
       
        let cell = UITableViewCell(style: .default, reuseIdentifier: "tableCell")
        cell.textLabel?.text = urls[indexPath.row].lastPathComponent
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = urls[indexPath.row]
        let viewController = RendererViewController(url: url)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
