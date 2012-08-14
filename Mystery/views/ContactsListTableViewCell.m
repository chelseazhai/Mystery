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

// matching text color
#define MATCHINGTEXTCOLOR   [UIColor blueColor]

@implementation ContactsListTableViewCell

@synthesize uniqueIdentifier = _mId;

@synthesize photoImg = _mPhotoImg;
@synthesize displayName = _mDisplayName;
@synthesize groupName = _mGroupName;
@synthesize phoneNumbersArray = _mPhoneNumbersArray;

@synthesize phoneNumberMatchingIndexs = _mPhoneNumberMatchingIndexs;
@synthesize nameMatchingIndexs = _mNameMatchingIndexs;

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
        _mDisplayNameLabel = [[UIAttributedLabel alloc] initWithFrame:CGRectMake(_mPhotoImgView.frame.origin.x + _mPhotoImgView.frame.size.width + 1.5 * PADDING, MARGIN, self.frame.size.width - 2 * MARGIN - (_mPhotoImgView.frame.size.width + 1.5 * PADDING), DISPLAYNAMELABEL_HEIGHT)];
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
    _mPhotoImg = photoImg;
    
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
    _mDisplayName = displayName;
    
    // set display name label text
    //_mDisplayNameLabel.text = displayName;
    NSMutableAttributedString *_attributedDisplayName = [NSMutableAttributedString attributedStringWithString:displayName];
    // set font
    [_attributedDisplayName setFont:[UIFont boldSystemFontOfSize:18.0]];
    // set display name attributed label attributed text
    _mDisplayNameLabel.attributedText = _attributedDisplayName;
}

- (void)setGroupName:(NSString *)groupName{
    //NSLog(@"setGroupName - group name = %@", groupName);
    
    // set group text
    _mGroupName = groupName ? groupName : nil;
    
    // set group label text
    _mGroupLabel.text = groupName ? groupName : nil;
}

- (void)setPhoneNumbersArray:(NSArray *)phoneNumbersArray{
    // set phone number array
    _mPhoneNumbersArray = phoneNumbersArray;
    
    // set phone number label number of lines
    _mPhoneNumbersLabel.numberOfLines = ([phoneNumbersArray count] == 0) ? 1 : [phoneNumbersArray count];
    
    // update phone number label frame
    _mPhoneNumbersLabel.frame = CGRectMake(_mGroupLabel.frame.origin.x, _mGroupName ? _mGroupLabel.frame.origin.y + _mGroupLabel.frame.size.height + PADDING : _mGroupLabel.frame.origin.y, _mGroupLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT * _mPhoneNumbersLabel.numberOfLines);
    
    // set phone number label text
    _mPhoneNumbersLabel.text = [phoneNumbersArray getContactPhoneNumbersDisplayTextWithStyle:vertical];
}

- (void)setPhoneNumberMatchingIndexs:(NSArray *)phoneNumberMatchingIndexs{
    // set phone number matching index array
    _mPhoneNumberMatchingIndexs = phoneNumberMatchingIndexs;
    
    // process phone numbers matching index array
    if (phoneNumberMatchingIndexs) {
        // set phone number attributed label parent view
        if (_mPhoneNumbersAttributedLabelParentView) {
            for (UIView *_view in _mPhoneNumbersAttributedLabelParentView.subviews) {
                [_view removeFromSuperview];
            }
            [_mPhoneNumbersAttributedLabelParentView removeFromSuperview];
        }
        _mPhoneNumbersAttributedLabelParentView = [[UIView alloc] initWithFrame:_mPhoneNumbersLabel.frame];
        
        // process each phone number
        for (NSInteger _index = 0; _index < [_mPhoneNumbersArray count]; _index++) {
            // generate attributed string with phone number
            NSMutableAttributedString *_attributedPhoneNumber = [NSMutableAttributedString attributedStringWithString:[_mPhoneNumbersArray objectAtIndex:_index]];
            // set font
            [_attributedPhoneNumber setFont:[UIFont systemFontOfSize:14.0]];
            // set attributed phone number text color
            [_attributedPhoneNumber setTextColor:[UIColor lightGrayColor]];
            if ([phoneNumberMatchingIndexs objectAtIndex:_index] && [[phoneNumberMatchingIndexs objectAtIndex:_index] count] > 0) {
                for (NSNumber *__index in [phoneNumberMatchingIndexs objectAtIndex:_index]) {
                    [_attributedPhoneNumber setTextColor:MATCHINGTEXTCOLOR range:NSMakeRange(__index.integerValue, 1)];
                }
            }
            
            // generate each phone number attributed label and add to phone number attributed label parent view
            @autoreleasepool {
                UIAttributedLabel *_phoneNumberAttributedLabel = [[UIAttributedLabel alloc] initWithFrame:CGRectMake(0.0, _index * PHONENUMBERSLABEL_DEFAULTHEIGHT, _mPhoneNumbersLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT)];
                // set phone number attributed label attributed text
                _phoneNumberAttributedLabel.attributedText = _attributedPhoneNumber;
                // add to phone number attributed label parent view
                [_mPhoneNumbersAttributedLabelParentView addSubview:_phoneNumberAttributedLabel];
            }
        }
        
        // hide phone number label and add phone number attributed label parent view to cell content view
        _mPhoneNumbersLabel.hidden = YES;
        [self.contentView addSubview:_mPhoneNumbersAttributedLabelParentView];
    }
    else {
        // show phone number label and remove phone number attributed label parent view
        _mPhoneNumbersLabel.hidden = NO;
        for (UIView *_view in _mPhoneNumbersAttributedLabelParentView.subviews) {
            [_view removeFromSuperview];
        }
        [_mPhoneNumbersAttributedLabelParentView removeFromSuperview];
    }
}

- (void)setNameMatchingIndexs:(NSArray *)nameMatchingIndexs{
    // set name matching index array
    _mNameMatchingIndexs = nameMatchingIndexs;
    
    // process name matching index array
    if (nameMatchingIndexs) {
        // generate attributed string with display name
        NSMutableAttributedString *_attributedDisplayName = [NSMutableAttributedString attributedStringWithString:_mDisplayName];
        // set font
        [_attributedDisplayName setFont:[UIFont boldSystemFontOfSize:18.0]];
        
        // set attributed display name text color
        for (NSNumber *_index in nameMatchingIndexs) {
            [_attributedDisplayName setTextColor:MATCHINGTEXTCOLOR range:[_mDisplayName rangeOfString:[[_mDisplayName nameArraySeparatedByCharacter] objectAtIndex:_index.integerValue]]];
        }
        
        // set display name label attributed text
        _mDisplayNameLabel.attributedText = _attributedDisplayName;
    }
    else {
        // reset display name label text
        self.displayName = _mDisplayName;
    }
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
