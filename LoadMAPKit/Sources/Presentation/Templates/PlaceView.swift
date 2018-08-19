import UIKit

final class PlaceView: UICollectionView {
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
        let label = UILabel().apply { label in
            label.textColor = .darkGray
            label.font = UIFont.systemFont(ofSize: 18)
        }
        let valueLabel = UILabel().apply { label in
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 18)
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
            self.contentView.backgroundColor = .white
            self.contentView.addSubview(self.label)
            self.label.snp.makeConstraints { make in
                make.leading.equalTo(self.contentView).offset(8)
                make.centerY.equalTo(self.contentView)
            }
            self.contentView.addSubview(self.valueLabel)
            self.valueLabel.snp.makeConstraints { make in
                make.trailing.equalTo(self.contentView).offset(-8)
                make.centerY.equalTo(self.contentView)
            }
        }
        
        func update(with row: PlaceViewModel.Row) {
            self.label.text = row.label
            self.valueLabel.text = row.value
        }
        
        enum Constants {
            static let height: CGFloat = 48
        }
    }
}
