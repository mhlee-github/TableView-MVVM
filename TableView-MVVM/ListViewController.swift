//
//  ListViewController.swift
//  TableView-MVVM
//
//  Created by mhlee on 2018. 5. 10..
//  Copyright © 2018년 mhlee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ListViewController: UIViewController {
  let disposeBag = DisposeBag()
  
  var listViewModel: ListViewModel!
  
  var customView = ListView()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(customView)
    
    customView.snp.makeConstraints { make in
      make.top.left.bottom.right.equalTo(view)
    }
    
    listViewModel = ListViewModel()
    
    bind()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func bind() {
    customView.addButton.rx.tap.subscribe(onNext: {
        self.listViewModel.addNewRow()
      }).disposed(by: disposeBag)

    customView.removeButton.rx.tap
      .subscribe(onNext: {
        self.listViewModel.removeFirstRow()
      }).disposed(by: disposeBag)
    
    listViewModel.strings.bind(to: customView.tableView.rx
      .items(cellIdentifier: ListView.cellIdentifier, cellType: UITableViewCell.self)) {  row, element, cell in
        cell.textLabel?.text = "\(element) \(row)"
      }
      .disposed(by: disposeBag)
  }
}

