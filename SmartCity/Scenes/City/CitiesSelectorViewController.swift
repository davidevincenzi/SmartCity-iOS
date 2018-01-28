//
//  CitiesSelectorViewController.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit

class CitiesSelectorViewController: UITableViewController {
    
    private var data = [CityViewModel]()
    private var selectedCityViewModel: CityViewModel?
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.path(forResource: "cities", ofType: "csv")!
        let content = try! String(contentsOfFile: url)
        let csv = CSwiftV(with: content)
        
        var selectedIndexPath: IndexPath?
        for (index, row) in (csv.keyedRows ?? []).enumerated() {
            guard let city = row["City"] else { continue }
            let viewModel = CityViewModel(cityName: city)
            data.append(viewModel)
            if city.lowercased() == Preference.current.city {
                viewModel.selected = true
                selectedCityViewModel = viewModel
                selectedIndexPath = IndexPath(row: index, section: 0)
            }
            
        }
        
        DispatchQueue.main.async { [unowned self] in
            guard let indexPath = selectedIndexPath else { return }
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }

    }
    
    // MARK: -
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "city-cell", for: indexPath) as! CityTableViewCell
        let viewModel = data[indexPath.row]
        cell.viewModel = viewModel
        return cell
    }
    
    // MARK: -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCityViewModel?.selected = false
        let newSelectedCityViewModel = data[indexPath.row]
        newSelectedCityViewModel.selected = true
        self.selectedCityViewModel = newSelectedCityViewModel
        
        Preference.current.city = newSelectedCityViewModel.name.lowercased()
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

