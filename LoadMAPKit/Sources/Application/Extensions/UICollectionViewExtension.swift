import UIKit

extension UICollectionView {
    func dequeueReusableCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, for indexPath: IndexPath) -> Cell {
        return self.dequeueReusableCell(withReuseIdentifier: "\(Cell.self)", for: indexPath) as! Cell
    }
    
    func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: "\(Cell.self)")
    }
}
