//
//  RootTableViewController.m
//  LearningOpenGL ES2.0
//
//  Created by fjq on 2017/12/14.
//  Copyright © 2017年 fjq. All rights reserved.
//

#import "RootTableViewController.h"
#import "Ch2_1_ViewController.h"
#import "Ch2_2_ViewController.h"
#import "Ch3_1_ViewController.h"
#import "Ch3_2_ViewController.h"
#import "Ch3_3_ViewController.h"

@interface RootTableViewController ()
{
    NSArray *array;
}

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"OpenGL ES2.0";
    array = @[@"2_1 绘制三角形",
              @"2_2 GLKView是怎么工作的",
              @"3_1 纹理",
              @"3_2 GLKTextureLoader是怎样工作的",
              @"3_3 纹理取样模式循环模式"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = array[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseViewController *bvc;
    
    switch (indexPath.row) {
        case 0: {
            bvc = (BaseViewController *)[[Ch2_1_ViewController alloc]init];
        }
            break;
        case 1: {
            bvc = (BaseViewController *)[[Ch2_2_ViewController alloc]init];
        }
            break;
        case 2: {
            bvc = (BaseViewController *)[[Ch3_1_ViewController alloc]init];
        }
            break;
        case 3: {
            bvc = (BaseViewController *)[[Ch3_2_ViewController alloc]init];
        }
            break;
        case 4: {
            bvc = (BaseViewController *)[[Ch3_3_ViewController alloc]initWithNibName:@"Ch3_3_ViewController" bundle:nil];
        }
            break;
        default:
            break;
    }
    bvc.navTitle = array[indexPath.row];
    [self.navigationController pushViewController:bvc animated:YES];
}

@end
