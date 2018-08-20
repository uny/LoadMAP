import Foundation

final class PlaceViewModel {
    private(set) var rows = [Row]()
    
    func reload(for place: PlaceEntity) {
        var rows: [Row] = [Row(label: "name", value: place.name, valueType: .string)]
        let propertyList = PropertyList(data: place.fields)
        let keys = propertyList.dictionary.keys.sorted()
        for key in keys {
            let row: Row
            if let url = propertyList[key].url {
                row = Row(label: key, value: url.absoluteString, valueType: .url)
            } else if let string = propertyList[key].string {
                row = Row(label: key, value: string, valueType: .string)
            } else {
                continue
            }
            rows.append(row)
        }
        self.rows = rows
    }
    
    struct Row {
        let label: String
        let value: String
        let valueType: ValueType
        
        enum ValueType {
            case url
            case string
        }
    }
}
