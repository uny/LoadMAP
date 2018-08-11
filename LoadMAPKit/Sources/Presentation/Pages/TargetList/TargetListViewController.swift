import UIKit
import RxSwift

final class TargetListViewController: UIViewController {
    typealias View = UICollectionView
    private let disposeBag = DisposeBag()
    private let model = TargetListViewModel()
    
    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.view = View(frame: .zero, collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        self.showNewTargetForm()
    }
    
    private func showNewTargetForm(with error: Swift.Error? = nil) {
        let model = self.model
        let disposeBag = self.disposeBag
        let controller = UIAlertController(title: "New Target", message: error?.localizedDescription, preferredStyle: .alert)
        controller.addTextField { textField in
            textField.placeholder = "https://example.com/path/to/json"
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        controller.addAction(UIAlertAction(title: "OK", style: .default) { action in
            let text = controller.textFields?.first?.text
            model.addNewTarget(urlString: text)
                .subscribe { event in
                }.disposed(by: disposeBag)
        })
        self.present(controller, animated: true)
    }
}
