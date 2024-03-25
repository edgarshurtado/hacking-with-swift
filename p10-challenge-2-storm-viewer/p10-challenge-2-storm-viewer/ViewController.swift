//
//  ViewController.swift
//  p01-storm-viewer
//
//  Created by Edgar Sánchez Hurtado on 5/2/23.
//

import UIKit

class ViewController: UICollectionViewController {

    var pictures = [String]()

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
        pictures.sort()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCollectionViewCell else {
            fatalError("Couldn't get collection cell")
        }
        cell.fileName?.text = pictures[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailViewController.selectedImage = pictures[indexPath.row]
            detailViewController.title = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    @objc func recommendAppTapped() {
        let vc = UIActivityViewController(activityItems: ["Check out this awesome app"], applicationActivities: [])
        vc.popoverPresentationController?.sourceItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }
}

