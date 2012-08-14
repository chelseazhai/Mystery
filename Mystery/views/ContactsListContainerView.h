//
//  ContactsListContainerView.h
//  Mystery
//
//  Created by  on 12-6-27.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ABContactsListView.h"
#import "ContactsProcessToolbar.h"

@interface ContactsListContainerView : UIView {
    // subview addressBook contacts list table view
    ABContactsListView *_mABContactsListView;
    
    // subview contacts process toolbar
    ContactsProcessToolbar *_mContactsProcessToolbar;
}

// search contact with parameters
- (void)searchContactWithParameter;

// hide softKeyboard when contacts list table view will begin dragging
- (void)hideSoftKeyboardWhenBeginScroll;

@end
