//
//  SampleListViewController.swift
//  frameproject
//
//  Created by Quang Trinh on 15/08/2023.
//

import UIKit

class SampleListViewController: ViewController {
    

    var presenter: SampleListPresenterProtocol!
    let searchTxtField: UITextField = UITextField()
    var sampleObjectList: [SampleNameCellModel] {
        get {
            return presenter.sampleObjectList
        }
    }
    let tableView = TableView.init(frame: CGRect.init(x: 0, y: 0, width: ViewUtility.screenSize().width, height: ViewUtility.screenSize().height), style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(SampleListViewController.storyBoardId())
        tableView.addRefreshHeader {[weak self] in
            if let weakSelf = self {
                weakSelf.presenter.reloadData()
            }
        }
        tableView.addLoadMoreFooter {[weak self] in
            if let weakSelf = self {
                weakSelf.presenter.loadMore()
            }
        }
        presenter.viewDidLoad()
        searchTxtField.textPublisher.
    }
    
    override func setupView() {
        super.setupView()
        tableView.backgroundColor = DSColor.white.value
        tableView.separatorStyle = .none
        view.addSubviewForLayout(tableView)
        NSLayoutConstraint.activate([tableView.alignTop(to: view.safeAreaLayoutGuide),
                                     tableView.alignLeading(to: view.safeAreaLayoutGuide),
                                     tableView.alignBottom(to: view.safeAreaLayoutGuide),
                                     tableView.alignTrailing(to: view.safeAreaLayoutGuide)])
        tableView.setSelfSizingRowHeight(with: NameTableViewCell.getCellEstimatedHeight(viewModel: nil))
        tableView.register(NameTableViewCell.self, forCellReuseIdentifier: NameTableViewCell.cellIdentifier())
        tableView.setNumberOfSection(1)
        tableView.setNumberOfRows {[weak self] section in
            if let weakSelf = self {
                return weakSelf.sampleObjectList.count
            }
            return  0
        }
        tableView.setCellForRows {[weak self] indexPath in
            if let weakSelf = self,
               indexPath.row < weakSelf.sampleObjectList.count {
                let model = weakSelf.sampleObjectList[indexPath.row]
                let cell = weakSelf.tableView.dequeueReusableCell(withIdentifier: NameTableViewCell.cellIdentifier(), for: indexPath) as! NameTableViewCell
                cell.setup(viewModel: model)
                return cell
            }
            return UITableViewCell()
        }
        tableView.setDidSelectRowBlock {[weak self] indexPath in
            if let weakSelf = self,
               indexPath.row < weakSelf.sampleObjectList.count,
               let modelId = weakSelf.sampleObjectList[indexPath.row].id{
                weakSelf.presenter.showDetail(sampleId: modelId)
            }
        }
    }
    
    override class func storyBoardName() -> String {
        return "SampleList"
    }

}

extension SampleListViewController: SampleListViewProtocol {
    
    
    func updateView() {
        tableView.reloadData()
    }
    
    func beginRefreshing() {
        tableView.headerBeginRefreshing()
    }
    
    func endRefreshing() {
        tableView.headerEndRefreshing()
    }
    
    func endLoadMore() {
        tableView.footerEndRefreshing()
    }
    
    
}
