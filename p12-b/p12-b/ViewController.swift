//
//  ViewController.swift
//  p10-names-to-faces
//
//  Created by Edgar Sánchez Hurtado on 26/2/24.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))

        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }

        let person = people[indexPath.item]

        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)

        cell.imageView.layer.borderColor = UIColor(white:0, alpha: 0.3).cgColor
        cell.imageView.layer.cornerRadius = 3
        cell.imageView.layer.borderWidth = 2
        cell.layer.cornerRadius = 7

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        showOptionsFor(person)
    }

    func showRenamePrompt(_ person: Person) {
        let ac = UIAlertController(title: "Change name", message: "Introduce the new name", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newName = ac.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
            self?.save()
        })

        present(ac, animated: true)
    }

    func showOptionsFor(_ person: Person) {
        let ac = UIAlertController(title: "What do you want to do?", message: "", preferredStyle: .alert)
        ac.addAction(UIAlertAction(
            title: "Cancel", style: .cancel
        ))

        ac.addAction(UIAlertAction(
            title: "Rename",
            style: .default,
            handler: { _ in self.showRenamePrompt(person)}
        ))

        ac.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { _ in self.deletePerson(person)}
        ))

        present(ac, animated: true)
    }

    func deletePerson(_ person: Person) {
        guard let index = people.firstIndex(of: person) else { return }
        people.remove(at: index)
        self.collectionView.reloadData()
        self.save()
    }

    func renamePerson(_ person: Person) {
        let ac = UIAlertController(title: "Change name", message: "Introduce the new name", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let newName = ac.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
            self?.save()
        })

        present(ac, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        people.append(Person(name: "Unknown", image: imageName))
        collectionView.reloadData()
        self.save()

        dismiss(animated:true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    private func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people")
        }
    }
}

