//
//  CamerasViewController.swift
//  [AK]_iOS_Flickr
//
//  Created by Konstantin on 10.10.2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class CamerasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var camerasData = [CameraModel]()
    private let url = "https://api.flickr.com/services/rest/?method=flickr.cameras.getBrandModels&api_key=11d598612b8724c798275910a68beaff&format=json&nojsoncallback=1"
    private let messageNotFound = "Nothing found :( Try Again.."
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SimpleTableViewCell", bundle: nil), forCellReuseIdentifier: "simple")
        self.tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "detail")
    }
    
    //MARK: - Main Functions
    
    private func fetchDataFromAPI(with text: String) {
        DispatchQueue.main.async {
            let parameters: Parameters = [
                "brand": text
            ]
            Alamofire.request(self.url, parameters: parameters).validate().responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    guard let cameras = CameraModel.createModel(from: value) else {
                        self.showAlert(self.messageNotFound)
                        return
                    }
                    self.camerasData = cameras
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showAlert(error.localizedDescription)
                }
            })
            self.spinner.stopAnimating()
        }
        
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Message:", message: message, preferredStyle: .alert)
        let buttonOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(buttonOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UITableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return camerasData.count
    }    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let detail = camerasData[indexPath.row].details { //Thread 1: Fatal error: Index out of range
            let cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! DetailTableViewCell
            cell.brandTitle.text = camerasData[indexPath.row].name
            cell.megaPixels.text = detail.megapixels
            cell.screenSize.text = detail.lcd_screen_size
            cell.memoryType.text = detail.memory_type
            
            guard let url = try? camerasData[indexPath.row].images.asURL() else { return cell }
            cell.largeImage.sd_setImage(with: url, completed: nil)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simple", for: indexPath) as! SimpleTableViewCell
            cell.brandTitle.text = camerasData[indexPath.row].name
            
            guard let url = try? camerasData[indexPath.row].images.asURL() else { return cell }
            cell.smallImage.sd_setImage(with: url, completed: nil)
            
            return cell
        }
    }
    
    //MARK: - UISearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { return }
        self.view.bringSubview(toFront: spinner)
        spinner.startAnimating()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        camerasData.removeAll()
        fetchDataFromAPI(with: searchText)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        spinner.stopAnimating()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        spinner.stopAnimating()
        searchBar.resignFirstResponder()
    }
    
    // Hide keyboard on touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
