//
//  SOXSegment.swift
//  Tell My Friend
//
//  Created by Peter Hauke on 19.04.20.
//  Copyright © 2020 Peter Hauke. All rights reserved.
//

//  Created by Wasim Malek on 27/05/19.
//  Copyright © 2019 Wasim Malek. All rights reserved.
//

import Foundation
import UIKit


//MARK: - SOXSegmentDescriptor

public struct SOXSegmentDescriptor: Equatable {
    public var title: String?
    public var imageName: String?

    public var selectedTextColor: UIColor?
    public var selectedTintColor: UIColor?
    public var unSelectedTextColor: UIColor?
    public var unSelectedTintColor: UIColor?
    public var selectorColor: UIColor?

    public var selectedFont : UIFont?
    public var unSelectedFont : UIFont?

    public var textPosition: SOXSegmentControl.TextPosition?
    public var selectorType: SOXSegmentControl.SelectorType?
    public var selectorStyle: SOXSegmentControl.SelectorStyle?

    // In case of doublets we need a distinctive marker; 220420, ph
    private let uuid = UUID()

    public static func == (lhs: SOXSegmentDescriptor, rhs: SOXSegmentDescriptor)
        -> Bool {
            return lhs.uuid == rhs.uuid
    }


    public init(title: String? = nil,
                selectedTitleColor: UIColor? = nil,
                unSelectedTitleColor: UIColor? = nil,
                selectedFont : UIFont? = nil,
                unSelectedFont : UIFont? = nil,

                imageName: String? = nil,
                selectedImageColor: UIColor? = nil,
                unSelectedImageColor: UIColor? = nil,

                segmentType: SOXSegmentControl.TextPosition? = nil,

                selectorColor: UIColor? = nil,
                selectorType: SOXSegmentControl.SelectorType? = nil,
                selectorStyle: SOXSegmentControl.SelectorStyle? = nil) {
    }


    public init(title: String? = nil,
                imageName: String? = nil,
                color: UIColor? = nil,
                selectedColor: UIColor? = nil,
                unSelectedColor: UIColor? = nil,
                selectorColor: UIColor? = nil,
                selectorType:  SOXSegmentControl.SelectorType? = nil) {

        self.title = title
        self.imageName = imageName

        self.selectorType = selectorType

        if let allColors = color {
            self.selectedTextColor = allColors
            self.selectedTintColor = allColors
            self.selectorColor = allColors
            self.unSelectedTextColor = allColors
            self.unSelectedTintColor = allColors
        }
        else {
            self.selectedTextColor = selectedColor
            self.selectedTintColor = selectedColor
            self.selectorColor = selectorColor

            self.unSelectedTextColor = unSelectedColor
            self.unSelectedTintColor = unSelectedColor
        }

    }
}

//MARK: -
//MARK: - SOXSegmentControl
open class SOXSegmentControl: UIControl {

    //MARK: Enums
    //TODO: text/imagePosition?
    public enum TextPosition: Int {
        case none
        case right
        case bottom
    }

    public enum SelectorType: Int {
        case none
        case background
        case underlineBar
    }

    public enum SelectorStyle: Int {
        case square
        case round
        case rounded // set selectorCornerRadius
    }

    //MARK: - Lets and Vars
    //MARK: Selector Background Properties
    private var selectorView: UIView = UIView()
    public var animateSelectorMovement: Bool = true
    public var selectorColor: UIColor = .lightGray
    public var selectorStyle: SelectorStyle = .square
    public var selectorType: SelectorType = .background
    public var selectorCornerRadius: CGFloat = 5.0 { didSet { updateSelectorViewStyle() } }
    public var underlineBarSelectorHeight : CGFloat = 5.0  { didSet { updateSelectorViewHeight() } }


    var onValueChanged: ((_ index: Int)->())?
    public var selectedSegmentPath: SOXIndexPath = SOXIndexPath.init(row: 0, column: 0)
    public var selectedSegmentIndex: Int = 0

    public var textPosition: SOXSegmentControl.TextPosition = .right { didSet { updateView() } }

