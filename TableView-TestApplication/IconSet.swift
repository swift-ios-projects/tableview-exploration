import UIKit

class IconSet : Equatable {
    
    let name: String
    var icons: [Icon]
    
    init(name: String, icons: [Icon]) {
        self.name = name
        self.icons = icons
    }
    
    static func winterSet() -> IconSet {
        var icons = [Icon]()
        icons.append(Icon(withTitle: "Ornament", subtitle: "Hang on your tree", imageName: "icons_winter_01.png"))
        icons.append(Icon(withTitle: "Candy Cane", subtitle: "Mmm, tasty", imageName: "icons_winter_02.png"))
        icons.append(Icon(withTitle: "Snowman", subtitle: "A very happy soul", imageName: "icons_winter_03.png"))
        icons.append(Icon(withTitle: "Penguin", subtitle: "Mario's friend", imageName: "icons_winter_04.png"))
        icons.append(Icon(withTitle: "Santa Hat", subtitle: "Found it in the chimney", imageName: "icons_winter_05.png"))
        icons.append(Icon(withTitle: "Gift", subtitle: "Under the tree", imageName: "icons_winter_06.png"))
        icons.append(Icon(withTitle: "Gingerbread Man", subtitle: "Lives in a yummy house", imageName: "icons_winter_07.png"))
        icons.append(Icon(withTitle: "Christmas Tree", subtitle: "Smells good", imageName: "icons_winter_08.png"))
        icons.append(Icon(withTitle: "Snowflake", subtitle: "Unique and beautiful", imageName: "icons_winter_09.png"))
        icons.append(Icon(withTitle: "Reindeer", subtitle: "A very shiny nose", imageName: "icons_winter_10.png"))
        return IconSet(name: "Winter", icons: icons)
    }
    
    static func summerSet() -> IconSet {
        var icons = [Icon]()
        icons.append(Icon(withTitle: "Sun", subtitle: "A beautiful day", imageName: "summericons_100px_01.png"))
        icons.append(Icon(withTitle: "Beach Ball", subtitle: "Fun in the sand", imageName: "summericons_100px_02.png"))
        icons.append(Icon(withTitle: "Swim Trunks", subtitle: "Time to go swimming", imageName: "summericons_100px_03.png"))
        icons.append(Icon(withTitle: "Bikini", subtitle: "Staying cool", imageName: "summericons_100px_04.png"))
        icons.append(Icon(withTitle: "Sand Bucket and Shovel", subtitle: "A castle in the sand", imageName: "summericons_100px_05.png"))
        icons.append(Icon(withTitle: "Surfboard", subtitle: "Catch a wave", imageName: "summericons_100px_06.png"))
        icons.append(Icon(withTitle: "Strawberry Dacquari", subtitle: "Great way to relax", imageName: "summericons_100px_07.png"))
        icons.append(Icon(withTitle: "Sunglasses", subtitle: "I wear them at night", imageName: "summericons_100px_08.png"))
        icons.append(Icon(withTitle: "Flip Flops", subtitle: "Sand between your toes", imageName: "summericons_100px_09.png"))
        icons.append(Icon(withTitle: "Ice Cream", subtitle: "A summer treat", imageName: "summericons_100px_10.png"))
        return IconSet(name: "Summer", icons: icons)
    }
    
    static func iconSets() -> [IconSet] {
        return [IconSet.summerSet(), IconSet.winterSet()]
    }
    
}


func ==(lhs: IconSet, rhs: IconSet) -> Bool {
    var isEqual = false
    if (lhs.name == rhs.name && lhs.icons.count == rhs.icons.count) {
        isEqual = true
    }
    return isEqual
}

