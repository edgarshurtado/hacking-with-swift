//
//  UrlsTableViewController.swift
//  p04-easy-browser
//
//  Created by Edgar Sánchez Hurtado on 10/4/23.
//

import UIKit

class UrlsTableViewController: UITableViewController {
    
    var websites = ["apple.com", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath)
        var cellConfig = UIListContentConfiguration.cell()
        cellConfig.text = websites[indexPath.row]
        cell.contentConfiguration = cellConfig

        return cell
    }

    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let webViewController = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            webViewController.initialUrl = websites[indexPath.row]
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}
