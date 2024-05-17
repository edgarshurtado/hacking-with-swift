//
//  ViewController.swift
//  p01-storm-viewer
//
//  Created by Edgar Sánchez Hurtado on 5/2/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var picturesOpenCount = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendAppTapped))
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }

        let defaults = UserDefaults.standard
        picturesOpenCount = defaults.object(forKey: "picturesOpenCount") as? [Int] ?? [Int](repeating: 0, count: pictures.count)

        pictures.sort()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Opened: \(picturesOpenCount[indexPath.row]) times"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailViewController.selectedImage = pictures[indexPath.row]
            detailViewController.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
            picturesOpenCount[indexPath.row] += 1
            UserDefaults.standard.set(picturesOpenCount, forKey: "picturesOpenCount")
            tableView.reloadRows(at: [indexPath], with: .automatic)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    @objc func recommendAppTapped() {
        let vc = UIActivityViewController(activityItems: ["Check out this awesome app"], applicationActivities: [])
        vc.popoverPresentationController?.sourceItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }

}

