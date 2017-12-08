//
//  ZCBaseRequest.h
//  Network
//
//  Created by dongzhicheng on 2017/12/5.
//  Copyright © 2017年 dongzhicheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef  NS_ENUM(NSInteger, ZCReqestMethod) {
    ZCReqestMethodGet = 0,
    ZCReqestMethodPost,
};

typedef NS_ENUM(NSInteger, ZCRequestSerializerType) {
    ZCRequestSerializerTypeHTTP = 0,
    ZCRequestSerializerTypeJSON,
    
};

typedef NS_ENUM(NSInteger, ZCResponseSerializerType) {
    ZCResponseSerializerTypeHTTP,
    ZCResponseSerializerTypeJSON,
    ZCResponseSerializerTypeXMLParser,
    
};

@protocol AFMultipartFormData;

typedef void (^AFConstructingBodyBlock) (id<AFMultipartFormData> formdata);
typedef void (^AFURLSessionTaskProgressBlock) (NSProgress *);

@class ZCBaseRequest;

typedef void (^ZCRequestSuccessBlock) (NSInteger stateCode, NSDictionary *responseDic, id model);
typedef void (^ZCRequestFailedBlock) (NSError *error);

@protocol ZCRequestDelegate <NSObject>

@optional

- (void)requestFinishWithResponseDic:(NSDictionary *)reponseDic stateCode:(NSInteger)stateCode;

- (void)requestWillDealloc:(ZCBaseRequest *)request;

@end

@interface ZCBaseRequest : NSObject
@property (nonatomic, assign) BOOL isShowHUD;

@property (nonatomic, weak) id <ZCRequestDelegate> delegate;

@property (nonatomic, copy) AFConstructingBodyBlock constructionBodyBlock;
@property (nonatomic, copy) AFURLSessionTaskProgressBlock progressBlock;

@property (nonatomic, copy) ZCRequestSuccessBlock successBlock;
@property (nonatomic, copy) ZCRequestFailedBlock failedBlock;

- (instancetype)initWithParams:(NSMutableDictionary *)params;

/**
 网络请求完成的回调

 @param successBlock 请求成功的回调
 @param failedBlock  请求失败的回调
 */
- (void)requestCompletionWithSuccessBlock:(ZCRequestSuccessBlock)successBlock failedBlock:(ZCRequestFailedBlock)failedBlock;

/**
  发起网络请求 必须实现的方法
 */
- (void)startRequest;

/**
 @brief请求的URL地址（子地址）
 @warning 必须实现
 */
- (NSString *)requestURL;

/**
 请求的参数字典
 */
- (NSDictionary *)requestArguments;

/**
 请求的方式
 默认POST 子类按需重写
 */
- (ZCReqestMethod)requestMethod;

/**
 请求序列类型
 子类按需重写
 */
- (ZCRequestSerializerType)requestSerializerType;

/**
 响应序列类型
 子类按需重写
 */
- (ZCResponseSerializerType)responseSerializerType;

/**
 请求头
 子类按需重写
 */
- (NSDictionary<NSString *, NSString *> *)requestHeadreFieldValueDictionary;

/**
 处理请求完成后的数据
 */
- (void)handleResponseData:(id)responseData;

@end
