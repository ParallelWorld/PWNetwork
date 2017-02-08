network组件支持的功能列表：

### 已完成

- 请求的回调可自由组合

```
/// success回调
- (PWNRequest *)onSuccess:(nullable PWNSuccessBlock)block;

/// failure回调
- (PWNRequest *)onFailure:(nullable PWNFailureBlock)block;

/// progress回调
- (PWNRequest *)onProgress:(nullable PWNProgressBlock)block;

/// completion回调
- (PWNRequest *)onCompletion:(nullable PWNCompletionBlock)block;
```

```
[[[[request onSuccess:^(id  _Nullable responseObject) {

}] onFailure:^(NSError * _Nullable error) {

}] onProgress:^(NSProgress * _Nonnull progress) {

}] onCompletion:^(id  _Nullable responseObject, NSError * _Nullable error) {

}];
```
- 支持请求失败时的自动重连
- 可取消进行中的网络请求
- 支持RESTful Server API，提供多种不同请求和响应的序列化类型
- 打印请求的header、body、parameters和response等，可根据不同级别来打印，比如error或者info，并且与网络层的代码解耦。


### 待完成

[ ] 可配置多个公共host，request的公共host、header和parameter等

[ ] 根据不同的网络状态设置不同的超时时间

[ ] 支持请求和响应的hook，包括请求的预处理、响应结果的预处理等

[ ] 支持batch和chain请求

[ ] 支持上传和下载功能，提供进度回调

[ ] 支持HTTPS

[ ] 能够监听到网络状态的变化，3G变WIFI等。根据不同的网络状态，可以对超时时间和请求最大并发数做不同的限制

[ ] 能够设置缓存，缓存可以选择时间，缓存位置等

[ ] 屏蔽对底层第三方网络库的依赖

[ ] 支持socket

[ ] 断点下载和上传

[ ] 流量统计

[ ] 网络层缓存

[ ] 支持cocoapods

[ ] 完善的单元测试用例

[ ] 可替换底层网络层的实现
