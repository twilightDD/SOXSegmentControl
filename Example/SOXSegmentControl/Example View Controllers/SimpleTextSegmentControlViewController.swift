//
//  SimpleTextSegmentControlViewController.swift
//  SOXSegmentControl_Example
//
//  Created by Peter Hauke / 2sox on 25.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import SOXSegmentControl


//MARK: - SimpleTextSegmentControlViewController
class SimpleTextSegmentControlViewController: UIViewController {

    //MARK: - Properties

    //MARK: - IBOutlets
    @IBOutlet private weak var segmentControl: SOXSegmentControl!

    //MARK: - Init&Co.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentControl()
    }

    //MARK: - Action Methods
    
    @IBAction func segmentControllAction(_ sender: SOXSegmentControl) {
        print("Selected segment with index \(sender.selectedSegmentIndex)")
    }

}


//MARK: - Setup 
extension SimpleTextSegmentControlViewController {

    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear
        segmentControl.textPosition = .bottom
        segmentControl.selectorType = .underlineBar

        let titles = ["Segment A",
                      "Segment B",
                      "Segment C"]

        segmentControl.setTitles([titles])
    }

}
