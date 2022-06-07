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

class CustomControlEventViewController: UIViewController {
  
  let bag = DisposeBag()
  
  @IBOutlet weak var inputField: UITextField!
  
  @IBOutlet weak var countLabel: UILabel!
  
  @IBOutlet weak var doneButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    inputField.borderStyle = .none
    inputField.layer.borderWidth = 3
    inputField.layer.borderColor = UIColor.gray.cgColor
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: inputField.frame.height))
    inputField.leftView = paddingView
    inputField.leftViewMode = .always
    
    //1, 2, 3 똑같은 결과
    //1
    inputField.rx.text
      .map { $0?.count ?? 0 }
      .map { "\($0)" }
      .bind(to: countLabel.rx.text)
      .disposed(by: bag)
    
    //2
    inputField.rx.editingChanged
      .map { self.inputField.text }
      .bind(to: countLabel.rx.countText)
      .disposed(by: bag)
    
    //3
    inputField.rx.text
      .bind(to: countLabel.rx.countText)
      .disposed(by: bag)
    
    doneButton.rx.tap
      .subscribe(onNext: { [weak self] _ in
        self?.inputField.resignFirstResponder()
      })
      .disposed(by: bag)
    
    inputField.rx.editingDidBegin
      .map { UIColor.red }
      .bind(to: inputField.rx.borderColor)
      .disposed(by: bag)
    
    
    inputField.rx.ediditingDidEnd
      .map { UIColor.gray }
      .bind(to: inputField.rx.borderColor)
      .disposed(by: bag)

    //        inputField.delegate = self
  }
}

//extension CustomControlEventViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.layer.borderColor = UIColor.red.cgColor
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.layer.borderColor = UIColor.gray.cgColor
//    }
//}

// 주석 처리 된 delegate - textFieldDidBeginEditing, textFieldDidEndEditing와 같은 기능을 쓸수 있게 확장.
extension Reactive where Base: UITextField {
  var borderColor: Binder<UIColor?> {
    return Binder(self.base) { textField, color in
      textField.layer.borderColor = color?.cgColor
    }
  }
  
  var editingDidBegin: ControlEvent<Void> {
    return controlEvent(.editingDidBegin)
  }
  
  var ediditingDidEnd: ControlEvent<Void> {
    return controlEvent(.editingDidEnd)
  }
  
  var editingChanged: ControlEvent<Void> {
    return controlEvent(.editingChanged)
  }
}

extension Reactive where Base: UILabel {
  var countText: Binder<String?> {
    return Binder(self.base) { label, text in
      let count = text?.count ?? 0
      label.text = String(count)
    }
  }
}
