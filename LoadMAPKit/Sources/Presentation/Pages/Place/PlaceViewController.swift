import UIKit

final class PlaceViewController: UIViewController {
    typealias View = PlaceView
    private let model = PlaceViewModel()
    private var place: PlaceEntity!
    
    override func loadView() {
        self.view = View(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = self.view as! View
        view.register(View.Cell.self)
        view.dataSource = self
        view.delegate = self
    }
    
    static func instantiate(place: PlaceEntity) -> PlaceViewController {
        let controller = PlaceViewController()
        controller.place = place
        controller.model.reload(for: place)
        return controller
    }
}

extension PlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.rows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(View.Cell.self, for: indexPath)
        cell.update(with: self.model.rows[indexPath.item])
        return cell
    }
}

extension PlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: View.Cell.Constants.height)
    }
}
