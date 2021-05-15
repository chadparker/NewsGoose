//
//  MainVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import UIKit
import NGCore

protocol PointsFilterable {
    var pointsThreshold: Int { get set }
}

class MainVC: UIViewController {

    @IBOutlet weak var pointsSegControl: UISegmentedControl!
    @IBOutlet weak var searchContainer: UIView!

    let postManager = PostManager()
    
    var searchVC: SearchVC!
    var pointsFilterable: PointsFilterable!
    
    var pointsSegmentValue: Int {
        let pointsText = pointsSegControl.titleForSegment(at: pointsSegControl.selectedSegmentIndex)!
        return pointsText.intValueFromDigits
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.delegate = self
            searchVC.postManager = postManager
            self.searchVC = searchVC
        } else if let pointsFilterable = segue.destination as? PointsFilterable {
            self.pointsFilterable = pointsFilterable
            self.pointsFilterable.pointsThreshold = pointsSegmentValue
        }
    }
    
    @IBAction func pointsSelectionChanged(_ sender: UISegmentedControl) {
        pointsFilterable.pointsThreshold = pointsSegmentValue
    }
    
    @IBAction func showSearch(_ sender: UIButton) {
        searchContainer.isHidden = false
        searchVC.activate()
    }
}

extension MainVC: SearchVCDelegate {

    func hideSearch() {
        searchContainer.isHidden = true
    }
}
