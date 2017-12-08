//
//  ZCBaseRequest.m
//  Network
//
//  Created by dongzhicheng on 2017/12/5.
//  Copyright © 2017年 dongzhicheng. All rights reserved.
//

#import "ZCBaseRequest.h"
#import "Reachability.h"


@interface ZCBaseRequest ()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@end

@implementation ZCBaseRequest

- (instancetype)init{
    if (self = [super init]) {
        [self initHTTPSessionManager];
    }
    return self;
}

- (instancetype)initWithParams:(NSMutableDictionary *)params{
    if ([super init]) {
        [self initHTTPSessionManager];
    }
    return self;
}

- (void)requestCompletionWithSuccessBlock:(ZCRequestSuccessBlock)successBlock failedBlock:(ZCRequestFailedBlock)failedBlock{
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
}

- (void)startRequest{
    BOOL isNetworkError = [[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus] == NotReachable ? YES : NO;
    if (isNetworkError) {
        NSLog(@"无网络连接");
        return;
    }
    

}

- (void)initHTTPSessionManager{
    self.timeoutInterval = 10.0;
    self.sessionManager = [AFHTTPSessionManager manager];

    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
}

- (void)constructURL{
    self.url = [NSString stringWithFormat:@"%@%@",@"baidu.com", self.requestURL];
}

- (void)constructSessionTask{
    self.sessionTask = [self sessionTask];
    [self.sessionTask resume];
}

- (NSURLSessionTask *)sessionTask{
    NSError * __autoreleasing requestSerializerError = nil;
    
    ZCReqestMethod method = [self requestMethod];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.requestArguments ];
    [self baseParams:params];
    
    AFConstructingBodyBlock contructingBodyBlock = [self constructionBodyBlock];
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializer];
    
    switch (method) {
        case ZCReqestMethodGet:{
                return [self dataTaskWithHTTPMethod:@"GET" requestSerializer:requestSerializer URLString:[self requestURL] parameters:params uploadProgress:nil downloadProgress:nil constructingBodyWithBlock:nil error:&requestSerializerError];
            }
        case ZCReqestMethodPost:{
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:[self requestURL] parameters:params uploadProgress:self.progressBlock downloadProgress:nil constructingBodyWithBlock:contructingBodyBlock error:&requestSerializerError];
        }
        default:
            break;
    }
    
    return nil;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)param
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData>formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error{
    NSURLRequest *request = nil;
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:param constructingBodyWithBlock:block error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:param error:error];
    }
    
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:uploadProgress downloadProgress:downloadProgress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleResponse:response responseObject:responseObject error:error];
    }];
    
    return dataTask;
}

- (void)handleResponse:(id)response responseObject:(id)responseObj error:(NSError *)error{
    if () {
        statements
    }
    
}

- (void)handleResponseData:(id)responseData{
    
}

/**
 公共参数
 */
- (void)baseParams:(NSMutableDictionary *)param{

}

- (AFHTTPRequestSerializer *)requestSerializer{
    AFHTTPRequestSerializer *requesstSerializer = nil;
    switch ([self requestSerializerType]) {
        case ZCRequestSerializerTypeHTTP:
            requesstSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case ZCRequestSerializerTypeJSON:
            requesstSerializer = [AFJSONRequestSerializer serializer];
            break;
        default:
            break;
    }
    
    requesstSerializer.timeoutInterval = self.timeoutInterval;
    NSDictionary<NSString *, NSString *> *headreFieldValue = [self requestHeadreFieldValueDictionary];
    if (headreFieldValue != nil) {
        [headreFieldValue enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [requesstSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    return requesstSerializer;
}

#pragma mark -

- (NSString *)requestURL{
    NSAssert([self isMemberOfClass:[ZCBaseRequest class]], @"子类必须实现requestURL");
    return nil;
}

- (NSDictionary *)requestArguments{
    NSAssert([self isMemberOfClass:[ZCBaseRequest class]], @"子类必须实现requestURL");
    return nil;
}

- (ZCReqestMethod)requestMethod{
    return ZCReqestMethodPost;
}

- (ZCRequestSerializerType)requestSerializerType{
    return ZCRequestSerializerTypeHTTP;
}

- (ZCResponseSerializerType)responseSerializerType{
    return ZCResponseSerializerTypeJSON;
}

- (NSDictionary<NSString *,NSString *> *)requestHeadreFieldValueDictionary{
    return nil;
}

@end