    private var segmentDescriptors: [[SOXSegmentDescriptor]] = [[SOXSegmentDescriptor]]()
    private var linearSegmentDescriptors = [SOXSegmentDescriptor]()



    // UI


    var borderWidth: CGFloat = 0 { didSet { layer.borderWidth = borderWidth } }
    var borderColor: UIColor = .clear { didSet { layer.borderColor = borderColor.cgColor } }
    var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius } }

    var selectedTextColor: UIColor = .label { didSet { updateView() } }
    var selectedTintColor: UIColor = .label { didSet { updateView() } }
    var unSelectedTextColor: UIColor = .lightGray { didSet { updateView() } }
    var unSelectedTintColor: UIColor = .lightGray { didSet { updateView() } }


    var selectedFont : UIFont = UIFont.systemFont(ofSize: 15) { didSet { updateView() } }
    var unSelectedFont : UIFont = UIFont.systemFont(ofSize: 15) { didSet { updateView() } }



    //MARK: - Private Properties
    private var segments = [[SOXSegment]]()
    private var segmentToRow = [SOXSegment : Int]()
    private var segmentCount: Int = 0


    //MARK: - Open Methods
    open override func layoutSubviews() {
        super.layoutSubviews()

        updateView()

        //        let _animated = animateSelectorMovement
        //        animateSelectorMovement = false
        //        setSelectedIndex(selectedSegmentIndex)
        //        animateSelectorMovement = _animated
    }


    open func setSelectedIndexPath(_ newSelectedIndexPath: SOXIndexPath) {

        // Deselect former selected
        updateSegment(atIndexPath: selectedSegmentPath, isSelected: false)

        selectedSegmentPath = newSelectedIndexPath

        // Select new selected
        updateSegment(atIndexPath: selectedSegmentPath, isSelected: true)
    }

    private func updateSegment(atIndexPath indexPath: SOXIndexPath, isSelected: Bool) {
        let segmentToUpdate = segment(forIndexPath: indexPath)

        if isSelected == true {
            segmentToUpdate.tintColor = selectedTintColor(forIndexPath: indexPath)
            segmentToUpdate.titleLabel?.textColor = selectedTextColor(forIndexPath: indexPath)
            segmentToUpdate.titleLabel?.font = selectedFont(forIndexPath: indexPath)
        }
        else {
            segmentToUpdate.tintColor = unSelectedTintColor(forIndexPath: indexPath)
            segmentToUpdate.titleLabel?.textColor = unSelectedTextColor(forIndexPath: indexPath)
            segmentToUpdate.titleLabel?.font = unSelectedFont(forIndexPath: indexPath)
        }

    }



    private func updateSegmentForSelection(indexPath: SOXIndexPath) {

    }

    private func segment(forIndexPath indexPath: SOXIndexPath)
        -> SOXSegment {
            let segmentsForRow = segments[indexPath.row]
            let segment = segmentsForRow[indexPath.column]
            return segment
    }

    open func setSelectedIndex(_ index: Int) {
        fatalError("map to indexpath and call")
//        selectedSegmentIndex = index
//
//        for (index, button) in segments.enumerated() {
//            button.tintColor = unSelectedTintColor(forButtonAtIndex: index)
//            button.setTitleColor(unSelectedTextColor(forButtonAtIndex: index),
//                                 for: .normal)
//
//            // if selectedButton
//            if button.tag == selectedSegmentIndex {
//                // Change Colors
//                button.tintColor = selectedTintColor(forButtonAtIndex: index)
//                button.setTitleColor(selectedTextColor(forButtonAtIndex: index),
//                                     for: .normal)
//
//                // Move underlineBar
//                moveSelectorView(toIndex: index)
//            }
//        }
    }

    open func changeSelectorColor(_ color: UIColor) {
        selectorView.backgroundColor = color
    }

    //MARK: - Private Methods
    private func updateLinearSegmentDescriptors() {
        linearSegmentDescriptors = [SOXSegmentDescriptor]()
        for segmentDescriptorsForRow in segmentDescriptors {
            linearSegmentDescriptors.append(contentsOf: segmentDescriptorsForRow)
        }
    }



    private func updateView() {
        clipsToBounds = true

        subviews.forEach( { $0.removeFromSuperview() } )

        updateSegments()
        arrangeSegments()

        addSubview(selectorView)
    }

    private func arrangeSegments() {

        // Outer StackView
        let outerStackView = UIStackView()
        outerStackView.axis = .vertical
        outerStackView.alignment = .fill
        outerStackView.distribution = .fillEqually

        addSubview(outerStackView)
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        outerStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        outerStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true


        for segmentsForRow in segments {
//            let columnsCount = segmentDescriptorsForRow.count
//            let endCount = startCount + columnsCount - 1
//            let slice = segments[startCount...endCount]
//            startCount = startCount + columnsCount // without - 1!
//
//            let segmentsOfRow:[UIView] = Array(slice)

            let rowStackView = UIStackView(arrangedSubviews: segmentsForRow)
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually//.fillProportionally

            outerStackView.addArrangedSubview(rowStackView)
            //outerStackView.updateConstraints()
            //outerStackView.setNeedsLayout()
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
        }
    }


    private func updateSegments() {

        var newSegments = [[SOXSegment]]()
        var index: Int = 0

        for (row, rowSegmentDescriptors) in segmentDescriptors.enumerated() {
            var rowSegments = [SOXSegment]()

            for (column, segmentDescriptor) in rowSegmentDescriptors.enumerated() {
                let indexPath = SOXIndexPath(row: row, column: column)

                let segment = SOXSegment(indexPath: indexPath, segmentDescriptor: segmentDescriptor)
                segment.tag = index
                segment.tintColor = unSelectedTintColor(forIndexPath: indexPath)

                segment.addTarget(self,
                                  action: #selector(buttonTapped(_:)),
                                  for: .touchUpInside)

                if textPosition(forIndexPath: indexPath) != .none {
                    segment.setTitle(segmentDescriptor.title, for: .normal)
                    segment.setTitleColor(unSelectedTextColor(forIndexPath: indexPath), for: .normal)
                    segment.titleLabel?.font = unSelectedFont(forIndexPath: indexPath)
                    segment.titleLabel?.textAlignment = .center
                }

                if let imageName = segmentDescriptor.imageName {
                    let buttonImage = self.image(name: imageName)
                    segment.setImage(buttonImage, for: .normal)

                    switch textPosition {
                        case .none:
                            break
                        case .right:
                            segment.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                        case .bottom:
                            segment.centerImageAndButton(5, imageOnTop: true)
                    }
                }

                rowSegments.append(segment)

                index += 1
            }
            newSegments.append(rowSegments)
        }

        segments = newSegments
    }

    private func image(name: String)
        -> UIImage? {
            if let image = UIImage(named: name) {
                return image
            }

            if let systemImage = UIImage(systemName: name) {
                return systemImage
            }

            return nil
    }

}

