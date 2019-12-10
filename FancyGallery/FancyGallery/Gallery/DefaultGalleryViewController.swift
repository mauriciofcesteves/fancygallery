//
//  DefaultGalleryViewController.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2019-12-09.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class DefaultGalleryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let images = [UIImage(named: "Pet1"), UIImage(named: "Pet2")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewPreSetup()
    }
    
    /** UITableView properties setup */
    func tableViewPreSetup() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        
        //stick the header to the tableView while scrolling
        let viewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: viewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -viewHeight, left: 0, bottom: 0, right: 0)
        
        //Register TableViewCells into TableView
        tableView.register(UINib(nibName: "DefaultGalleryMainImageTableViewCell", bundle: nil), forCellReuseIdentifier: "DefaultGalleryMainImageTableViewCell")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DefaultGalleryViewController: UITableViewDataSource, UITableViewDelegate {
    
    /** Called to retrieve the number of sections in the table view. */
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /** Called to retrieve the number of rows for a given section. */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return 1
    }
    
    /** Called to retrieve the item for a given index path. */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultGalleryMainImageTableViewCell", for: indexPath) as? DefaultGalleryMainImageTableViewCell {

            guard let image = images[indexPath.section] else {
                return UITableViewCell()
            }
            
            cell.update(image)
            return cell
        }
        return UITableViewCell()
    }
    
    /** Called to retrieve the height of the item for the specified index path. */
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /** Custom table view header */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Title"
        label.font = UIFont.init(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = .black
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
