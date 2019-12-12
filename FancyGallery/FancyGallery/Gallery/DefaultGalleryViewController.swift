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
        case tableViewMode
        case collectionViewMode
        case favouritesOnly
    }
    
    enum TabControlIndex: Int {
        case tableViewMode
        case collectionViewMode
        case favouritesOnly
        case count
        
        func toString() -> String {
            switch self {
            case .tableViewMode:
                return "TableView Mode"
            case .collectionViewMode:
                return "CollectionView Mode"
            case .favouritesOnly:
                return "Favourites"
            default:
                return ""
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabControlContainerView: UIView!
    @IBOutlet weak var galleryTabBar: UITabBar!
    
    // MARK: - General Variables
    private var currentTabIndex: TabControlIndex = .tableViewMode
    private var favouritePhotos: [Int] = []
    private var data: [PhotoModel]?
    private var dataToBePresented: [PhotoModel]?
    
    /** The empty state label. */
    public lazy var emptyStateLabel: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = UIColor(red: 155 / 255, green: 155 / 255, blue: 155 / 255, alpha: 1)
        label.numberOfLines = 0
        label.text = "There is no photos marked as favourite."
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        //setup UI
        tableViewSetup()
        tabBarSetup()
        
        //fetch data (from backend and userdefaults)
        loadFavouritePhotos()
        loadData()
    }
    
    /** General setup UI */
    func setupUI() {
        view.backgroundColor = UIColor(red: 249 / 255, green: 249 / 255, blue: 249 / 255, alpha: 1)
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
        self.navigationController?.navigationBar.isHidden = true
        self.tabControlContainerView.applyBottomShadow()
    }
    
    /** UITabBar UI setup */
    func tabBarSetup() {
        galleryTabBar.delegate = self
    }
    
    /** UITableView properties setup */
    func tableViewSetup() {
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
    
    /** Save photo in UserDefaults */
    func saveFavouriteOffers() {
        UserDefaults.standard.set(favouritePhotos, forKey: "favouritePhotos")
    }
    
    /** Load saved photos from UserDefaults */
    func loadFavouritePhotos() {
        favouritePhotos = []
        favouritePhotos = UserDefaults.standard.value(forKey: "favouritePhotos") as? [Int] ?? []
    }
    
    /** TODO: Fetch data from a back end */
    func loadData() {
        data = []
        dataToBePresented = []
        data?.append(PhotoModel(id: 0, name: "Pet1"))
        data?.append(PhotoModel(id: 1, name: "Pet2"))
        data?.append(PhotoModel(id: 2, name: "Pet3"))
        
        dataToBePresented?.append(contentsOf: data ?? [])
    }
    
    /** Empty state for favourite screen. */
    func favouritePhotosEmptyState() {
        tableView.isHidden = true
        emptyStateLabel.isHidden = false
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            ])
    }
    
    /** Return true if the photo is marked as favourite. */
    func isMarkedAsFavourite(photoId: Int) -> Bool {
        for id in favouritePhotos {
            if photoId == id {
                return true
            }
        }
        
        return false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DefaultGalleryViewController: UITableViewDataSource, UITableViewDelegate {
    
    /** Called to retrieve the number of sections in the table view. */
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataToBePresented?.count ?? 0
    }
    
    /** Called to retrieve the number of rows for a given section. */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 1
    }
    
    /** Called to retrieve the item for a given index path. */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultGalleryMainImageTableViewCell", for: indexPath) as? DefaultGalleryMainImageTableViewCell {

            guard let model = dataToBePresented?[indexPath.section], let image = UIImage(named: model.name) else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            cell.update(image, isFavourite: isMarkedAsFavourite(photoId: model.id), indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    /** Called to retrieve the height of the item for the specified index path. */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

/** MARK: DefaultGalleryMainImageTableViewCellDelegate - Callback for heart(favourite) button */
extension DefaultGalleryViewController: DefaultGalleryMainImageTableViewCellDelegate {
    
    func didTouchHeartButton(cell: DefaultGalleryMainImageTableViewCell, isFavourite: Bool, indexPath: IndexPath) {
        let selectedPhoto = dataToBePresented?[indexPath.section]
        
        guard let id = selectedPhoto?.id else {
            return
        }
        
        if isFavourite {
            //if it's marked as favourite, saves to the list
            favouritePhotos.append(id)
        } else {
            //remove from the list of favourites
            let model = dataToBePresented?[indexPath.section]
            for (index, photoId) in favouritePhotos.enumerated() {
                if photoId == model?.id {
                    favouritePhotos.remove(at: index)
                    break
                }
            }
        }
        saveFavouriteOffers()
    }
}

/** MARK: UITabBarDelegate - Callback for UITabBar */
extension DefaultGalleryViewController: UITabBarDelegate {
    
    /** Detect when one of the tab button was touched and present the selected screen. */
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == TabControlIndex.favouritesOnly.rawValue {
            dataToBePresented = []
            
            //iterate over the list to fetch the photos marked as favourite
            for photoId in favouritePhotos {
                for currentPhotoModel in data ?? [] {
                    if photoId == currentPhotoModel.id {
                        dataToBePresented?.append(currentPhotoModel)
                    }
                }
            }
            
            if dataToBePresented?.isEmpty ?? true {
                //present the empty state in the favourite screen
                favouritePhotosEmptyState()
            }
            
            tableView.reloadData()
        } else if item.tag == TabControlIndex.tableViewMode.rawValue {
            loadData()
            tableView.isHidden = false
            emptyStateLabel.isHidden = true
            tableView.reloadData()
        }
    }
}
