import UIKit
import MapKit
import SnapKit

public final class MapViewController: UIViewController {
    typealias View = MKMapView
    private let model = MapViewModel()
    
    public override func loadView() {
        self.view = View()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! View
        view.delegate = self
        let toolbar = MapToolbar()
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.trailing.equalTo(view).offset(-6)
            make.bottom.equalTo(view).offset(-30)
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
        self.model.reloadPlaces()
        self.reloadAnnotations()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func didTapSettings() {
        self.navigationController?.pushViewController(TargetListViewController(), animated: true)
    }
    
    private func reloadAnnotations() {
        let view = self.view as! View
        view.removeAnnotations(view.annotations)
        guard let places = self.model.places else { return }
        for place in places {
            let annotation = PlaceAnnotation(place: place)
            view.addAnnotation(annotation)
        }
    }
    
    private class PlaceAnnotation: MKPointAnnotation {
        var place: PlaceEntity
        
        init(place: PlaceEntity) {
            self.place = place
            super.init()
            self.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            self.title = place.name
        }
    }
    
    private enum PrivateConstants {
        static let bundle = Bundle(for: MapViewController.self)
    }
}

extension MapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "\(MapViewController.self)"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as! MKMarkerAnnotationView
        annotationView.clusteringIdentifier = identifier
        guard let annotation = annotation as? PlaceAnnotation else { return annotationView }
        annotationView.markerTintColor = UIColor(hex: annotation.place.color)
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        return MKClusterAnnotation(memberAnnotations: memberAnnotations)
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PlaceAnnotation,
            control == view.rightCalloutAccessoryView else { return }
        let controller = PlaceViewController.instantiate(place: annotation.place)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
