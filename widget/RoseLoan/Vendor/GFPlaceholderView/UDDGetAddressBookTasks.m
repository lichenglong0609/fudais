//
//  UDDGetAddressBookTasks.m
//  UddTrip
//
//  Created by Chuan Liu on 16/9/3.
//  Copyright © 2016年 scandy. All rights reserved.
//

#import "UDDGetAddressBookTasks.h"
#import <AddressBook/AddressBook.h>
#import "UDDAddressBookData.h"

@interface UDDGetAddressBookTasks ()

@property (nonatomic, copy) void (^callbackHandler)( BOOL success, NSArray *userArray,NSArray *titleArray);

@end

@implementation UDDGetAddressBookTasks

+ (void)startGetAddressBookCallBackIndex:(NSInteger)index callBack:(void (^)(BOOL success, NSArray *userArray,NSArray *titleArray ))actionHandler{
    UDDGetAddressBookTasks *queueTask = [[UDDGetAddressBookTasks alloc]init];
    queueTask.callbackHandler = actionHandler;
    [[SFQueueTasksManager sharedQueueTasksManager] addTask:queueTask];
    [queueTask startGetAddressBook:index];
}

- (void)startGetAddressBook:(NSInteger )index{

    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip=0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        //创建通讯簿的引用
        addBook=ABAddressBookCreateWithOptions(NULL, NULL);
        //创建一个出事信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        //IOS6之前
        addBook =ABAddressBookCreate();
    }
    if (tip) {
        //做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>通用>隐私" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        
        if (self.callbackHandler) {
            self.callbackHandler(NO,nil,nil);
        }
        
        [[SFQueueTasksManager sharedQueueTasksManager]removeTask:self];
        return;
    }else{
    
        
        
        NSMutableArray *userArray = [[NSMutableArray alloc]init];
        
        //获取所有联系人的数组
        CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
        //获取联系人总数
        CFIndex number = ABAddressBookGetPersonCount(addBook);
        //进行遍历
        for (NSInteger i=0; i<(number>index?index:number); i++) {
            //获取联系人对象的引用
            
            UDDAddressBookData *userData = [[UDDAddressBookData alloc]init];
            
            ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
            //获取当前联系人名字
            NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
            
            NSString*lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
            
            userData.userName = [NSString stringWithFormat:@"%@%@",[UITool strOrEmpty:lastName],[UITool strOrEmpty:firstName]];
            NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
            ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
            for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
                [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
            }
            userData.phoneArray = phoneArr;
            
            [userArray addObject:userData];
        }
        
        
        
        //对联系人进行分组和排序
        UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
        NSInteger highSection = [[theCollation sectionTitles] count]; //中文环境下返回的应该是27，是a－z和＃，其他语言则不同
        
        //_indexArray 是右侧索引的数组，也是secitonHeader的标题
       NSMutableArray *_indexArray = [[NSMutableArray alloc] initWithArray:[theCollation sectionTitles]];
        
        NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:highSection];
        //初始化27个空数组加入newSectionsArray
        for (NSInteger index = 0; index < highSection; index++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [newSectionsArray addObject:array];
        }
        
        for (UDDAddressBookData *addressBook in userArray) {
            //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
            
            NSLog(@"addre----%@",addressBook.userName);
            
            
            if ([addressBook.userName length] == 0) {
                
                NSMutableArray *sectionNames = [newSectionsArray lastObject];
                [sectionNames addObject:addressBook];
                
            }else{
            
                NSInteger sectionNumber = [theCollation sectionForObject:addressBook collationStringSelector:@selector(getFirstLetter)];
                //把name加入newSectionsArray中的第11个数组中去
                NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
                [sectionNames addObject:addressBook];
            }
            
            
        }
        
        for (int i = 0; i < newSectionsArray.count; i++) {
            NSMutableArray *sectionNames = newSectionsArray[i];
            if (sectionNames.count == 0) {
                [newSectionsArray removeObjectAtIndex:i];
                [_indexArray removeObjectAtIndex:i];
                i--;
            }  
        }  
        
        //_contacts 是联系人数组（确切的说是二维数组）
        
        NSMutableArray *emptyUserArray = [[NSMutableArray alloc]init];
        NSMutableArray *emptyTitleArray = [[NSMutableArray alloc]init];
        
        for (int m = 0; m < [newSectionsArray count]; m++) {
            
            if ([[newSectionsArray objectAtIndex:m] count] == 0) {
                
                [emptyUserArray addObject:[newSectionsArray objectAtIndex:m]];
                [emptyTitleArray addObject:[_indexArray objectAtIndex:m]];
            }
        }
        
        for (int j = 0; j < [emptyTitleArray count]; j++) {
            [newSectionsArray removeObject:[emptyUserArray objectAtIndex:j]];
            [_indexArray removeObject:[emptyTitleArray objectAtIndex:j]];
        }
        

        if (self.callbackHandler) {
            self.callbackHandler(YES,newSectionsArray,_indexArray);
        }
        
        [[SFQueueTasksManager sharedQueueTasksManager]removeTask:self];
    }
}


@end
