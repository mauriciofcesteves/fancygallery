//
//  DefaultGalleryViewController.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-09.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class DefaultGalleryViewController: UIViewController {

    // MARK: - Enums
    enum GalleryType: Int {
        case all
        case favourites
    }
    
    enum TabControlIndex: Int {
        case all
        case favourites
        case count
        
        func toString() -> String {
            switch self {
            case .all:
                return "All"
            case .favourites:
                return "Favourites"
            default:
                return ""
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabControlContainerView: UIView!
    
    // MARK: - General Variables
    private var currentTabIndex: TabControlIndex = .all
    private var favouritePhotos: NSOrderedSet = []
    private var data: [PhotoModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.tabControlContainerView.applyBottomShadow()
        tableViewPreSetup()
        loadFavouritePhotos()
        loadData()
    }
    
    /** UITableView properties setup */
    func tableViewPreSetup() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.allowsSelection = false
        
        //stick the header to the tableView while scrolling
        let viewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: viewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -viewHeight, left: 0, bottom: 0, right: 0)
        
        //Register TableViewCells into TableView
        tableView.register(UINib(nibName: "DefaultGalleryMainImageTableViewCell", bundle: nil), forCellReuseIdentifier: "DefaultGalleryMainImageTableViewCell")
    }
    
    /** Save photo from UserDefaults */
    func saveFavouriteOffers() {
        UserDefaults.standard.set(favouritePhotos, forKey: "favouritePhotos")
    }
    
    /** Load saved photos from UserDefaults */
    func loadFavouritePhotos() {
        favouritePhotos = []
        favouritePhotos = UserDefaults.standard.value(forKey: "favouritePhotos") as? NSOrderedSet ?? []
    }
    
    /** TODO: Fetch data from a back end */
    func loadData() {
        data = []
        data?.append(PhotoModel(id: 0, name: "Pet1"))
        data?.append(PhotoModel(id: 1, name: "Pet2"))
        data?.append(PhotoModel(id: 2, name: "Pet3"))
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DefaultGalleryViewController: UITableViewDataSource, UITableViewDelegate {
    
    /** Called to retrieve the number of sections in the table view. */
    public func numberOfSections(in tableView: UITableView) -> Int {
        return data?.count ?? 0
    }
    
    /** Called to retrieve the number of rows for a given section. */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 1
    }
    
    /** Called to retrieve the item for a given index path. */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultGalleryMainImageTableViewCell", for: indexPath) as? DefaultGalleryMainImageTableViewCell {

            guard let name = data?[indexPath.section].name, let image = UIImage(named: name) else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            cell.update(image, indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    /** Called to retrieve the height of the item for the specified index path. */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

/** Callback for heart button - DefaultGalleryMainImageTableViewCellDelegate */
extension DefaultGalleryViewController: DefaultGalleryMainImageTableViewCellDelegate {
    
    func didTouchHeartButton(cell: DefaultGalleryMainImageTableViewCell, isFavourite: Bool, indexPath: IndexPath) {
        let selectedPhoto = data?[indexPath.section]
        
        guard let id = selectedPhoto?.id else {
            return
        }
        
        favouritePhotos.setValue(id, forKey: String(indexPath.section))
        saveFavouriteOffers()
    }
}
