//
//  TableView.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import UIKit

class TableView: UITableView {
    enum CustomError: Error {
        
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        dataSource = self
        delegate = self
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ViewUtility.screenSize().width, height: 0.1))
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ViewUtility.screenSize().width, height: 0.1))
        tableHeaderView = headerView
        tableFooterView = footerView
        setSelfSizingHeaderHeight(with: 0.1)
        setSelfSizingFooterHeight(with: 0.1)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        dataSource = self
        delegate = self
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ViewUtility.screenSize().width, height: 0.1))
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ViewUtility.screenSize().width, height: 0.1))
        headerView.backgroundColor = UIColor.clear
        footerView.backgroundColor = UIColor.clear
        tableHeaderView = headerView
        tableFooterView = footerView
        setSelfSizingHeaderHeight(with: 0.1)
        setSelfSizingFooterHeight(with: 0.1)
    }
    
    private var customNumberOfSection: Int = 1
    
    
    private var numberOfRowsBlock: ((_ section: Int) -> (Int)) = { section  in
        return 0
    }
    
    private var cellForRowsBlock: ((_ indexPath: IndexPath) -> (UITableViewCell)) = { indexPath in
        return UITableViewCell()
    }
    
    private var headerViewBlock: ((_ section: Int) -> (UITableViewHeaderFooterView?)) = { section in
        return nil
    }
    
    private var footerViewBlock: ((_ section: Int) -> (UITableViewHeaderFooterView?)) = { section in
        return nil
    }
    
    private var didSelectRowBlock: ((_ indexPath: IndexPath) -> ()) = { indexPath in
        
    }
    
    func setNumberOfSection(_ value: Int){
        self.customNumberOfSection = value
    }
    
    func setNumberOfRows(logic: @escaping ((_ section: Int) -> (Int))) {
        numberOfRowsBlock = logic
    }
    func setCellForRows(logic: @escaping ((_ indexPath: IndexPath) -> (UITableViewCell))) {
        cellForRowsBlock = logic
    }
    func setHeaderViewBlock(logic: @escaping ((_ section: Int) -> (UITableViewHeaderFooterView?))) {
        headerViewBlock = logic
    }
    func setFooterViewBlock(logic: @escaping ((_ section: Int) -> (UITableViewHeaderFooterView?))) {
        footerViewBlock = logic
    }
    
    func setDidSelectRowBlock(logic: @escaping ((_ indexPath: IndexPath) -> ())) {
        didSelectRowBlock = logic
    }
    /// If you want to set self sizing table view cell, use setSelfSizingRowHeight, this is just for hard-fixed row height, please don't set value to automaticDimension or 0
    func setFixedRowHeight(_ height: CGFloat) {
        rowHeight = height
        estimatedRowHeight = UITableView.automaticDimension
    }
    
    /// If you want to set fixed height table view cell, use setFixedRowHeight, this is function for self sizing cell, please don't set estimatedHeight to 0 or automaticDimension
    func setSelfSizingRowHeight(with estimatedHeight: CGFloat) {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = estimatedHeight
    }
    
    /// If you want to set self sizing table view header view, use setSelfSizingRowHeight, this is just for hard-fixed row height, please don't set value to automaticDimension or 0
    func setFixedHeaderHeight(_ height: CGFloat) {
        sectionHeaderHeight = height
        estimatedSectionHeaderHeight = UITableView.automaticDimension
    }
    
    /// If you want to set fixed height table view header view, use setFixedRowHeight, this is function for self sizing cell, please don't set estimatedHeight to 0 or automaticDimension
    func setSelfSizingHeaderHeight(with estimatedHeight: CGFloat) {
        sectionHeaderHeight = UITableView.automaticDimension
        estimatedSectionHeaderHeight = estimatedHeight
    }
    
    /// If you want to set self sizing table view footer view, use setSelfSizingRowHeight, this is just for hard-fixed row height, please don't set value to automaticDimension or 0
    func setFixedFooterHeight(_ height: CGFloat) {
        sectionFooterHeight = height
        estimatedSectionFooterHeight = UITableView.automaticDimension
    }
    
    /// If you want to set fixed height table view footer view, use setFixedRowHeight, this is function for self sizing cell, please don't set estimatedHeight to 0 or automaticDimension
    func setSelfSizingFooterHeight(with estimatedHeight: CGFloat) {
        sectionFooterHeight = UITableView.automaticDimension
        estimatedSectionFooterHeight = estimatedHeight
    }
}

extension TableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return customNumberOfSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsBlock(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRowsBlock(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerViewBlock(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerViewBlock(section)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowBlock(indexPath)
    }
}



