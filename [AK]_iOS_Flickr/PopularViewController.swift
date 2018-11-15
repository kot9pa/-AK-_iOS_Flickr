//
//  PopularViewController.swift
//  [AK]_iOS_Flickr
//
//  Created by Konstantin on 20.10.2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class PopularViewController: UIViewController {
    
    //MARK: - Properties

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var popularPhotos = [URL]()
    private var totalPhotos: Int?
    private var currentPage = 1 //default, get photo from page=1
    private var photosPerPage = 10 //default, count photos per page
    
    private let url = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=11d598612b8724c798275910a68beaff&format=json&nojsoncallback=1"
    private let messageNotFound = "Something wrong :( Try Again.."
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        fetchDataFromAPI(with: currentPage)
    }
    
    //MARK: - Main function
    
    private func fetchDataFromAPI(with page: Int) {
        DispatchQueue.main.async { [weak self] in
            let parameters: Parameters = [
                "page": page,
                "per_page": self!.photosPerPage
            ]
            Alamofire.request(self!.url, parameters: parameters).validate().responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    if self?.totalPhotos == nil {
                        self?.totalPhotos = Photos.getCount(from: value) ?? self!.photosPerPage //get total photos, if nil, set default photos per page
                    }
                    //create URL from JSON
                    guard let photos = PhotoModel.createURL(from: value) else {
                        self?.showAlert(self!.messageNotFound)
                        return
                    }
                    self?.popularPhotos = photos
                    self?.collectionView.reloadData()
                case .failure(let error):
                    self?.showAlert(error.localizedDescription)
                }
            })
        }
        
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Message:", message: message, preferredStyle: .alert)
        let buttonOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(buttonOK)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UICollectionView extension

extension PopularViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColums: CGFloat = 2 // Number of columns
        let width = collectionView.frame.size.width
        let xInsents: CGFloat = 10
        let cellSpacing: CGFloat = 5
        let formula: CGFloat = (width/numberOfColums) - (xInsents + cellSpacing)
        
        return CGSize(width: formula, height: formula)
    }
}

extension PopularViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularPhotos.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let url = popularPhotos[indexPath.row]
        cell.imageView.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    
    //Pagination
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == popularPhotos.count && popularPhotos.count < totalPhotos! {
            currentPage = currentPage + 1
            fetchDataFromAPI(with: currentPage)
        }
    }
}
