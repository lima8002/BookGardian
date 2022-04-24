//
//  FirestoreService.h
//  ContactsFirebaseApp1
//
//  Created by Eduardo Lima on 12/04/22.
//

#import <Foundation/Foundation.h>
@import Firebase;
@import FirebaseFirestore;
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirestoreService : NSObject

@property (nonatomic, strong) FIRFirestore *firestore;

-(BOOL) addBook: (Book*) book;
-(BOOL) updateBook: (Book*) book;
-(BOOL) deleteBook: (Book*) book;
-(void) findBookById: (NSString* ) bookId completeBlock: (void(^)(Book *)) completion;
-(void) findAll: (void(^)(NSMutableDictionary *)) completion;

@end

NS_ASSUME_NONNULL_END
