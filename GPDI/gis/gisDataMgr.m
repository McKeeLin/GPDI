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
    [soap appendString:@"<soap:Envelope "];
    [soap appendString:@"xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "];
    [soap appendString:@"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "];
    [soap appendString:@"xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"];
    [soap appendString:@"<soap:Body>"];
    [soap appendFormat:@"<%@ xmlns=\"http://webservice.gpdi.com/\">", message];
    NSString *p0 = [Utility jsonStringWithDictionary:params];
    NSString *p = [p0 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    p = [Utility URLEncode:p0];
    [soap appendFormat:@"<parameters>%@</parameters>", p];
    [soap appendFormat:@"</%@>", message];
    [soap appendString:@"</soap:Body>"];
    [soap appendString:@"</soap:Envelope>"];
    NSLog(@"soap body:\n%@", soap);
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
    NSString *json = @"";
    NSString *response = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    if( response ){
        response = [response stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        NSRange r1 = [response rangeOfString:@"<return>"];
        NSRange r2 = [response rangeOfString:@"</return>"];
        json = [response substringWithRange:NSMakeRange(r1.location+r1.length, r2.location - r1.location - r1.length)];
    }
    if( _block ){
        _block(response, nil);
    }
    NSLog(@"%s, response\n%@\njson:\n%@", __func__, response, json);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if( _block ){
        _block(nil, error.localizedDescription);
    }
    NSLog(@"%@", error.localizedDescription);
}

/*
 <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns1:findNaviAllRoutePointsResponse xmlns:ns1="http://webservice.gpdi.com/"><return>{"root":[{"code":"code-303","id":303,"name":"正门","type":0,"x":113.39794759131,"y":23.176901233015},{"code":"code-314","id":314,"name":"研发楼A座门口","type":0,"x":113.3976978199,"y":23.178923575715},{"code":"code-315","id":315,"name":"研发楼B座门口","type":0,"x":113.39747221992,"y":23.17922974712},{"code":"code-337","id":337,"name":"凉亭01","type":0,"x":113.39698441748,"y":23.177725075809},{"code":"code-355","id":355,"name":"凉亭02","type":0,"x":113.39637207467,"y":23.178901418575},{"code":"code-386","id":386,"name":"玻璃房","type":0,"x":113.39488415055,"y":23.179008175709},{"code":"code-387","id":387,"name":"研发楼C座门口","type":0,"x":113.39722613174,"y":23.17950167567},{"code":"code-389","id":389,"name":"研发楼D座门口","type":0,"x":113.39673464606,"y":23.179924675637},{"code":"code-391","id":391,"name":"研发楼E座门口","type":0,"x":113.3963801318,"y":23.180142218478},{"code":"code-398","id":398,"name":"码头1","type":0,"x":113.39708110317,"y":23.180013304202},{"code":"code-408","id":408,"name":"创新中心B座门口","type":0,"x":113.39472168411,"y":23.177741190093},{"code":"code-409","id":409,"name":"创新中心A座门口","type":0,"x":113.39486671267,"y":23.17827296148},{"code":"code-414","id":414,"name":"创新中心C座门口","type":0,"x":113.3946857723,"y":23.177126832999},{"code":"code-416","id":416,"name":"篮球场","type":0,"x":113.39499395799,"y":23.177138918712},{"code":"code-422","id":422,"name":"数据中心C座门口","type":0,"x":113.39391061771,"y":23.17707647586},{"code":"code-424","id":424,"name":"数据中心B座门口","type":0,"x":113.39395090343,"y":23.177793561519},{"code":"code-426","id":426,"name":"数据中心A座门口","type":0,"x":113.39411607484,"y":23.178482447179},{"code":"code-428","id":428,"name":"服务中心A座门口","type":0,"x":113.39442627482,"y":23.179179389982},{"code":"code-438","id":438,"name":"合作交流中心A座门口","type":0,"x":113.39669067712,"y":23.181832204061},{"code":"code-440","id":440,"name":"合作交流中心B座门口","type":0,"x":113.39617502002,"y":23.182106146897},{"code":"code-442","id":442,"name":"合作交流中心C座门口","type":0,"x":113.3955787915,"y":23.181993346905},{"code":"code-449","id":449,"name":"合作交流中心E座门口","type":0,"x":113.39502250334,"y":23.181056704122},{"code":"code-452","id":452,"name":"合作交流中心D座门口","type":0,"x":113.39490567478,"y":23.18138301838},{"code":"code-467","id":467,"name":"服务中心B座门口","type":0,"x":113.39373336058,"y":23.179501675671},{"code":"code-484","id":484,"name":"网球场","type":0,"x":113.39744367458,"y":23.18120173268},{"code":"code-494","id":494,"name":"码头2","type":0,"x":113.39855924343,"y":23.17860632574},{"code":"code-497","id":497,"name":"码头3","type":0,"x":113.39823764844,"y":23.179954889922}],"success":true,"msg":"success"}</return></ns1:findNaviAllRoutePointsResponse></soap:Body></soap:Envelope>
 */

@end
