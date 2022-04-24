//
//  RegBookViewController.m
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import "RegBookViewController.h"
#import "FirestoreService.h"
#import "Book.h"

@interface RegBookViewController ()

@end

@implementation RegBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([[[self book] type] isEqualToString:@"Y"]) {
        [[self saveBookText] setTitle:@"Update" forState:UIControlStateNormal];
        [[self nameInput] setText:[[self book] name]];
        [[self totalInput] setText:[[self book] total]];
        [[self pageInput] setText:[[self book] page]];
        [[self labelInput] setText:@""];
        if (![[[self book] photo] isEqualToString:@"noimage"]) {
            // Get a reference to the storage service using the default Firebase App
            FIRStorage *storage = [FIRStorage storage];
            // Create a storage reference from our storage service
            FIRStorageReference *storageRef = [storage referenceForURL:[NSString stringWithFormat:@"gs://bookgardianapp.appspot.com/"]];
            // Create a storage reference from our storage service
            FIRStorageReference *photoRef = [storageRef child:[[self book] photo]];
            // Upload file and metadata to the object 'images/img*****.jpg'
            [photoRef downloadURLWithCompletion:^(NSURL *URL, NSError *error){
                NSLog(@"photoref %@", photoRef);
                NSLog(@"URL %@", URL);
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    //NSLog(@"download error: %@", error);
                    NSLog(@"not found");
                } else {
                    
                    dispatch_async(dispatch_get_global_queue(0,0), ^{
                        NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                        if ( data == nil )
                            return;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // WARNING: is the cell still using the same data by this point??
                            [[self photoInput] setImage:[UIImage imageWithData:data]];
                        });
                    });
                }
            }];
        }
        [[self takePhotoButton ] setEnabled:FALSE];
        [[self takePhotoButton] setAlpha:0.00];
        [[self takePhotoButton] setHidden:YES];
    } else {
        [[self saveBookText] setTitle:@"Save" forState:UIControlStateNormal];
        [[self photoInput] setImage:[UIImage imageNamed:@"noimage"]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pageInputAction:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)totalInputAction:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)nameInputAction:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)takePhoto:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Get the selected image.
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Generate a data from the image selected
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    // Show the image in the Imageview
    [[self photoInput] setImage:image];
    // Create the file metadata
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";
    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];
    // Create a storage reference from our storage service
    NSString* fileName = [NSString stringWithFormat:@"images/img_%@.jpg", [self getRandomNumber]];
    _fileNameToSave = fileName;
    NSLog(@"fileName: %@", fileName);
    FIRStorageReference *storageRef = [storage referenceForURL:[NSString stringWithFormat:@"gs://bookgardianapp.appspot.com/"]];
    FIRStorageReference *photoRef = [storageRef child:fileName];
    NSLog(@"PhotoRef name: %@", photoRef.name);
    // Upload file and metadata to the object 'images/img*****.jpg'
    //FIRStorageUploadTask *uploadTask =
    [photoRef putData:imageData metadata:metadata completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
            NSLog(@"first error: %@", error);
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Generate Random Number

- (NSString *)getRandomNumber {
    NSTimeInterval time = ([[NSDate date] timeIntervalSince1970]); // returned as a double
    long digits = (long)time; // this is the first 10 digits
    int decimalDigits = (int)(fmod(time, 1) * 1000); // this will get the 3 missing digits
    //long timestamp = (digits * 1000) + decimalDigits;
    NSString *timestampString = [NSString stringWithFormat:@"%ld%d",digits ,decimalDigits];
    return timestampString;
}

- (IBAction)saveBook:(id)sender {
    // Get an instance of the Firestore database
    self.firestore = [FIRFirestore firestore];
    
    //create an instance of the service, and pass firestore db instance
    FirestoreService* service = [[FirestoreService alloc] init];
    [service setFirestore:[self firestore]];
    
    // validate new input
    
    NSMutableArray* validationFailedMessages = [[NSMutableArray alloc] init];
    //the method contactPassedValidations will do the validations
    if([self bookPassedValidations:[self book] error:validationFailedMessages]){
        // create the book and add the values
        NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
        _stringDate = [dateFormatter stringFromDate:[NSDate date]];
       
        if([[[self book] type] isEqualToString:@"Y"]) {
            _book.name = [[self nameInput] text];
            _book.page = [[self pageInput] text];
            _book.total = [[self totalInput] text];
            _book.update = _stringDate;

            NSLog(@"%@", [self book]);
            
            
            if([service updateBook:[self book]]){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showUIAlertWithMessage:@"The book was not updated" andTitle:@"Update"];
            }
            
        } else {
            Book* book = [[Book alloc] initWithName:[[self nameInput] text]
                                             update:_stringDate page:[[self pageInput] text]
                                              total:[[self totalInput] text]
                                               type:@""
                                              photo:[NSString stringWithFormat:@"%@", _fileNameToSave]
                                             bookId:@""];
            
            if([service addBook:book]){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self showUIAlertWithMessage:@"The book was not saved" andTitle:@"Save"];
            }
        }
    }else{
        NSMutableString* invalidFieldsMessage = [NSMutableString new];
        for (NSString* message in validationFailedMessages) {
            [invalidFieldsMessage appendString:message];
            [invalidFieldsMessage appendString:@"\n"];
        }
        [self showUIAlertWithMessage:invalidFieldsMessage andTitle:@"Invalid Fields"];
    }
}

-(BOOL) bookPassedValidations: (Book*) book
                        error: (NSMutableArray*) validationFailedMessages {
    
    BOOL passed = YES;
    /** Check Book Name */
    //remove empty spaces at the beginning and end
    NSString* trimmedBookName = [[[self nameInput] text ]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //check if there is something to search for after removing the empty spaces
    if([trimmedBookName length] == 0){
        [validationFailedMessages addObject:@"Name is blank"];
        passed = NO;
    }
    
    /** Check Book Page */
    NSString* trimmedBookPage = [[[self pageInput] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([trimmedBookPage length] == 0){
        [validationFailedMessages addObject:@"Page is blank"];
        passed = NO;
    }
    
    /** Check Book TotalPages */
    NSString* trimmedBookTotalPages = [[[self totalInput] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //check if there is something to search for after removing the empty spaces
    if([trimmedBookTotalPages length] == 0){
        [validationFailedMessages addObject:@"Total Pages is blank"];
        passed = NO;
    }
    
    return passed;
}

-(void) showUIAlertWithMessage:(NSString*) message andTitle:(NSString*)title{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        NSLog(@"%@", message);
    }];
}




@end
