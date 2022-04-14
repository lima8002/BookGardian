//
//  BookTableViewCell.h
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoBook;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIStackView *updateLabel;
@property (weak, nonatomic) IBOutlet UIStackView *pageLabel;
@property (weak, nonatomic) IBOutlet UIStackView *totalLabel;
@property (weak, nonatomic) IBOutlet UIStackView *progView;



@end

NS_ASSUME_NONNULL_END
