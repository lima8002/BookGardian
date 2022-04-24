//
//  RegBookViewController.h
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

@import Firebase;
@import FirebaseStorage;
#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegBookViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    UIImagePickerController *picker;
    
}


@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *totalInput;
@property (weak, nonatomic) IBOutlet UITextField *pageInput;
@property (weak, nonatomic) IBOutlet UIImageView *photoInput;
@property (weak, nonatomic) IBOutlet UILabel *labelInput;
@property (weak, nonatomic) IBOutlet UIButton *saveBookText;

@property (nonatomic, strong) FIRFirestore *firestore;
@property NSString* fileNameToSave;

@property Book* book;
@property NSString* stringDate;

@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;

- (IBAction)saveBook:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)nameInputAction:(id)sender;
- (IBAction)totalInputAction:(id)sender;
- (IBAction)pageInputAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
