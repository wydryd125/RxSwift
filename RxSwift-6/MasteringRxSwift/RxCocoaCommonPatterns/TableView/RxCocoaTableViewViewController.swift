//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit
import RxSwift
import RxCocoa

// RxSwift는 delegate 연결X
class RxCocoaTableViewViewController: UIViewController {
  
  @IBOutlet weak var listTableView: UITableView!
  
  let priceFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = NumberFormatter.Style.currency
    f.locale = Locale(identifier: "Ko_kr")
    
    return f
  }()
  
  let bag = DisposeBag()
  
  let nameObservable = Observable.of(appleProducts.map { $0.name })
  
  let productObservable = Observable.of(appleProducts)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    // #1 - tableView를 반환하여 cell을 closer에서 만들어준다.
//    nameObservable.bind(to: listTableView.rx.items) { tableview, row, element in
//      let cell = tableview.dequeueReusableCell(withIdentifier: "standardCell")!
//      cell.textLabel?.text = element
//      return cell
//    }
//    .disposed(by: bag)
    
    // #2 - #1와 비슷하지만 다르다. cell만 반환하는 방식으로 closer에서 cell을 구현해준다.
//    nameObservable.bind(to: listTableView.rx.items(cellIdentifier: "standardCell")) { row, element, cell in
//      cell.textLabel?.text = element
//    }
//    .disposed(by: bag)
   
    // 3#
    productObservable.bind(to: listTableView.rx.items(cellIdentifier: "productCell", cellType: ProductTableViewCell.self)) { [weak self] row, element, cell in
      
      cell.categoryLabel.text = element.category
      cell.productNameLabel.text = element.name
      cell.summaryLabel.text = element.summary
      cell.priceLabel.text = self?.priceFormatter.string(from: element.price as NSNumber)
    }
    .disposed(by: bag)
    
    //modelSelected - 선택 이벤트를 처리하면서 데이터가 필요 시 활용
//    listTableView.rx.modelSelected(Product.self)
//      .subscribe(onNext: { product in
//        print(product.name)
//      })
//      .disposed(by: bag)
//
    //itemDeselected - indexPaht가 필요하다면 활용
//    listTableView.rx.itemDeselected
//      .subscribe(onNext: { [weak self] indexPath in
//        self?.listTableView.deselectRow(at: indexPath, animated: true)
//      })
//      .disposed(by: bag)
    
    // 위의 주석 처리 된 두가지 연산자를 zip으로 통합, 나중에 코드 수정하기 어려울 듯...
    Observable.zip(listTableView.rx.modelSelected(Product.self),
                   listTableView.rx.itemSelected)
    .bind { [weak self] (product, indexPath) in
      self?.listTableView.deselectRow(at: indexPath, animated: true)
      print(product.name)
    }
    .disposed(by: bag)
    
    //delegate 구현하면 Rx로 구현한 것들이 실행되지 않는다.
//    listTableView.delegate = self
    
    //사용하고 싶다면 rx.setDelegate(self) 구현
    listTableView.rx.setDelegate(self)
      .disposed(by: bag)
  }
}

extension RxCocoaTableViewViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(#function)
  }
}




