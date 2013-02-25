//
//  DetailViewController.h
//  runTimeApi
//
//  Created by システム管理者 on 12/10/22.
//  Copyright (c) 2012年 koji.Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableArray *dataSource2;
@property (nonatomic,retain) NSMutableArray *dataSource3;
@property (nonatomic,retain) NSMutableArray *dataSource4;
@property (nonatomic,retain) NSMutableArray *dataSource5;
@property (nonatomic,retain) NSIndexPath *currentIndexPath;
@property (nonatomic,retain) NSString *className;
@property (nonatomic,retain) NSString *superClassName;
@end
