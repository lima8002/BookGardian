//
//  RegBookViewController.h
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegBookViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *totalInput;
@property (weak, nonatomic) IBOutlet UITextField *pageInput;



- (IBAction)saveBook:(id)sender;
@end

NS_ASSUME_NONNULL_END
