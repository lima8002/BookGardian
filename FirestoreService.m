//
//  FirestoreService.m
//  ContactsFirebaseApp1
//
//  Created by Eduardo Lima on 12/04/22.
//

#import "FirestoreService.h"
#import "Book.h"

@implementation FirestoreService

/**
 * Add a contact document referred to by this `FirestoreService`. If no document exists, it
 * is created. If a document already exists, it is overwritten.
 *
 * @param book A `Book` containing the fields that make up the document
 *     to be written.
 * @return A BOOL indicating if the contact was added or not.
 */
-(BOOL) addBook: (Book*) book{
    //https://cloud.google.com/firestore/docs/manage-data/add-data
    __block BOOL added = YES;
    @try {
        //Returns a FIRDocumentReference pointing to a new document with an auto-generated ID.
        FIRDocumentReference *newBookReference = [[[self firestore] collectionWithPath:@"Books"] documentWithAutoID];
        //Do something with the new contact and then, send it to the DB by calling setData
        
        [newBookReference setData:@{
            @"name": [book name],
            @"update": [book update],
            @"page": [book page],
            @"photo": [book photo],
            @"total": [book total]
        } completion:^(NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Error adding document: %@", error);
                added = NO;
            }else {
                NSLog(@"all good...");
            }
        }];
    } @catch (NSException *exception) {
        added = NO;
        NSLog(@"%@", exception);
    }
    return added;
}

/**
    Given a contactId this method will search Contacts collection to retrieve the correspondent document passed in a complete block
    Returns nil if the contact was not found in the database collection
 */
-(void) findBookById: (NSString* ) bookId completeBlock: (void(^)(Book *)) completion{
    
    __block Book *bookFound;
    
    FIRDocumentReference *bookReference = [[[self firestore] collectionWithPath:@"Books"] documentWithPath:bookId];
    
    [bookReference getDocumentWithCompletion:^(FIRDocumentSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if([snapshot exists]){

            NSDictionary<NSString *,id> *bookDictionary = [snapshot data];
            NSString* idFound = [snapshot documentID];
            
            bookFound = [[Book alloc] initWithDictionary:bookDictionary];
            [bookFound setBookId:idFound];
            
            if(completion){
                NSLog(@"book found in complete block: %@", bookFound);
                completion(bookFound);
            }
            NSLog(@"book found");

        }else{
            NSLog(@"Document does not exist");
        }
    }];
}

/**
 * Updates fields in the document referred to by this `FirestoreService`. If the document
 * does not exist, the update fails and the specified completion block receives an error.
 *
 * @param book A `Book` containing the fields and values with which to update the document.
 * @return A BOOL indicating if the contact was updated or not.
 */
-(BOOL) updateBook: (Book*) book{
    __block BOOL updated = YES;
    
    //Fetch the document by using the Id
    FIRDocumentReference *bookReference = [[[self firestore] collectionWithPath:@"Books"] documentWithPath:[book bookId]];
    /**
            To update some fields of a document without overwriting the entire document, use the update() method.
            Else use setData with the merge property, in this case setData is recommended, I'm using update as demonstration
    */
    [bookReference updateData:@{
        @"name": [book name],
        @"update": [book update],
        @"page": [book page],
        @"photo": [book photo],
        @"total": [book total]
    } completion:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error updating document: %@", error);
            updated = NO;
        }else{
            NSLog(@"Document successfully updated");
        }
    }];
    return updated;
}

/**
 * Delete a document referred to by this `FirestoreService`. If the document
 * does not exist, the delete fails and the returns NO.
 *
 * @param book A `Book` containing the autoId of the document to delete.
 * @return A BOOL indicating if the contact was deleted or not.
 */
-(BOOL) deleteBook: (Book*) book{
    /**
        https://firebase.google.com/docs/firestore/manage-data/delete-data
         Warning: Deleting a document does not delete its subcollections!
     
         When you delete a document, Cloud Firestore does not automatically delete the documents within its subcollections.
         You can still access the subcollection documents by reference. For example, you can access the document at path /mycoll/mydoc/mysubcoll/mysubdoc even if you delete the ancestor document at /mycoll/mydoc.

         Non-existent ancestor documents appear in the console, but they do not appear in query results and snapshots.
         If you want to delete a document and all the documents within its subcollections, you must do so manually. For more information, see Delete Collections.
     */
    
    NSLog(@"Delete ---> %@", book);
    NSLog(@"Delete bookId ---> %@", [book bookId]);
    __block BOOL deleted = YES;
    FIRDocumentReference *bookReference = [[[self firestore] collectionWithPath:@"Books"] documentWithPath:[book bookId]];
    
    
    [bookReference deleteDocumentWithCompletion:^(NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Error removing contact: %@", error);
                deleted = NO;
            }
    }];
    return deleted;
}

/**
 * Reads Documents from a collection referred to by this `FirestoreService`. If no documents exists, it
 * returns nil, else a NSMutableDictionary with the documents found.
 *
 * @param completion A block to execute once the documents have been successfully read from the
 *     server. This block will not be called while the client is offline, though local
 *     changes will be visible immediately.
 */
-(void) findAll: (void(^)(NSMutableDictionary *)) completion{
    //https://firebase.google.com/docs/firestore/query-data/listen
    [[self.firestore collectionWithPath:@"Books"] addSnapshotListener:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
        if(snapshot != nil){
            NSLog(@"Found %li documents in the db", [snapshot count]);
            if(completion){
                NSMutableDictionary *bookDictionary = [NSMutableDictionary new];
                for (FIRQueryDocumentSnapshot* snap in [snapshot documents]) {
                    NSDictionary *bookDataDictionary = [snap data];
                      NSString *autoBookId = [snap documentID];
                 
                    [bookDictionary setObject:bookDataDictionary forKey:autoBookId];
                }
                completion(bookDictionary);
            }
        }else{
            NSLog(@"No data found");
        }
        
    }];
}

@end
