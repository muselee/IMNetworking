# IMNetworking
IMNetworking is a high level request util based on AFNetworking

Service_Config.xml 请求配置xml 


<Service>
<Urls>

<Url Name="url1">1111111111111111111</Url>  
<Url Name="url2">http://www.perasst.com:8081/</Url>

</Urls>

<Defaults

Method="POST"
Timeout="1"
TimeoutMessage="超时"
FailbackMessage="网络错误"
IsLoggingEnabled="YES"/>

<ServiceMethods>

<ServiceMethod
Name="Login"
Method="POST"
Parameters="userName,password"
Url="[url2]perasst_v2/user/login.pa"
ReturnType="LoginApi"/>


</ServiceMethods>


</Service>


请求发起
+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password susessCallBack:(void (^)(LoginApi *))successCallBack failCallback:(void (^)(ServiceError *))failCallback
{
        Request * request=[Request create:@"Login" parameterValues:@[userName,password]];
        [request send:successCallBack failCallback:failCallback];
}
解析
+ (NSDictionary *)replacedKeyFromPropertyName{
      return @{
               @"email":@"res.email"
              };
}

IMNetworking 基于 AFNetworking 和 MJExtension 进行开发，感谢他们对开源社区做出的贡献。