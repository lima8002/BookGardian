//
//  Book.m
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import "Book.h"

@implementation Book

// initialize the constructor
-(instancetype) initWithName : (NSString*) name
                      update : (NSString*) update
                        page : (NSString*) page
                       total : (NSString*) total
                        type : (NSString*) type
                       photo : (NSString*) photo
                      bookId : (NSString*) bookId;
{
    self = [super init];
    if (self) {
        _name = name;
        _update = update;
        _page = page;
        _total = total;
        _type = type;
        _photo = photo;
        _bookId = bookId;
    }
    return self;
}

- (instancetype)initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        _bookId = dictionary[@"bookId"];
        _name = dictionary[@"name"];
        _update = dictionary[@"update"];
        _page = dictionary[@"page"];
        _total = dictionary[@"total"];
        _type = dictionary[@"type"];
        _photo = dictionary[@"photo"];
    }
    return self;
}

/** Method created to print out the content of a contact object */
-(NSString*) description{
    return  [NSString stringWithFormat:@"name: %@ update: %@ page: %@ total: %@  type: %@ photo: %@", _name, _update, _page, _total, _type, _photo] ;
}

@end
