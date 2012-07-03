//
//  ContactsListViewController.m
//  Mystery
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactsListViewController.h"

#import "ContactsListContainerView.h"

#import "CommonToolkit/CommonToolkit.h"

// ContactsListViewController extension
@interface ContactsListViewController ()

// contactsListViewController test
- (void)contactsListViewControllerTest;

@end




@implementation ContactsListViewController

- (id)init{
    return [super initWithCompatibleView:[[ContactsListContainerView alloc] init]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)contactsListViewControllerTest{
    NSLog(@"contactsListViewController test");
}

@end
