const domain = '192.168.0.11:3000';
const imagesBaseUrl = 'http://80.249.145.217/images/';
const defaultImagesUrl = 'http://80.249.145.217/images/base_image.jpg';

// User
const userRegisterUrl = "/user/registration";
const userLoginUrl = "/user/login";
const userAuthUrl = "/user/auth";

// Character
const entityAddUrl = "/entity/add";
const entityViewUrl = "/entity/view";

// Others
const mainPageDataUrl = "/main/commonData";
const uploadFileUrl = "/upload";


Uri getUrl(String url, [Map<String, dynamic> params = const {}]) {
  var uri = Uri.http(domain, url, params);
  return uri;
}
