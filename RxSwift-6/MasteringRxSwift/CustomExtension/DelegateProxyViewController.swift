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
import CoreLocation
import RxSwift
import RxCocoa
import MapKit

class DelegateProxyViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      //사용자들에게 허가 요청
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()
      
      //구독자를 추가하고 위치 정보를 출력
      locationManager.rx.didUpdateLocations
        .subscribe(onNext: { location in
          print(location)
        })
        .disposed(by: bag)
      
      
      locationManager.rx.didUpdateLocations
        .map { $0[0] }
        .bind(to: mapView.rx.center)
        .disposed(by: bag)
    }
}


extension Reactive where Base: MKMapView {
    public var center: Binder<CLLocation> {
        return Binder(self.base) { mapView, location in
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.base.setRegion(region, animated: true)
        }
    }
}

//--------- 필수로 구현해야함 ----------
//CLLocationManagerDelegate 확장하여 사용
//HasDelegate를 채용하면 기존 delegate, datasource를 사용 할 수 있다.
extension CLLocationManager: HasDelegate {
  public typealias Delegate = CLLocationManagerDelegate
}

//DelegateProxy
class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
  //확장 대상 지정
  weak private(set) var locationManager: CLLocationManager?
  
  init(locationManager: CLLocationManager) {
    self.locationManager = locationManager
    super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
  }
  
  static func registerKnownImplementations() {
    self.register {
      RxCLLocationManagerDelegateProxy(locationManager: $0)
    }
  }
}

extension Reactive where Base: CLLocationManager {
  var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
    return RxCLLocationManagerDelegateProxy.proxy(for: base)
  }
//--------------------------------
  
  var didUpdateLocations: Observable<[CLLocation]> {
    return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
      .map { parameters in
        return parameters[1] as! [CLLocation]
      }
  }
}

