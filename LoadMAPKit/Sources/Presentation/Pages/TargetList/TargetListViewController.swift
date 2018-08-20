import UIKit
import RealmSwift
import RxSwift

final class TargetListViewController: UIViewController {
    typealias View = TargetListView
    private let disposeBag = DisposeBag()
    private let model = TargetListViewModel()
    private var notificationToken: RealmSwift.NotificationToken?
    
    deinit {
        self.notificationToken?.invalidate()
    }
    
    override func loadView() {
        self.view = View(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        let view = self.view as! View
        view.register(View.Cell.self)
        view.dataSource = self
        view.delegate = self
        notificationToken = self.model.targets.observe { changes in
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                view.performBatchUpdates({
                    view.insertItems(at: insertions.map { IndexPath(item: $0, section: 0) })
                    view.deleteItems(at: deletions.map { IndexPath(item: $0, section: 0) })
                    view.reloadItems(at: modifications.map { IndexPath(item: $0, section: 0) })
                }, completion: nil)
            case .error:
                break
            }
        }
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

extension TargetListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.targets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(View.Cell.self, for: indexPath)
        let model = self.model.cellModel(at: indexPath.item)
        cell.update(with: model)
        return cell
    }
}

extension TargetListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: View.Cell.Constants.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let disposeBag = self.disposeBag
        let model = self.model
        let target = model.targets[indexPath.item]
        let controller = UIAlertController(title: target.name, message: target.urlString, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Select", style: .default) { action in
            model.select(target: target)
                .map { indices in indices.map { IndexPath(item: $0, section: 0) } }
                .subscribe { event in
                    switch event {
                    case .success(let indexPaths):
                        collectionView.reloadItems(at: indexPaths)
                    default:
                        break
                    }
                }.disposed(by: disposeBag)
        })
        controller.addAction(UIAlertAction(title: "Refresh", style: .default) { action in
            model.refresh(target: target)
                .subscribe { event in
                }.disposed(by: disposeBag)
        })
        controller.addAction(UIAlertAction(title: "Delete", style: .destructive) { action in
            model.delete(target: target).subscribe { event in
            }.disposed(by: disposeBag)
        })
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(controller, animated: true)
    }
}
