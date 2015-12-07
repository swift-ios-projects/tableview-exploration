import UIKit

enum RatingType : Int {
    case Unrated
    case Ugly
    case OK
    case Nice
    case Awesome
    case TotalRatings
}

class Icon: NSObject, Comparable {
    
    var title: String
    var subtitle: String
    var image: UIImage?
    var rating = RatingType.Unrated
    
    init(withTitle title: String, subtitle: String, imageName: String?) {
        self.title = title
        self.subtitle = subtitle
        if let imageName = imageName {
            if let iconImage = UIImage(named: imageName) {
                image = iconImage
            }
        }
        
        
    }  
}

func < (lhs: Icon, rhs: Icon) -> Bool {
    return lhs.title < rhs.title
}

func == (lhs: Icon, rhs: Icon) -> Bool {
    return lhs.title == rhs.title && lhs.subtitle == rhs.subtitle
}