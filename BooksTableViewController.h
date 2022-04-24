//
//  BooksTableViewController.h
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import <UIKit/UIKit.h>
@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface BooksTableViewController : UITableViewController

@property (nonatomic, strong) FIRFirestore *firestore;
@property (strong, nonatomic) IBOutlet UITableView *booksTableView;
@property (strong, nonatomic) NSMutableDictionary *booksDictionary;

@property UIImage* imageToDisplay;

@end

NS_ASSUME_NONNULL_END