//MARK: - Public Methods
public extension SOXSegmentControl {
    func setSegmentDescriptors(_ newSegmentDescriptors: [[SOXSegmentDescriptor]]) {
        segmentDescriptors = newSegmentDescriptors

        updateLinearSegmentDescriptors()
        updateView()
    }

    func setTitles(_ titles: [[String]]) {
        var newSegmentDescriptors = [[SOXSegmentDescriptor]]()

        for rowTitles in titles {
            var newSegmentDescriptorsForRow = [SOXSegmentDescriptor]()
            for title in rowTitles {
                let segmentDescriptor = SOXSegmentDescriptor(title: title)
                newSegmentDescriptorsForRow.append(segmentDescriptor)
            }
            newSegmentDescriptors.append(newSegmentDescriptorsForRow)
        }

        setSegmentDescriptors(newSegmentDescriptors)
    }

}


//MARK: - Extension - Background Selector View
private extension SOXSegmentControl {

    private func updateSelectorViewBackgroundColor() {
        selectorView.backgroundColor = backgroundColor
    }

    private func updateSelectorViewFrame() {

    }

    private func updateSelectorViewHeight() {
//        if selectorType == .background {
//            let newHeight = (frame.height) / CGFloat(segmentDescriptors.count)
//            selectorView.frame.size.height = newHeight
//        }
//        else if selectorType == .underlineBar {
//
//            moveSelectorView(toIndex: selectedSegmentIndex)
//        }
//
//        updateSelectorViewStyle()
    }

