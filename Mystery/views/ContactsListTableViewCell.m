//
//  ContactsListTableViewCell.m
//  Mystery
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactsListTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

// contact default photo
#define CONTACTDEFAULTPHOTO [UIImage imageNamed:@"ContactDefPhoto.png"]

// tableViewCell margin
#define MARGIN  4.0
// tableViewCell padding
#define PADDING 4.0

// cell photo imageView height
#define PHOTOIMGVIEW_HEIGHT  44.0
// cell display name label height
#define DISPLAYNAMELABEL_HEIGHT 22.0
// cell group label height
#define GROUPLABEL_HEIGHT    18.0
// cell phone numbers label default height
#define PHONENUMBERSLABEL_DEFAULTHEIGHT   18.0

@implementation ContactsListTableViewCell

@synthesize photoImg = _photoImg;
@synthesize displayName = _displayName;
@synthesize groupName = _groupName;
@synthesize phoneNumbersArray = _phoneNumbersArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // init contentView subViews
        // contact photo image view
        _mPhotoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, PHOTOIMGVIEW_HEIGHT, PHOTOIMGVIEW_HEIGHT)];
        // set cell content view background color clear
        _mPhotoImgView.backgroundColor = [UIColor clearColor];
        // add to content view
        [self.contentView addSubview:_mPhotoImgView];
        
        // contact display name label
        _mDisplayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mPhotoImgView.frame.origin.x + _mPhotoImgView.frame.size.width + 1.5 * PADDING, MARGIN, self.frame.size.width - 2 * MARGIN - (_mPhotoImgView.frame.size.width + 1.5 * PADDING), DISPLAYNAMELABEL_HEIGHT)];
        // set text font
        _mDisplayNameLabel.font = [UIFont boldSystemFontOfSize:22.0];
        // set cell content view background color clear
        _mDisplayNameLabel.backgroundColor = [UIColor clearColor];
        // add to content view
        [self.contentView addSubview:_mDisplayNameLabel];
        
        // contact group label
        _mGroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mDisplayNameLabel.frame.origin.x, _mDisplayNameLabel.frame.origin.y + _mDisplayNameLabel.frame.size.height + PADDING, _mDisplayNameLabel.frame.size.width, GROUPLABEL_HEIGHT)];
        // set text color and font
        _mGroupLabel.textColor = [UIColor darkGrayColor];
        _mGroupLabel.font = [UIFont systemFontOfSize:14.0];
        // set cell content view background color clear
        _mGroupLabel.backgroundColor = [UIColor clearColor];
        // add to content view
        [self.contentView addSubview:_mGroupLabel];
        
        // contact phone numbers label
        _mPhoneNumbersLabel = [[UILabel alloc] initWithFrame:_mGroupLabel.frame];
        // set text color and font
        _mPhoneNumbersLabel.textColor = [UIColor lightGrayColor];
        _mPhoneNumbersLabel.font = [UIFont systemFontOfSize:14.0];
        // set cell content view background color clear
        _mPhoneNumbersLabel.backgroundColor = [UIColor clearColor];
        // add to content view
        [self.contentView addSubview:_mPhoneNumbersLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPhotoImg:(UIImage *)photoImg{
    // set photo image
    _photoImg = photoImg;
    
    // check photo image
    if (photoImg) {
        // set photo image view image
        _mPhotoImgView.image = photoImg;
        
        // set photo image view layer
        _mPhotoImgView.layer.cornerRadius = 4.0;
        _mPhotoImgView.layer.masksToBounds = YES;
    }
    else {
        // set photo image view default image
        _mPhotoImgView.image = CONTACTDEFAULTPHOTO;
        
        // recover photo image view layer
        _mPhotoImgView.layer.cornerRadius = 0.0;
        _mPhotoImgView.layer.masksToBounds = NO;
    }
}

- (void)setDisplayName:(NSString *)displayName{
    // set display name text
    _displayName = displayName;
    
    // set display name label text
    _mDisplayNameLabel.text = displayName;
}

- (void)setGroupName:(NSString *)groupName{
    //NSLog(@"setGroupName - group name = %@", groupName);
    
    // set group text
    _groupName = groupName ? groupName : nil;
    
    // set group label text
    _mGroupLabel.text = groupName ? groupName : nil;
}

- (void)setPhoneNumbersArray:(NSArray *)phoneNumbersArray{
    // set phone number array
    _phoneNumbersArray = phoneNumbersArray;
    
    // set phone number label number of lines
    _mPhoneNumbersLabel.numberOfLines = ([phoneNumbersArray count] == 0) ? 1 : [phoneNumbersArray count];
    
    // update phone number label frame
    _mPhoneNumbersLabel.frame = CGRectMake(_mGroupLabel.frame.origin.x, _groupName ? _mGroupLabel.frame.origin.y + _mGroupLabel.frame.size.height + PADDING : _mGroupLabel.frame.origin.y, _mGroupLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT * _mPhoneNumbersLabel.numberOfLines);
    
    // set phone number label text
    _mPhoneNumbersLabel.text = [phoneNumbersArray getContactPhoneNumbersDisplayTextWithStyle:vertical];
}

+ (CGFloat)cellHeightWithContact:(ContactBean *)pContact{
    // set tableViewCell default height
    CGFloat _ret = 2 * /*top margin*/MARGIN + /*photo image view height*/PHOTOIMGVIEW_HEIGHT;
    
    // check contact group and phone numbers
    if (pContact.groups) {
        _ret += GROUPLABEL_HEIGHT;
        
        // bottom added padding
        _ret += PADDING;
    }
    if (pContact.phoneNumbers && [pContact.phoneNumbers count] > 1) {
        _ret += ([pContact.phoneNumbers count] - 1) * PHONENUMBERSLABEL_DEFAULTHEIGHT;
    }
    
    return _ret;
}

@end
