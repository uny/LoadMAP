import UIKit
import SnapKit

final class TargetListView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        self.backgroundColor = .lightGray
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 1
            layout.minimumInteritemSpacing = 0
        }
    }
    
    final class Cell: UICollectionViewCell {
        let nameLabel = UILabel().apply { label in
            label.textColor = .black
        }
        let timestampLabel = UILabel().apply { label in
            label.textColor = .lightGray
            label.font = .systemFont(ofSize: 10)
        }
        let imageView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.initialize()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.initialize()
        }
        
        private func initialize() {
            self.contentView.backgroundColor = .white
            self.contentView.addSubview(self.nameLabel)
            self.nameLabel.snp.makeConstraints { make in
                make.leading.equalTo(self.contentView).offset(8)
                make.top.equalTo(self.contentView).offset(8)
            }
            self.contentView.addSubview(self.timestampLabel)
            self.timestampLabel.snp.makeConstraints { make in
                make.leading.equalTo(self.contentView).offset(8)
                make.bottom.equalTo(self.contentView).offset(-4)
            }
            self.contentView.addSubview(self.imageView)
            self.imageView.snp.makeConstraints { make in
                make.trailing.equalTo(self.contentView).offset(-8)
                make.centerY.equalTo(self.contentView)
            }
            let lineView = UIView()
            lineView.backgroundColor = .lightGray
            self.contentView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.leading.equalTo(self.contentView)
                make.height.equalTo(1)
                make.trailing.equalTo(self.contentView)
                make.bottom.equalTo(self.contentView)
            }
        }
        
        func update(with model: TargetListViewModel.CellModel) {
            self.nameLabel.text = model.name
            self.timestampLabel.text = model.timestamp
            if model.isSelected {
                self.imageView.image = UIImage(named: "Icon.CheckMark.24", in: PrivateConstants.bundle, compatibleWith: nil)
            } else {
                self.imageView.image = nil
            }
        }
        
        enum Constants {
            static let height: CGFloat = 48
        }
        
        private enum PrivateConstants {
            static let bundle = Bundle(for: Cell.self)
        }
    }
}
