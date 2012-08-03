//
//  ContactsListContainerView.m
//  Mystery
//
//  Created by  on 12-6-27.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactsListContainerView.h"

#import "CommonToolkit/CommonToolkit.h"

// ContactsListView extension
@interface ContactsListContainerView ()

// contactsListContainerView test
- (void)contactsListContainerViewTest;

@end




@implementation ContactsListContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // set title
        self.title = NSLocalizedString(@"all contacts list view title", nil);
        
        // set test right bar button item
        //self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleBordered target:self action:@selector(contactsListContainerViewTest)];
        
        // get UIScreen bounds
        CGRect _screenBounds = [[UIScreen mainScreen] bounds];
        
        // update contacts list container view frame
        self.frame = CGRectMake(_screenBounds.origin.x, _screenBounds.origin.y, _screenBounds.size.width, _screenBounds.size.height - /*statusBar height*/[CommonUtils appStatusBarHeight] - /*navigationBar height*/[CommonUtils appNavigationBarHeight]);
        
        // init subviews and set their attributes
        // init addressBook contacts list table view
        _mABContactsListView = [[ABContactsListView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - CONTACTSSEARCH_TOOLBAR_HEIGHT)];
        // init contacts process toolbar
        _mContactsProcessToolbar = [[ContactsProcessToolbar alloc] initWithFrame:CGRectMake(_mABContactsListView.frame.origin.x, self.frame.size.height - CONTACTSSEARCH_TOOLBAR_HEIGHT, _mABContactsListView.frame.size.width, CONTACTSSEARCH_TOOLBAR_HEIGHT)];
        
        // add addressBook contacts list table view and contacts process toolbar to contacts list container view
        [self addSubview:_mABContactsListView];
        [self addSubview:_mContactsProcessToolbar];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)searchContactWithParameter:(NSString *)pParameter{
    // check search parameter
    if ([pParameter isEqualToString:@""]) {
        // reset contact matching index array
        for (ContactBean *_contact in _mABContactsListView.allContactsInfoArrayInABRef) {
            [_contact.extensionDic removeObjectForKey:PHONENUMBER_MATCHING_INDEXS];
            [_contact.extensionDic removeObjectForKey:NAME_MATCHING_INDEXS];
        }
        
        // show all contacts in addressBook
        _mABContactsListView.presentContactsInfoArrayRef = [NSMutableArray arrayWithArray:_mABContactsListView.allContactsInfoArrayInABRef];
    }
    else {
        // define temp array
        NSArray *_tmpArray = nil;
        
        // check softKeyboard type
        switch (_mContactsProcessToolbar.softKeyboardType) {
            case custom:
                // search by phone number
                _tmpArray = [[AddressBookManager shareAddressBookManager] getContactByPhoneNumber:pParameter];
                break;
                
            case iosSystem:
                // search by name
                _tmpArray = [[AddressBookManager shareAddressBookManager] getContactByName:pParameter];
                break;
        }
        
        // define searched contacts array
        NSMutableArray *_searchedContactsArray = [[NSMutableArray alloc] initWithCapacity:[_tmpArray count]];
        
        // compare seached contacts temp array contact with all contacts info array in addressBook contact  
        for (ContactBean *_searchedContact in _tmpArray) {
            for (ContactBean *_contact in _mABContactsListView.allContactsInfoArrayInABRef) {
                // if the two contacts id is equal, add it to searched contacts array
                if (_contact.id == _searchedContact.id) {
                    [_searchedContactsArray addObject:_searchedContact];
                    
                    // check softKeyboard type and reset searched contact matching index array
                    switch (_mContactsProcessToolbar.softKeyboardType) {
                        case custom:
                            [_contact.extensionDic removeObjectForKey:NAME_MATCHING_INDEXS];
                            break;
                            
                        case iosSystem:
                            [_contact.extensionDic removeObjectForKey:PHONENUMBER_MATCHING_INDEXS];
                            break;
                    }
                    
                    break;
                }
            }
        }
        
        // set addressBook contacts list view present contacts info array
        _mABContactsListView.presentContactsInfoArrayRef = _searchedContactsArray;
    }
    
    // reload addressBook contacts list table view data
    [_mABContactsListView reloadData];
}

- (void)hideSoftKeyboardWhenBeginScroll{
    // check softKeyboard it is hidden
    if (!_mContactsProcessToolbar.softKeyboardHidden) {
        [_mContactsProcessToolbar performSelector:@selector(indicateSoftKeyboard)];
    }
}

- (void)contactsListContainerViewTest{
    NSLog(@"contactsListContainerView test");
    
    if ([self validateViewControllerRef:self.viewControllerRef andSelector:@selector(contactsListViewControllerTest)]) {
        [self.viewControllerRef performSelector:@selector(contactsListViewControllerTest)];
    }
}

@end
