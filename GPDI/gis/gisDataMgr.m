//
//  gisDataMgr.m
//  GPDI
//
//  Copyright (c) 2015年 GPDI. All rights reserved.
//

#import "gisDataMgr.h"
#import "AFNetworking.h"


@interface gisDataMgr ()<NSURLConnectionDataDelegate>
{
    SOAP_BLOCK _block;
    NSMutableData *_data;
}

@end

@implementation gisDataMgr

+ (instancetype)manager
{
    static gisDataMgr *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^(void){
        manager = [[gisDataMgr alloc] init];
    });
    return manager;
}

+ (void)asyncLogin:(NSString *)account password:(NSString *)password block:(void (^)(int, NSString *))block
{
    block( 0, @"");
}

+ (void)asyncLogout:(void (^)(int, NSString *))block
{
    ;
}

- (instancetype)init
{
    self = [super init];
    if( self ){
        _data = [[NSMutableData alloc] initWithCapacity:0];
    }
    return self;
}


- (void)doRequest
{
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<getMobileCodeInfo xmlns=\"http://WebXml.com.cn/\">"
                         "<mobileCode>%@</mobileCode>"
                         "<userID>%@</userID>"
                         "</getMobileCodeInfo>"
                         "</soap12:Body>"
                         "</soap12:Envelope>", @"13302221983", @""];
    NSURL *url = [NSURL URLWithString:@"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    [request addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@".");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"...");
    }];
    [operation start];
}

- (void)postSoap:(NSString *)soap block:(SOAP_BLOCK)block
{
    _block = block;
    NSURL *url = [NSURL URLWithString:@"http://221.176.36.38:8080/cmccbase/ws/pda"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soap length]];
    [request addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soap dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)postSoapMessage:(NSString *)message params:(NSDictionary *)params block:(SOAP_BLOCK)block
{
    _block = block;
    NSMutableString *soap = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    [soap appendString:@"<soap12:Envelope "];
    [soap appendString:@"xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "];
    [soap appendString:@"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "];
    [soap appendString:@"xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
    [soap appendString:@"<soap:Body>"];
    [soap appendFormat:@"<%@ xmlns=\"http://webservice.gpdi.com/\">", message];
    if( params ){
        for( NSString *key in params )
        {
            [soap appendFormat:@"<%@>%@</%@>",key, [params objectForKey:key], key];
        }
    }
    [soap appendString:@"</soap:Body>"];
    [soap appendString:@"</soap:Envelope>"];
    NSURL *url = [NSURL URLWithString:@"http://221.176.36.38:8080/cmccbase/ws/pda"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soap length]];
    [request addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soap dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_data setLength:0];
    NSLog(@"%s", __func__);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    NSLog(@"%s", __func__);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    if( _block ){
        _block(response, nil);
    }
    NSLog(@"%s, response\n%@", __func__, response);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if( _block ){
        _block(nil, error.localizedDescription);
    }
    NSLog(@"%@", error.localizedDescription);
}
@end
