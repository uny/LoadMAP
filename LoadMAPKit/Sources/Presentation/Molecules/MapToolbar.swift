import UIKit
import SnapKit

final class MapToolbar: UIView {
    var items = [UIView]() {
        didSet {
            self.reloadItems(oldItems: oldValue, newItems: self.items)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        self.clipsToBounds = true
        self.layer.cornerRadius = PrivateConstants.cornerRadius
    }
    
    override var intrinsicContentSize: CGSize {
        guard let first = self.items.first, let last = self.items.last else { return .zero }
        return CGSize(width: first.frame.size.width, height: last.frame.origin.y - first.frame.origin.y)
    }
    
    private func reloadItems(oldItems: [UIView], newItems: [UIView]) {
        for item in oldItems {
            item.removeFromSuperview()
        }
        for (index, item) in newItems.enumerated() {
            item.backgroundColor = UIColor(white: 1, alpha: 0.8)
            self.addSubview(item)
            item.snp.makeConstraints { make in
                make.leading.equalTo(self)
                make.trailing.equalTo(self)
                make.top.equalTo(self).offset((PrivateConstants.itemWidth + PrivateConstants.spaceWidth) * CGFloat(index))
                make.height.equalTo(PrivateConstants.itemWidth)
                if item == newItems.last {
                    make.bottom.equalTo(self)
                }
            }
        }
        self.invalidateIntrinsicContentSize()
    }
    
    private enum PrivateConstants {
        static let itemWidth: CGFloat = 38
        static let spaceWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 6
    }
}
