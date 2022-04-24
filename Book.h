//
//  Book.h
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property NSString* bookId;
@property NSString* name;
@property NSString* update;
@property NSString* page;
@property NSString* total;
@property NSString* type;
@property NSString* photo;


// constructor
-(instancetype) initWithName : (NSString*) name
                       update : (NSString*) update
                         page : (NSString*) page
                        total : (NSString*) total
                         type : (NSString*) type
                        photo : (NSString*) photo
                       bookId : (NSString*) bookId;

- (instancetype)initWithDictionary: (NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END
