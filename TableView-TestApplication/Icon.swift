import UIKit

enum RatingType : Int {
    case Unrated
    case Ugly
    case OK
    case Nice
    case Awesome
    case TotalRatings
}

class Icon {
    
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