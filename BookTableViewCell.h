//
//  BookTableViewCell.h
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

@import Firebase;
@import FirebaseStorage;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoBook;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progView;
@property (weak, nonatomic) IBOutlet UILabel *progViewLabel;

@end

NS_ASSUME_NONNULL_END
