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
    @IBOutlet weak var selectorColorSegmentControl: SOXSegmentControl!
    @IBOutlet weak var textPositionSegmentControl: SOXSegmentControl!
    @IBOutlet weak var animateSelectorMovementSegmentControl: SOXSegmentControl!

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
        else if sender == selectorColorSegmentControl {
            // nothing here - see onValueChange-Block in setupSettingsSegmentControls()
        }
        else if sender == textPositionSegmentControl {
            if let textPosition = SOXSegmentControl.TextPosition.init(rawValue: selectedSegmentIndex) {
                segmentControl.textPosition = textPosition
            }
        }
        else if sender == animateSelectorMovementSegmentControl {
            let animate = selectedSegmentIndex == 1 ? true : false 
            segmentControl.selectorMovementAnimated = animate
        }
    }

}


//MARK: - Setup
extension ComplexSegmentControlViewController {

    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear
        

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
        let selectorTypeColumn = segmentControl.selectorType.rawValue
        selectorTypeSegmentControl.selectedSegmentPath = SOXIndexPath(row: 0, column: selectorTypeColumn)

        // selectorStyle
        selectorStyleSegmentControl.selectorType = .underlineBar
        selectorStyleSegmentControl.setTitles([["square", "round", "rounded"]])
        let selectorStyleColumn = segmentControl.selectorStyle.rawValue
        selectorStyleSegmentControl.selectedSegmentPath = SOXIndexPath(row: 0, column: selectorStyleColumn)

        // selectorColor
        selectorColorSegmentControl.selectorType = .underlineBar
        selectorColorSegmentControl.setTitles([["darkgrey", "lightgrey", "red"]])
        selectorColorSegmentControl.selectedSegmentPath = SOXIndexPath(row: 0, column: 1)
        selectorColorSegmentControl.onValueChanged = { [unowned self] selectedIndex in
            var selectorColor: UIColor = .systemRed
            switch selectedIndex {
                case 0:
                    selectorColor = .darkGray
                case 1:
                    selectorColor = .lightGray
                default:
                    break
            }
            self.segmentControl.selectorColor = selectorColor
        }

        // textPosition
        textPositionSegmentControl.selectorType = .underlineBar
        textPositionSegmentControl.setTitles([["none", "right", "bottom"]])
        let textPositionColumn = segmentControl.textPosition.rawValue
        textPositionSegmentControl.selectedSegmentPath = SOXIndexPath(row: 0, column: textPositionColumn)

        // animateSelectorMovement
        animateSelectorMovementSegmentControl.selectorType = .underlineBar
        animateSelectorMovementSegmentControl.setTitles([["false", "true"]])
        let animateSelectorMovementColumn = segmentControl.selectorMovementAnimated == true ? 1 : 0
        animateSelectorMovementSegmentControl.selectedSegmentPath = SOXIndexPath(row: 0, column: animateSelectorMovementColumn)




    }
}