    private func updateSelectorViewStyle() {
        var cornerRadius: CGFloat
        switch selectorStyle {
            case .round:
                cornerRadius = selectorView.frame.height / 2
            case .rounded:
                cornerRadius = selectorCornerRadius
            default:
                cornerRadius = 0
        }

        selectorView.layer.cornerRadius = cornerRadius
    }

    private func moveSelectorView(from fromIndexPath: SOXIndexPath,
                     to toIndexPath: SOXIndexPath) {
        let fromSegment = segment(forIndexPath: fromIndexPath)
        let toSegment = segment(forIndexPath: toIndexPath)

        // move SelectorView
        guard let buttonOrigin = toSegment.superview?.convert(toSegment.frame.origin,
                                                                  to: toSegment.superview?.superview)
            else { fatalError() }

        let newOriginX = buttonOrigin.x
        var newOriginY = buttonOrigin.y
        let newWidth = toSegment.frame.width
        var newHeight = toSegment.frame.height

        if selectorType == .underlineBar {
            newOriginY = newOriginY + toSegment.frame.height - selectorView.frame.height
            newHeight = underlineBarSelectorHeight
        }

        let newUnderlineBarFrame = CGRect(x: newOriginX,
                                          y: newOriginY,
                                          width: newWidth,
                                          height: newHeight)

        var animationDuration: TimeInterval = 0
        if animateSelectorMovement == true {
            animationDuration = 0.25
        }

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { [unowned self] in
                            fromSegment.isSelected = false
                            toSegment.isSelected = true
                            self.selectorView.frame = newUnderlineBarFrame
                            self.selectorView.backgroundColor = self.selectorColor(forIndexPath: toIndexPath) },
                       completion: nil)
    }

}


//MARK: - Extension - Action Methods
extension SOXSegmentControl {

    @objc
    private func buttonTapped(_ sender: SOXSegment) {
        moveSelectorView(from: selectedSegmentPath,
                         to: sender.indexPath)
        selectedSegmentIndex = sender.tag
        selectedSegmentPath = sender.indexPath



        print("\(#function): selectedSegmentIndex: \(selectedSegmentIndex)")
//        for (index, button) in segments.enumerated() {
//            button.tintColor = unSelectedTintColor(forButtonAtIndex: index)
//            button.setTitleColor(unSelectedTextColor(forButtonAtIndex: index),
//                                 for: .normal)
//            button.titleLabel?.font = selectedFont(forButtonAtIndex: index)
//
//            if button == sender {
//                button.tintColor = selectedTintColor(forButtonAtIndex: index)
//                button.setTitleColor(selectedTextColor(forButtonAtIndex: index),
//                                     for: .normal)
//                button.titleLabel?.font = unSelectedFont(forButtonAtIndex: index)
//
////                moveSelectorView(toIndex: index)
//                let indexPath = sender.indexPath
//                moveSelectorView(toIndexPath: indexPath)
//            }
//        }

        onValueChanged?(selectedSegmentIndex)
        sendActions(for: .valueChanged)
    }

}

//MARK: - Extension - SegmentDesciptor handling
extension SOXSegmentControl {
    private func segmentDescriptor(forIndex index: Int)
        -> SOXSegmentDescriptor? {
            guard linearSegmentDescriptors.count >= index
                else { return nil }

            let segmentDescriptor = linearSegmentDescriptors[index]
            return segmentDescriptor
    }

