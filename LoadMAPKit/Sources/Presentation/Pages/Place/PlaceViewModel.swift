import Foundation

final class PlaceViewModel {
    private(set) var rows = [Row]()
    
    func reload(for place: PlaceEntity) {
        var rows: [Row] = [Row(label: "name", value: place.name)]
        let dictionary = PropertyList(data: place.fields).stringDictionary
        for (label, value) in dictionary {
            rows.append(Row(label: label, value: value))
        }
        self.rows = rows
    }
    
    struct Row {
        let label: String
        let value: String
    }
}
