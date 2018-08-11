import UIKit
import MapKit
import SnapKit

public final class MapViewController: UIViewController {
    typealias View = MKMapView
    
    public override func loadView() {
        self.view = View()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! View
        let toolbar = MapToolbar()
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.top.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(-6)
        }
        toolbar.items = [
            UIButton(type: .system).apply { button in
                button.setImage(UIImage(named: "Icon.Settings.25", in: PrivateConstants.bundle, compatibleWith: nil), for: .normal)
                button.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
            },
            MKUserTrackingButton(mapView: view)
        ]
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func didTapSettings() {
        self.navigationController?.pushViewController(TargetListViewController(), animated: true)
    }
    
    private enum PrivateConstants {
        static let bundle = Bundle(for: MapViewController.self)
    }
}