    private func segmentDescriptor(forIndexPath indexPath: SOXIndexPath)
        -> SOXSegmentDescriptor {
            let segmentDescriptorForIndexPath = segmentDescriptor(forRow: indexPath.row,
                                                                  column: indexPath.column)
            return segmentDescriptorForIndexPath
    }

    private func segmentDescriptor(forRow row: Int, column: Int)
        -> SOXSegmentDescriptor {
            let segmentDescriptorsForRow = segmentDescriptors[row]
            let segmentDescriptor = segmentDescriptorsForRow[column]
            return segmentDescriptor
    }


    private func mappedButtonTitles()
        -> [String] {
            let buttonTitles = linearSegmentDescriptors.map { (segmentDescriptor) -> String in
                return segmentDescriptor.title ?? ""
            }

            return buttonTitles
    }

    private func mappedButtonImageNames()
        -> [String] {
            let  buttonImageNames = linearSegmentDescriptors.map { (segmentDescriptor) -> String in
                return segmentDescriptor.imageName ?? ""
            }

            return buttonImageNames
    }


    private func textPosition(forIndexPath indexPath: SOXIndexPath)
        -> TextPosition {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let textPosition = segmentDescriptor.textPosition {
                return textPosition
            }

            return textPosition
    }


    private func selectedTextColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let selectedTextColor = segmentDescriptor.selectedTextColor {
                return selectedTextColor
            }

            return selectedTextColor
    }

    private func selectedTintColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let selectedTintColor = segmentDescriptor.selectedTintColor {
                return selectedTintColor
            }

            return selectedTintColor
    }

    private func unSelectedTextColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let unSelectedTextColor = segmentDescriptor.unSelectedTextColor {
                return unSelectedTextColor
            }

            return unSelectedTextColor
    }

    private func unSelectedTintColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let unSelectedTintColor = segmentDescriptor.unSelectedTintColor {
                return unSelectedTintColor
            }

            return unSelectedTintColor
    }

    private func selectorColor(forIndexPath indexPath: SOXIndexPath)
        -> UIColor {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let selectorColor = segmentDescriptor.selectorColor {
                return selectorColor
            }

            return selectorColor
    }

    private func selectedFont(forIndexPath indexPath: SOXIndexPath)
        -> UIFont {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let selectedFont = segmentDescriptor.selectedFont {
                return selectedFont
            }

            return selectedFont
    }

    private func unSelectedFont(forIndexPath indexPath: SOXIndexPath)
        -> UIFont {
            let segmentDescriptor = self.segmentDescriptor(forIndexPath: indexPath)
            if let unSelectedFont = segmentDescriptor.unSelectedFont {
                return unSelectedFont
            }

            return unSelectedFont
    }

}

//MARK: - SOXButton
open class SOXSegment: UIButton {
    var indexPath: SOXIndexPath
    var segmentDescriptor: SOXSegmentDescriptor

    required public init(indexPath: SOXIndexPath, segmentDescriptor: SOXSegmentDescriptor) {
        self.indexPath = indexPath
        self.segmentDescriptor = segmentDescriptor

        super.init(frame: .zero)
    }

    required public init?(coder: NSCoder) {
        fatalError()
        self.indexPath = SOXIndexPath(row: 0, column: 0)
        super.init(coder: coder)
    }

    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {

        guard let imageView = currentImage,
            let titleLabel = titleLabel?.text
            else { return }

        let sign: CGFloat = imageOnTop ? 1 : -1
        titleEdgeInsets = UIEdgeInsets(top: sign * (imageView.size.height + gap),
                                       left: -imageView.size.width,
                                       bottom: 0,
                                       right: 0);

        let titleSize = titleLabel.size(withAttributes:
            [NSAttributedString.Key.font: self.titleLabel!.font!])

        //TODO: get 'right' correct; 200420, ph
        imageEdgeInsets = UIEdgeInsets(top: sign * -(titleSize.height + gap),
                                       left: 0,
                                       bottom: 0,
                                       right: -titleSize.width - gap)
    }

}


public struct SOXIndexPath {
    var row: Int = 0
    var column: Int = 0
}

