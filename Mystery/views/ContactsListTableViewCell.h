//
//  ContactsListTableViewCell.h
//  Mystery
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonToolkit/CommonToolkit.h"

@interface ContactsListTableViewCell : UITableViewCell {
    // contact photo imageView
    UIImageView *_mPhotoImgView;
    // contact display name label
    UILabel *_mDisplayNameLabel;
    // contact group label
    UILabel *_mGroupLabel;
    // contact phone numbers display label
    UILabel *_mPhoneNumbersLabel;
}

// contact photo imageView photo image
@property (nonatomic, retain) UIImage *photoImg;
// contact display name label text
@property (nonatomic, retain) NSString *displayName;
// contact group label text
@property (nonatomic, retain) NSString *groupName;
// contact phone numbers array
@property (nonatomic, retain) NSArray *phoneNumbersArray;

// get the height of the contacts list tableViewCell with contactBean object
+ (CGFloat)cellHeightWithContact:(ContactBean *)pContact;

@end
