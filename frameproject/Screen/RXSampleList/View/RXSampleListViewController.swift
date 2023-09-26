//
//  RXSampleListViewController.swift
//  frameproject
//
//  Created by Quang Trinh on 19/09/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RXSampleListViewController: ViewController {
    
    var textField: UITextField = UITextField()
    var tableView: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ViewUtility.screenSize().width, height: 0), style: .plain)
    var sampleObjectList: BehaviorRelay<[RxSampleObject]> = BehaviorRelay<[RxSampleObject]>.init(value: [])
    lazy var listViewModel : RxSampleListViewModelProtocol = RxSampleListViewModel(items: sampleObjectList)
    let disposeBag = DisposeBag()
    var currentId: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listViewModel.setAPIService(MockAPIServiceManager())
        tableView.addRefreshHeader {[weak self] in
            if let `self` = self {
                self.listViewModel.reloadData()
            }
        }
        tableView.addLoadMoreFooter {[weak self] in
            if let `self` = self {
                self.listViewModel.loadMore()
            }
        }
            
        bindData()
        tableView.headerBeginRefreshing()
    }
    
    func renderView(state: RxSampleListViewState) {
        switch state {
        case .initiate:
            tableView.reloadData()
        case .reloading:
            break;
        case .onEmpty:
            tableView.reloadData()
        case .loadMore:
            break;
        case .endReloading:
            tableView.headerEndRefreshing()
        case .endLoadMore:
            tableView.footerEndRefreshing()
        case .onError(statusCode: _, errorMsg: _):
            break;
        case .showResult:
            break;
        }
    }
    override func setupView() {
        super.setupView()
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.delegate = self
        textField.placeholder = "Please enter object name"
        view.addSubviewForLayout(textField)
        NSLayoutConstraint.activate([textField.alignTop(to: view.safeAreaLayoutGuide, space: DSSpacing.margin.rawValue),
                                     textField.alignLeading(to: view!, space: DSSpacing.margin.rawValue),
                                     view.alignTrailing(to: textField, space: DSSpacing.margin.rawValue),
                                     textField.configHeight(40)
                                    ])
        
        view.addSubviewForLayout(tableView)
        NSLayoutConstraint.activate([tableView.spacingTop(to: textField, space: DSSpacing.viewSpace.rawValue),
                                     tableView.alignLeading(to: view!),
                                     view.alignTrailing(to: tableView),
                                     view.safeAreaLayoutGuide.alignBottom(to: tableView)
                                    ])
        tableView.register(NameTableViewCell.self, forCellReuseIdentifier: NameTableViewCell.cellIdentifier())
        tableView.estimatedRowHeight = NameTableViewCell.getCellEstimatedHeight(viewModel: nil)
        tableView.rowHeight = UITableView.automaticDimension
        tableView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    
    
    func bindData() {
        listViewModel.itemsObservable
            .bind(to: tableView
                .rx
                .items(cellIdentifier: NameTableViewCell.cellIdentifier(),
                       cellType: NameTableViewCell.self)) {row, sampleObject, cell in
                cell.distributeSampleNameCellModel(viewModel: RxSampleNameCellModel.init(sample: sampleObject))
            }.disposed(by: disposeBag)
        
        listViewModel.stateObservable
            .subscribe({[weak self] event in
                if event.error == nil {
                    if let state = event.element,
                        let `self` = self {
                        self.renderView(state: state)
                    }
                }
            })
            .disposed(by: disposeBag)
        tableView.rx
            .modelSelected(RxSampleObject.self)
            .subscribe({[weak self] event in
                if let `self` = self,
                   let navigationController = self.navigationController,
                    let sampleObject = event.element {
                    self.listViewModel.pushSampleDetail(sampleObject.id, from: navigationController)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateListView() {
        tableView.reloadData()
    }

}

extension RXSampleListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0 {
            let newItem = RxSampleObject.init(id: currentId, name: text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            currentId += 1
            listViewModel.addItem(newItem)
            textField.resignFirstResponder()
            textField.text = nil
        }
        return true
        
    }
}

extension RXSampleListViewController: UITableViewDelegate {
    
}
