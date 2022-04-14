//
//  Book.m
//  BookGardian
//
//  Created by Eduardo Lima on 10/4/2022.
//

#import "Book.h"

@implementation Book

// initialize the constructor
-(instancetype) initWithPhoto : (UIImage*) photo
                         name : (NSString*) name
                       update : (NSString*) update
                         page : (NSString*) page
                        total : (NSString*) total
                         type : (NSString*) type
                       idBook : (NSString*) idBook;
{
    self = [super init];
    if (self) {
        _photo = photo;
        _name = name;
        _update = update;
        _page = page;
        _total = total;
        _type = type;
        _idBook = idBook;
    }
    return self;
}

@end
