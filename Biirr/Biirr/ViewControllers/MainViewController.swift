//
//  MainViewController.swift
//  InfiniumTest
//
//  Created by andrii on 05/03/2021.
//

import UIKit
import Hero
import Moya

class MainViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var page = 1
    var beers = [Beer]()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hero.isEnabled = true
        navigationController?.hero.isEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hero.modifiers = [.cascade]
        activityIndicator.startAnimating()
        loadData()
    }
    
    private func loadData() {
        isLoading = true
        _  = ApiService.shared.send(request: .beers(page: page)) { (error, response: BeerResponse?) in
            if let result = response?.data {
                self.beers.append(contentsOf: result)
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            self.isLoading = false
        }
    }
}

extension MainViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell", for: indexPath) as? BeerTableViewCell{
            cell.setBeer(beers[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DetailsViewController,
           let detailsVC = segue.destination as? DetailsViewController,
           let indexPath = tableView.indexPathForSelectedRow{
            let beer = beers[indexPath.row]
            detailsVC.beer = beer
        }
    }
    
    /// Load additional data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == beers.count - 1 && !isLoading && indexPath.row != 0 {
            page = page + 1
            loadData()
        }
    }
}

extension MainViewController:UITableViewDelegate{
    
}
