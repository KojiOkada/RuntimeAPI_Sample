//
//  ViewController.h
//  runTimeApi
//
//  Created by システム管理者 on 12/10/22.
//  Copyright (c) 2012年 koji.Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSIndexPath *currentIndexPath;
@end
