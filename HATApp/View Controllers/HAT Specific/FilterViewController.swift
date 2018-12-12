/**
 * Copyright (C) 2018 HAT Data Exchange Ltd
 *
 * SPDX-License-Identifier: MPL2
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

import JTAppleCalendar

class FilterViewController: HATUIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    @IBOutlet private weak var fromDateLabel: UILabel!
    @IBOutlet private weak var toDateLabel: UILabel!
    @IBOutlet private weak var calendarCollectionView: JTAppleCalendarView!
    @IBOutlet private weak var selectDatesButton: UIButton!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var leadingFromDateConstant: NSLayoutConstraint!
    @IBOutlet private weak var trailingFromDateConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateView: UIView!
    
    var firstDate: Date?
    var toDate: Date?
    var selectedRangeIndex: Int = 0
    
    weak var delegate: UpdateDateRangeProtocol?
    
    private var segmentedControl: UISegmentedControl?
    private var dateFormatter = DateFormatter()
    
    private var originalMinXPositionOfFromDateLabel: CGFloat = 0
    private var originalTrailingFromDateLabelConstraing: NSLayoutConstraint?
    var rangeSelectedDates: [Date] = []

    @IBAction func selectDatesButtonAction(_ sender: Any) {
        
        guard let firstDate = self.calendarCollectionView.selectedDates.first,
            let lastDate = self.calendarCollectionView.selectedDates.last else {
                
                return
        }
        
        FeedbackManager.vibrateWithHapticIntensity(type: .light)
        
        let startDate = Date.startOfDate(date: firstDate)
        let endDate = Date.endOfDate(date: lastDate)!
        
        delegate?.newDateRangeSelected(from: startDate, to: endDate)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        
        self.calendarCollectionView.allowsMultipleSelection = true
        self.calendarCollectionView.isRangeSelectionUsed = true
        self.segmentedControl?.setEnabled(true, forSegmentAt: 1)
        self.segmentedControl?.selectedSegmentIndex = 1
        
        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = self.calendarCollectionView.selectedDates
        
        if let cellState = self.calendarCollectionView.cellStatus(at: point) {
            
            let date = cellState.date
            if rangeSelectedDates.isEmpty {
                
                rangeSelectedDates.append(date)
            }
            if !rangeSelectedDates.contains(date) {
                
                let dateRange: [Date]
                if date > rangeSelectedDates.first! {
                    
                    dateRange = self.calendarCollectionView.generateDateRange(from: rangeSelectedDates.first ?? date, to: date).sorted()
                } else {
                    
                    dateRange = self.calendarCollectionView.generateDateRange(from: date, to: rangeSelectedDates.first ?? date).sorted()
                }
                for aDate in dateRange {
                    
                    if !rangeSelectedDates.contains(aDate) {
                        
                        rangeSelectedDates.append(aDate)
                    }
                }
                let temp = self.rangeSelectedDates.sorted()
                self.rangeSelectedDates = temp
                self.calendarCollectionView.selectDates(from: rangeSelectedDates.first!, to: rangeSelectedDates.last!, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
                self.rangeChanged()
            } else {
                
                let firstDate = self.rangeSelectedDates.first!
                self.rangeSelectedDates.removeAll()
                self.calendarCollectionView.selectDates(from: firstDate, to: date, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
                self.rangeSelectedDates = self.calendarCollectionView.selectedDates
                self.rangeChanged()
            }
        }
        
    }
    
    private func setupCalendar(allowsMultipleSelection: Bool) {
        
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        self.calendarCollectionView.addGestureRecognizer(panGensture)
        self.calendarCollectionView.allowsMultipleSelection = allowsMultipleSelection
        self.calendarCollectionView.isRangeSelectionUsed = allowsMultipleSelection
        
        self.calendarCollectionView.minimumInteritemSpacing = 0
        self.calendarCollectionView.minimumLineSpacing = 0
        self.calendarCollectionView.sectionInset = .zero
        self.calendarCollectionView.scrollingMode = .none

        /// calculate the correct width in order to hide the silly white lines between the cells
        let width = UIScreen.main.bounds.width
        let cellWidth = CGFloat(width / 7).rounded()
        self.calendarCollectionView.frame.size.width = cellWidth * 7
        self.calendarCollectionView.cellSize = cellWidth
        
        self.calendarCollectionView.register(viewClass: MonthHeaderCollectionReusableView.self, forDecorationViewOfKind: UICollectionElementKindSectionHeader)
        self.calendarCollectionView.deselectAllDates()
        self.calendarCollectionView.reloadData()
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CellIdentifiersConstants.calendarCell, for: indexPath) as? CalendarCollectionViewCell else {
            
            return
        }
        
        if self.segmentedControl?.selectedSegmentIndex == 0 && self.calendarCollectionView.selectedDates.count > 1 {

            self.calendarCollectionView.deselectAllDates()
            let fromDate = FormatterManager.formatDateStringToUsersDefinedDate(date: self.firstDate!, dateStyle: .short, timeStyle: .none)
            self.fromDateLabel.text = fromDate
            self.toDateLabel.text = fromDate
            self.calendarCollectionView.selectDates([self.firstDate!])
        }
        
        cell.dateLabel.text = cellState.text
        
        self.handleSelectionViewColor(view: cell, cellState: cellState)
        self.handleLabelTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CellIdentifiersConstants.calendarCell, for: indexPath) as? CalendarCollectionViewCell else {
            
            return calendar.dequeueReusableJTAppleCell(withReuseIdentifier: CellIdentifiersConstants.calendarCell, for: indexPath)
        }
        
        if self.segmentedControl?.selectedSegmentIndex == 0 && self.calendarCollectionView.selectedDates.count > 1 {

            self.calendarCollectionView.deselectAllDates()
            let fromDate = FormatterManager.formatDateStringToUsersDefinedDate(date: self.firstDate!, dateStyle: .short, timeStyle: .none)
            self.fromDateLabel.text = fromDate
            self.toDateLabel.text = fromDate
            self.calendarCollectionView.selectDates([self.firstDate!])
        }
        
        cell.dateLabel.text = cellState.text
        
        self.handleSelectionViewColor(view: cell, cellState: cellState)
        self.handleLabelTextColor(view: cell, cellState: cellState)

        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard cellState.dateBelongsTo == .thisMonth else { return }

        if self.segmentedControl?.selectedSegmentIndex == 1 {

            self.calendarCollectionView.allowsMultipleSelection = true
            self.calendarCollectionView.isRangeSelectionUsed = true
            
            var dates = self.calendarCollectionView.selectedDates.sorted()
            let rangeDates = self.calendarCollectionView.generateDateRange(from: dates.first!, to: dates.last!)
            let datesToDeselect = dates.filter({ filterDate in
                
                if rangeDates.contains(filterDate) {
                    
                    return false
                } else {
                    
                    return true
                }
            })
            
            calendarCollectionView.deselect(dates: datesToDeselect, triggerSelectionDelegate: false)
            dates = rangeDates
            dates = dates.sorted()

            self.firstDate = Date.startOfDate(date: dates.first!)
            self.toDate = Date.endOfDate(date: dates.last!)

            calendar.selectDates(from: dates.first!, to: dates.last!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            self.calendarCollectionView.reloadData()

            let fromDate = FormatterManager.formatDateStringToUsersDefinedDate(date: dates.first!, dateStyle: .short, timeStyle: .none)
            self.fromDateLabel.text = fromDate
            let endOfLastDate = Date.endOfDate(date: dates.last!)!
            let toDate = FormatterManager.formatDateStringToUsersDefinedDate(date: endOfLastDate, dateStyle: .short, timeStyle: .none)
            self.toDateLabel.text = toDate
        } else {

            self.calendarCollectionView.allowsMultipleSelection = false
            self.calendarCollectionView.isRangeSelectionUsed = false
            self.firstDate = Date.startOfDate(date: date)
            self.toDate = Date.endOfDate(date: date)

            let fromDate = FormatterManager.formatDateStringToUsersDefinedDate(date: self.firstDate!, dateStyle: .short, timeStyle: .none)
            self.fromDateLabel.text = fromDate
            self.toDateLabel.text = fromDate
        }
        
        self.handleSelectionViewColor(view: cell, cellState: cellState)
        self.handleLabelTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        guard cellState.dateBelongsTo == .thisMonth else { return }
        
        if self.segmentedControl?.selectedSegmentIndex == 1 {
            
            var dates = self.calendarCollectionView.selectedDates
            
            if dates.isEmpty {
                
                dates.append(date)
            }
            
            var rangeDates = self.calendarCollectionView.generateDateRange(from: dates.first!, to: date)
            let datesToDeselect = dates.filter({ filterDate in
                
                if rangeDates.contains(filterDate) {
                    
                    return false
                } else {
                    
                    return true
                }
            })
            
            if datesToDeselect.isEmpty || rangeDates.isEmpty {
                
                calendarCollectionView.deselectAllDates(triggerSelectionDelegate: false)
                rangeDates.removeAll()
                calendar.selectDates([date], triggerSelectionDelegate: true)
                dates = [date]
            } else if !rangeDates.isEmpty {
                
                dates = rangeDates
                dates = dates.sorted()
                calendarCollectionView.deselect(dates: datesToDeselect, triggerSelectionDelegate: false)
                calendar.selectDates(from: dates.first ?? Date(), to: dates.last ?? Date(), triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
            }
            
            self.calendarCollectionView.reloadData()
            self.firstDate = Date.startOfDate(date: dates.first ?? Date())
            self.toDate = Date.endOfDate(date: dates.last ?? Date())
            
            let fromDate = FormatterManager.formatDateStringToUsersDefinedDate(date: self.firstDate ?? Date(), dateStyle: .short, timeStyle: .none)
            self.fromDateLabel.text = fromDate
            
            let endOfLastDate = Date.endOfDate(date: date)!
            let toDate = FormatterManager.formatDateStringToUsersDefinedDate(date: endOfLastDate, dateStyle: .short, timeStyle: .none)
            self.toDateLabel.text = toDate
        }
        
        self.handleSelectionViewColor(view: cell, cellState: cellState)
        self.handleLabelTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        
        let cell = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "monthCalendarHeader", for: indexPath) as? MonthHeaderCollectionReusableView
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.string(from: range.start)
        
        cell?.monthLabel.text = startDate
        
        return cell!
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        
        return MonthSize(defaultSize: 40)
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "2016 01 01")!
        let endDate = dateFormatter.date(from: "2020 12 31")!
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 0, calendar: nil, generateInDates: InDateCellGeneration.forAllMonths, generateOutDates: OutDateCellGeneration.off, firstDayOfWeek: .monday, hasStrictBoundaries: true)
    }
    
    private func handleTodayIndicator(cellState: CellState, view: CalendarCollectionViewCell) {
        
        if Date.startOfDate(date: cellState.date) == Date.startOfDate() && cellState.dateBelongsTo == .thisMonth {
            
            if view.selectionView.isHidden {
                
                view.selectionView.isHidden = false
                view.backgroundColor = .clear
                if view.selectionView.layer.cornerRadius == 0 {
                    
                    view.selectionView.layer.cornerRadius = 15
                }
            }
            view.selectionView.addBorder(width: 1, color: .calendarSelectedRangeSelectionColor)
        }
    }
    
    private func handleSelectionViewColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let view = view as? CalendarCollectionViewCell else {
            
            return
        }
        
        view.selectionView.isHidden = true
        view.selectionView.backgroundColor = .clear
        view.selectionView.layer.cornerRadius = 0
        view.selectionView.layer.mask = nil
        view.selectionView.addBorder(width: 0, color: nil)
        
        guard cellState.dateBelongsTo == .thisMonth else {
            
            return
        }

        switch cellState.selectedPosition() {

        case .left:

            view.selectionView.isHidden = false
            view.selectionView.backgroundColor = UIColor.calendarSelectedRangeSelectionColor
            view.selectionView.roundCorners(roundingCorners: [.topLeft, .bottomLeft], cornerRadious: 15, bounds: view.bounds)
        case .right:

            view.selectionView.isHidden = false
            view.selectionView.backgroundColor = UIColor.calendarSelectedRangeSelectionColor
            view.selectionView.roundCorners(roundingCorners: [.topRight, .bottomRight], cornerRadious: 15, bounds: view.bounds)
        case .full:

            view.selectionView.isHidden = false
            view.selectionView.backgroundColor = UIColor.calendarSelectedRangeSelectionColor
            view.selectionView.layer.cornerRadius = 15
        case .middle:

            view.selectionView.isHidden = false
            view.selectionView.backgroundColor = UIColor.calendarSelectedRangeSelectionColor
            view.selectionView.layer.cornerRadius = 0
        default:

            view.selectionView.isHidden = true
            view.selectionView.backgroundColor = .none
            view.selectionView.layer.cornerRadius = 0
        }
        
        self.handleTodayIndicator(cellState: cellState, view: view)
    }
    
    private func handleLabelTextColor(view: JTAppleCell?, cellState: CellState) {
        
        guard let view = view as? CalendarCollectionViewCell else {
            
            return
        }
        
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth {
            
            view.dateLabel.textColor = .white
        } else if cellState.dateBelongsTo != .thisMonth {
            
            view.dateLabel.textColor = .hatGrayBackground
        } else {

            view.dateLabel.textColor = .sectionTextColor
        }
    }
    
    @objc
    private func rangeChanged() {

        //self.calendarCollectionView.deselectAllDates(triggerSelectionDelegate: true)
        if self.segmentedControl?.selectedSegmentIndex == 0 {
            
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: .beginFromCurrentState,
                animations: { [weak self] in
                
                    guard let weakSelf = self else {
                        
                        return
                    }
                    
                    let xPos = weakSelf.view.frame.midX - (weakSelf.fromDateLabel.frame.width / 2)
                    weakSelf.fromDateLabel.frame.origin.x = xPos
                    weakSelf.leadingFromDateConstant.constant = xPos
                    weakSelf.trailingFromDateConstraint.isActive = false
                },
                completion: nil)
            self.arrowImageView.isHidden = true
            self.toDateLabel.isHidden = true
            
            self.calendarCollectionView.reloadData()
        } else {
            
            if self.calendarCollectionView.selectedDates.count == 1 {
                
                self.calendarCollectionView.deselectAllDates()
                self.calendarCollectionView.reloadData()
            }
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: .beginFromCurrentState,
                animations: { [weak self] in
                    
                    guard let weakSelf = self else {
                        
                        return
                    }
                    
                    weakSelf.fromDateLabel.frame.origin.x = weakSelf.originalMinXPositionOfFromDateLabel
                    weakSelf.leadingFromDateConstant.constant = weakSelf.originalMinXPositionOfFromDateLabel
                    weakSelf.trailingFromDateConstraint = weakSelf.originalTrailingFromDateLabelConstraing
                    weakSelf.trailingFromDateConstraint.isActive = true
                },
                completion: nil)
            self.arrowImageView.isHidden = false
            self.toDateLabel.isHidden = false
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setNavigationBarColorToDarkBlue()
        
        if self.firstDate == nil {
            
            self.firstDate = Date.startOfDate(date: Date())
        }
        if self.toDate == nil {
            
            self.toDate = Date.endOfDate()
        }
        let fromDate = FormatterManager.formatDateStringToUsersDefinedDate(date: self.firstDate!, dateStyle: .short, timeStyle: .none)
        let toDate = FormatterManager.formatDateStringToUsersDefinedDate(date: self.toDate!, dateStyle: .short, timeStyle: .none)
        self.fromDateLabel.text = fromDate
        self.toDateLabel.text = toDate
        
        self.segmentedControl = UISegmentedControl(items: ["Single date", "Date range"])
        self.segmentedControl?.frame.origin.y = 0
        self.segmentedControl?.sizeToFit()
        self.segmentedControl?.addTarget(self, action: #selector(rangeChanged), for: .valueChanged)
        self.segmentedControl?.tintColor = .white
        self.segmentedControl?.selectedSegmentIndex = 0;
        self.segmentedControl?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.avenirRegular(ofSize: 12)],
                                       for: .normal)
        self.segmentedControl?.layer.cornerRadius = 15.0;
        self.segmentedControl?.layer.borderColor = UIColor.white.cgColor
        self.segmentedControl?.layer.borderWidth = 1.0
        self.segmentedControl?.layer.masksToBounds = true
        self.segmentedControl?.selectedSegmentIndex = self.selectedRangeIndex
        self.segmentedControl?.setWidth(90, forSegmentAt: 0)
        self.segmentedControl?.setWidth(90, forSegmentAt: 1)
        
        self.selectDatesButton.layer.cornerRadius = 5
        
        self.dateView.addShadow(color: .lightGray, shadowRadius: 1, shadowOpacity: 1, width: 0, height: 1.5)
        
        self.navigationItem.titleView = self.segmentedControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if self.selectedRangeIndex == 0 {
            
            self.setupCalendar(allowsMultipleSelection: false)
        } else {
            
            self.setupCalendar(allowsMultipleSelection: true)
        }
        
        self.calendarCollectionView.selectDates([self.firstDate!, self.toDate!], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
        
        self.originalMinXPositionOfFromDateLabel = self.fromDateLabel.frame.minX
        self.originalTrailingFromDateLabelConstraing = self.trailingFromDateConstraint
        
        self.rangeChanged()
        
        if self.firstDate != nil {
            
            self.calendarCollectionView.scrollToDate(self.firstDate!, triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
        } else {
            
            self.calendarCollectionView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
