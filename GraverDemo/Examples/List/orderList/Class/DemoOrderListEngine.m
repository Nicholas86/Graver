//
//  DemoOrderListEngine.m
//  GraverDemo
//
//  Created by jiangwei on 2018/12/5.
//

#import "DemoOrderListEngine.h"
#import "DemoOrderModel.h"
#import "WMGResultSet.h"

@implementation DemoOrderListEngine

- (void)reloadDataWithParams:(NSDictionary *)params completion:(WMGEngineLoadCompletion)completion
{
    if (_loadState == WMGEngineLoadStateLoading) {
        return;
    }
    
    _loadState = WMGEngineLoadStateLoading;
    
    NSDictionary *jsonData = [self readLocalFileWithName:@"orderlist"];
    NSArray *arr = [jsonData objectForKey:@"orderlist"];
    NSMutableArray * array = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DemoOrderModel *model = [[DemoOrderModel alloc] initWithDictionary:obj];
        [array addObject:model];
    }];
    
    [self.resultSet reset];
    [self.resultSet addItems:array];
    
    _loadState = WMGEngineLoadStateLoaded;
    
    if (completion) {
        completion(self.resultSet, nil);
    }
}

- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data ?:[NSData data] options:0 error:nil];
    
    return jsonObject;
}


@end
