//
//  DefaultGalleryViewController.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-09.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class DefaultGalleryViewController: BaseViewController {

    // MARK: - Enums
    enum GalleryType: Int {
        case tableViewMode
        case favouritesOnly
    }
    
    enum TabControlIndex: Int {
        case tableViewMode
        case favouritesOnly
        case count
        
        func toString() -> String {
            switch self {
            case .tableViewMode:
                return "TableView Mode"
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
    private var favouritePhotos: [String] = []
    private var totalOfNewFavouritePhotos = 0
    public var data: [PhotoModel]?
    public var dataToBePresented: [PhotoModel]?
    
    /** The empty state label. */
    public lazy var emptyStateLabel: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = UIColor(red: 155 / 255, green: 155 / 255, blue: 155 / 255, alpha: 1)
        label.numberOfLines = 0
        label.text = "There are no photos marked as favourite."
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayActivityIndicator(true)
        
        // Do any additional setup after loading the view.
        setupUI()
        
        //setup UI
        tableViewSetup()
        tabBarSetup()
        
        //load favourite photos from userdefaults
        loadFavouritePhotos()
    }
    
    /** General setup UI */
    func setupUI() {
        view.backgroundColor = UIColor(red: 249 / 255, green: 249 / 255, blue: 249 / 255, alpha: 1)
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
        self.navigationController?.navigationBar.isHidden = true
        self.tabControlContainerView.applyBottomShadow()
        self.galleryTabBar?.selectedItem = self.galleryTabBar?.items?.first
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
        favouritePhotos = UserDefaults.standard.value(forKey: "favouritePhotos") as? [String] ?? []
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
    func isMarkedAsFavourite(photoId: String) -> Bool {
        for id in favouritePhotos {
            if photoId == id {
                return true
            }
        }
        
        return false
    }
    
    /* Setup an error state if there is any connection problem. */
    func setupErrorState() {
        let alertController = UIAlertController(title: "Error", message: "Oops! Something went wrong. Please check your internet and try again later.", preferredStyle: .alert)
        let mainAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
            
        })
        alertController.addAction(mainAction)
        self.present(alertController, animated: true, completion: nil)
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

            guard let model = dataToBePresented?[indexPath.section] else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            cell.update(imageTitle: model.name, imageDescription: model.photoDescription, isFavourite: isMarkedAsFavourite(photoId: model.id), indexPath)
            
            if let smallPhoto = model.photoURL {
                cell.mainImageView?.sd_setImage(with: URL(string: smallPhoto), completed: { (image, error, cache, urls) in
                    if (error != nil) {
                        cell.mainImageView.image = UIImage(named: "Placeholder")
                    } else {
                        cell.mainImageView?.image = image
                    }
                })
            }
            
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
    
    func didTouchImageView(cell: DefaultGalleryMainImageTableViewCell, indexPath: IndexPath) {
        guard let model = dataToBePresented?[indexPath.section], let photoUrl = model.photoURL else {
            return
        }
        
        let url = URL(string: photoUrl)
        if let data = try? Data(contentsOf: url!), let image = UIImage(data: data) {
            let controller = PhotoDialogViewController()
            self.navigationController?.present(controller, animated: true)
            controller.photoImageView.image = image
        }
    }
    
    func didTouchShareButton(cell: DefaultGalleryMainImageTableViewCell, indexPath: IndexPath) {
        guard let model = dataToBePresented?[indexPath.section], let photoUrl = model.photoURL else {
            return
        }
        
        let url = URL(string: photoUrl)
        if let data = try? Data(contentsOf: url!), let image = UIImage(data: data) {
            let message = ""
            let objectsToShare = [message, image] as [Any]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func didTouchHeartButton(cell: DefaultGalleryMainImageTableViewCell, isFavourite: Bool, indexPath: IndexPath) {
        let selectedPhoto = dataToBePresented?[indexPath.section]
        
        guard let id = selectedPhoto?.id else {
            return
        }
        
        if isFavourite {
            //if it's marked as favourite, saves to the list
            favouritePhotos.append(id)
            totalOfNewFavouritePhotos += 1
        } else {
            //remove from the list of favourites
            let model = dataToBePresented?[indexPath.section]
            for (index, photoId) in favouritePhotos.enumerated() {
                if photoId == model?.id {
                    favouritePhotos.remove(at: index)
                    totalOfNewFavouritePhotos -= 1
                    break
                }
            }
        }
        
        //update the UIBarItem badge value
        for item in galleryTabBar.items ?? [] {
            if item.tag == TabControlIndex.favouritesOnly.rawValue {
                if totalOfNewFavouritePhotos == 0 {
                    item.badgeValue = nil
                } else if totalOfNewFavouritePhotos > 0 {
                    item.badgeValue = String(totalOfNewFavouritePhotos)
                } else if totalOfNewFavouritePhotos < 0 {
                    totalOfNewFavouritePhotos = 0
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
            //clean the UITabBar badge value
            totalOfNewFavouritePhotos = 0
            for item in galleryTabBar.items ?? [] {
                if item.tag == TabControlIndex.favouritesOnly.rawValue {
                    item.badgeValue = nil
                }
            }
            
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
            data = NetworkManager.shared.pets
            dataToBePresented = NetworkManager.shared.pets
            tableView.isHidden = false
            emptyStateLabel.isHidden = true
            tableView.reloadData()
        }
    }
}
