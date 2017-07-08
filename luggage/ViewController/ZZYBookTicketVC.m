
//
//  BookViewController.m
//  luggage
//
//  Created by 张志阳 on 12/7/15.
//  Copyright © 2015 张志阳. All rights reserved.
//

#import "ZZYBookTicketVC.h"

@interface ZZYBookTicketVC ()

@end

@implementation ZZYBookTicketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ctrip.com"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.webView loadRequest:request];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
