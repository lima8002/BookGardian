//
//  StatisticsViewController.h
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *qtLabel;
@property (weak, nonatomic) IBOutlet UILabel *newestLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldLabel;

@end

NS_ASSUME_NONNULL_END
