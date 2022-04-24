//
//  BooksTableViewController.m
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import "BooksTableViewController.h"
#import "FirestoreService.h"
#import "Book.h"
#import "BookTableViewCell.h"
#import "RegBookViewController.h"

@interface BooksTableViewController ()
@property Book* selectedBook;
@end

@implementation BooksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadTableList];
    
}

-(void)loadTableList {
    // Get an instance of the Firestore database
    self.firestore = [FIRFirestore firestore];
    // Inintialize the contactsDictionary that will serve as a datasource for our tableViewController
    _booksDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    //create an instance of the service, and pass firestore db instance
    FirestoreService* service = [[FirestoreService alloc] init];
    [service setFirestore:[self firestore]];
    
    //    [service query];
    /*
     Here we are using a completion block
     https://developer.apple.com/documentation/foundation/nsoperation/1408085-completionblock?language=objc
     More explanaition
     https://medium.com/@amyjoscelyn/blocks-and-closures-in-objective-c-2b763e9e0dc8
     */
    [service findAll:^(NSMutableDictionary * _Nonnull dictionary) {
        if(dictionary != nil){
            for (NSString* key in dictionary) {
                [[self booksDictionary] setObject:[dictionary objectForKey:key] forKey:key];
            }
        }
        [[self booksTableView] reloadData];//This is a trick needed to display data in the TableView
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self booksDictionary] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"BookCell";
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(cell == nil){
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //get the value from the dictionary
    NSString *bookId = [[self booksDictionary] allKeys][ [indexPath row] ] ;
    NSLog(@"bookId: %@", bookId);
    
    
    //booksArray is an Array Containing a dictionary in each element
    NSArray* booksArray = [[self booksDictionary] allValues];
    
    //Obtain a dictionary with all data for a contact ( name, position, email etc )
    NSDictionary* bookDictionary = [booksArray objectAtIndex:[indexPath row]];
    NSLog(@"dict : %@", bookDictionary);
    
    //firebase collection
    
    [[cell nameLabel] setText:[NSString stringWithFormat: @"Name: %@",[bookDictionary objectForKey:@"name"]]];
    [[cell updateLabel] setText:[NSString stringWithFormat: @"Last Update: %@",[bookDictionary objectForKey:@"update"]]];
    [[cell pageLabel] setText:[NSString stringWithFormat: @"Actual Page: %@",[bookDictionary objectForKey:@"page"]]];
    [[cell totalLabel] setText:[NSString stringWithFormat: @"Page Total: %@",[bookDictionary objectForKey:@"total"]]];
    if ([[bookDictionary objectForKey:@"photo"] isEqualToString:@"noimage"]) {
        [[cell photoBook] setImage:[UIImage imageNamed:@"noimage"]];
    } else {
        // Get a reference to the storage service using the default Firebase App
        FIRStorage *storage = [FIRStorage storage];
        // Create a storage reference from our storage service
        FIRStorageReference *storageRef = [storage referenceForURL:[NSString stringWithFormat:@"gs://bookgardianapp.appspot.com/"]];
        // Create a storage reference from our storage service
        FIRStorageReference *photoRef = [storageRef child:[bookDictionary objectForKey:@"photo"]];
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
                        [[cell photoBook] setImage:[UIImage imageWithData:data]];
                    });
                });
            }
        }];
    }
    float progValueTotal = [[bookDictionary objectForKey:@"total"] floatValue];
    float progValuePage = [[bookDictionary objectForKey:@"page"] floatValue];
    float progValue = (progValuePage / progValueTotal);
    [[cell progView] setProgress:progValue animated:YES];
    [[cell progViewLabel] setText:[NSString stringWithFormat: @"%.0f%%",progValue * 100]] ;
    
    return cell;

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger selectedRow = [indexPath row];
    NSString* key = [[self booksDictionary] allKeys][selectedRow];
    NSMutableDictionary* bookDictionary = [[self booksDictionary] objectForKey:key];
    NSString *bookId = [[self booksDictionary] allKeys][ [indexPath row]];
    _selectedBook = [[Book alloc] initWithDictionary:bookDictionary];
    [[self selectedBook] setBookId:bookId];
    
    return indexPath;
}
    

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView setEditing:YES animated:YES];
        // Get an instance of the Firestore database
        self.firestore = [FIRFirestore firestore];

        //create an instance of the service, and pass firestore db instance
        FirestoreService* service = [[FirestoreService alloc] init];
        [service setFirestore:[self firestore]];

        NSInteger selectedRow = [indexPath row];
        NSString* key = [[self booksDictionary] allKeys][selectedRow];
        NSMutableDictionary* bookDictionary = [[self booksDictionary] objectForKey:key];
        NSString *bookId = [[self booksDictionary] allKeys][ [indexPath row]];
        _selectedBook = [[Book alloc] initWithDictionary:bookDictionary];
        [[self selectedBook] setBookId:bookId];
        [service deleteBook: [self selectedBook]];
        [self loadTableList];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue destinationViewController] isKindOfClass:[RegBookViewController class]]){
        if([segue.identifier isEqualToString:@"updateSegue"]) {
            RegBookViewController* bookRegBookViewController = [segue destinationViewController];
            [bookRegBookViewController setBook:[self selectedBook]];
            _selectedBook.type = @"Y";
            NSLog(@"Segue ----> %@", _selectedBook.bookId);
        }
    }
}

@end
