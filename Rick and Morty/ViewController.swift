//
//  ViewController.swift
//  Rick and Morty
//
//  Created by Bill Vivino on 8/2/22.
//

import Foundation
import UIKit

enum CustomError: Error {
    case invalidURL
    case badRequest
    case noData
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // View Model
    var data: RickAndMorty = RickAndMorty(results: [])
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
        
        // populate the cell data into the textfield
        
        cell.textLabel?.text = data.results[indexPath.row].name
        
        return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.results.count
    }
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        getInto(data) { [weak self] result in
            switch result {
            case .success(let rickAndMortyData):
                self?.data = rickAndMortyData
                for line in rickAndMortyData.results {
                    print(line)
                }
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getInto (_ data: RickAndMorty, completion: @escaping (Result<RickAndMorty, CustomError>) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                completion(.failure(CustomError.badRequest))
                return
            } else if let data = data {
                let decoder = JSONDecoder()
                let product = try? decoder.decode(RickAndMorty.self, from: data)
                if let product = product {
                    completion(.success(product))
                } else {
                    completion(.failure(CustomError.noData))
                }
            }
        }
        task.resume()

    }
}

