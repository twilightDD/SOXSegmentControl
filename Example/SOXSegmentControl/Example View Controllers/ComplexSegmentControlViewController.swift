//
//  ComplexSegmentControlViewController.swift
//  SOXSegmentControl
//
//  Created by Peter Hauke on 25.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import SOXSegmentControl

class ComplexSegmentControlViewController: UIViewController {

    //MARK: - Properties

    //MARK: - IBOutlets
    @IBOutlet private weak var segmentControl: SOXSegmentControl!

    // Setting SegmentControls
    @IBOutlet weak var selectorTypeSegmentControl: SOXSegmentControl!
    @IBOutlet weak var selectorStyleSegmentControl: SOXSegmentControl!


    //MARK: - Init&Co.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentControl()

        setupSettingsSegmentControls()
    }

    //MARK: - Action Methods

    @IBAction func segmentControllAction(_ sender: SOXSegmentControl) {
        print("Selected segment with index \(sender.selectedSegmentIndex)")
        let selectedSegmentIndex = sender.selectedSegmentIndex
        if sender == selectorTypeSegmentControl {
            if let selectorType = SOXSegmentControl.SelectorType.init(rawValue: selectedSegmentIndex) {
                segmentControl.selectorType = selectorType
            }
        }
        else if sender == selectorStyleSegmentControl {
            if let selectorStyle = SOXSegmentControl.SelectorStyle.init(rawValue: selectedSegmentIndex) {
                segmentControl.selectorStyle = selectorStyle
            }
        }
    }

}


//MARK: - Setup
extension ComplexSegmentControlViewController {

    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear

        segmentControl.textPosition = .bottom

        segmentControl.selectorColor = .lightGray

        segmentControl.selectedTextColor = .label
        segmentControl.unSelectedTextColor = .darkGray
        segmentControl.selectorType = .underlineBar



        let segments = [SOXSegmentDescriptor(title: "Segment A",
                                             imageName: "a.circle"),
                        SOXSegmentDescriptor(title: "Segment B",
                                             imageName: "b.circle"),
                        SOXSegmentDescriptor(title: "Segment C",
                                             imageName: "c.circle")]

        let segments2 = [SOXSegmentDescriptor(title: "Segment D",
                                              imageName: "d.circle"),
                         SOXSegmentDescriptor(title: "Segment E",
                                              imageName: "e.circle"),
                         SOXSegmentDescriptor(title: "Segment F",
                                              imageName: "f.circle")]

        let segments3 = [SOXSegmentDescriptor(title: "Segment G",
                                              imageName: "g.circle"),
                         SOXSegmentDescriptor(title: "Segment H",
                                              imageName: "h.circle"),
                         SOXSegmentDescriptor(title: "Segment I",
                                              imageName: "i.circle")]

        
        segmentControl.setSegmentDescriptors([segments,
                                              segments2,
                                              segments3])
    }

}


extension ComplexSegmentControlViewController {
    private func setupSettingsSegmentControls() {
        // selectorType
        selectorTypeSegmentControl.selectorType = .underlineBar
        selectorTypeSegmentControl.setTitles([["none", "background", "underline"]])
        selectorTypeSegmentControl.selectedSegmentPath = SOXIndexPath(row: 0, column: 2)

        // selectorStyle
        selectorStyleSegmentControl.selectorStyle = .square
        selectorStyleSegmentControl.setTitles([["square", "round", "rounded"]])
        selectorStyleSegmentControl.selectedSegmentPath = SOXIndexPath(row: 0, column: 0)



    }
}
