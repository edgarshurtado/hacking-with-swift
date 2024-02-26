//
//  ViewController.swift
//  p07-whitehouse-petitions
//
//  Created by Edgar Sánchez Hurtado on 6/6/23.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbarRightButtons()
        loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    // MARK: Methods
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            tableView.reloadData()
        } else {
            showError()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func loadData() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func setupNavbarRightButtons() {
        let aboutButton = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(showCredits))
        let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(promptFilter))
        
        navigationItem.rightBarButtonItems = [aboutButton, filterButton]
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "Information retrieved from We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func promptFilter() {
        let ac = UIAlertController(title: "Filter petitions", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let filterAction = UIAlertAction(title: "OK", style: .default) { action in
            let textToSearch = ac.textFields![0].text
            DispatchQueue.global(qos: .background).async {
                self.filterPetitions(filterText: textToSearch)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    ac.dismiss(animated: true)
                }
            }
        }
        ac.addAction(filterAction)
        present(ac, animated: true)
    }
    
    @objc func filterPetitions(filterText: String?) {
        guard let filterText = filterText else {return}
        filteredPetitions = petitions.filter({$0.title.lowercased().contains(filterText.lowercased())})
    }
    
    // MARK: Table View Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var cellContentConfiguration = UIListContentConfiguration.cell()
        cellContentConfiguration.text = filteredPetitions[indexPath.row].title
        cellContentConfiguration.secondaryText = filteredPetitions[indexPath.row].body
        cell.contentConfiguration = cellContentConfiguration
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

