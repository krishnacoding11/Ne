// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';
//
// String lastUrl = "";
// String lastMethod = "";
// late VoidCallback lastCallBack;
// Map<String, String> lastBody = {};
//
// class ApiService {
//   Future<http.Response?> mutliPartPostRequest({required String url, required String method, Map? data, String? document, required BuildContext mcontext}) async {
//     var result;
//     try {
//       var request = http.MultipartRequest(method, Uri.parse(url));
//       print("uri" + request.url.toString());
//       // data!.forEach((key, value) {
//       //   request.fields[key] = value.toString();
//       // });
//       request.fields["emailAddress"] = "pradip.sa1@celloip.com";
//       request.fields["MobileNumber"] = "8761234590";
//       print("uri" + request.fields.toString());
//       request.headers['Content-Type'] = 'application/json';
//       request.headers['accept'] = '*/*';
//
//       /// [FILTERING] : the null image if there are no photos in the request it will skip adding the photo in the request
//       /*if (file != null) {
//         var picture = await http.MultipartFile.fromPath("photo", file.path);
//         request.files.add(picture); //adds the photo to the request
//       }*/
//       // Checking the document if it is empty, if it is empty it will skipvar document;
//       if (document != null) {
//         var doc = await http.MultipartFile.fromPath('file', document);
//         request.files.add(doc); // adds the document to the request
//       }
//       print("uri" + request.files.toString());
//       var response = await request.send().timeout(const Duration(seconds: 20)); //sends the request body to the server
//       // result = await http.Response.fromStream(response);
//       result = await http.Response.fromStream(response);
//       // jsonResponse = result; /// returns the response according to the status code from [returnResponse] function
//     } on SocketException catch (e) {
//       _showToast(mcontext);
//       print("detail No Internet Connection" + e.toString());
//     } on TimeoutException catch (e) {
//       _showTimeout(mcontext, "We are facing some issue please after sometime");
//     }
//     return result;
//   }
//
//   void _showToast(BuildContext context) {
//     IntenetAlert(context);
//   }
//
//   void _showTimeout(BuildContext context, String msg) {
//     showTopSnackBar(
//       Overlay.of(context)!,
//       CustomSnackBar.error(
//         message: msg,
//       ),
//     );
//   }
//
//   void IntenetAlert(BuildContext context) {
//     showTopSnackBar(
//       Overlay.of(context),
//       CustomSnackBar.error(
//         message: "Please check internet.",
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as getX;
import 'package:get_storage/get_storage.dart';
import 'package:neoxapp/presentation/screen/login/login_option.dart';

import '../presentation/widgets/globle.dart';

const String somethingWrong = "Something went wrong!";
const String responseMessage = "No response data found!";
const String interNetMessage = "please check your internet connection and try again latter.";
const String connectionTimeOutMessage = "Ops.. Server not working or might be in maintenance. Please Try Again Later";
const String authenticationMessage = "The session has been expired. Please log in again.";
const String tryAgain = "Try again";

int serviceCallCount = 0;
final storage = GetStorage();

///Status Code with message type array or string
// 501 : sql related err
// 401: validation array
// 201 : string error
// 400 : string error
// 200: response, string/null
// 422: array
class Api {
  getX.RxBool isLoading = false.obs;

  call({
    required String url,
    dynamic params,
    Map<String, dynamic>? formValue,
    Map<String, dynamic>? header,
    required Function success,
    Function? error,
    ErrorMessageType errorMessageType = ErrorMessageType.snackBarOnlyError,
    MethodType methodType = MethodType.post,
    bool? isHideLoader = true,
    bool isProgressShow = false,
    bool isToken = true,
  }) async {
    if (await checkInternet()) {
      if (isProgressShow) {
        showProgressDialog(isLoading: isProgressShow);
      }

      Map<String, dynamic> headerParameters;
      headerParameters = {
        "Authorization": storage.read(ApiConfig.loginToken) != null ? "" + storage.read(ApiConfig.loginToken) : "",
      };
      headerParameters.addAll(header ?? {});
      String mainUrl = baseUri + url;
      if (kDebugMode) {
        // print("======??????   ${storage.read(ApiConfig.loginToken) }");
        // print("===headerParameters===?????? $headerParameters");
        // print("==authorization=====??????  ${headerParameters["Authorization"]}");
        // print("==params====??????  $params");
      }
      // print("======??????   $mainUrl");
      // print("=== token===??????   ${storage.read(ApiConfig.loginToken)}");

      try {
        Response response;
        if (methodType == MethodType.get) {
          response = await Dio().get(mainUrl,
              queryParameters: params,
              options: Options(
                headers: headerParameters,
                responseType: ResponseType.plain,
              ));
        } else if (methodType == MethodType.put) {
          response = await Dio().put(mainUrl,
              data: params,
              options: Options(
                headers: headerParameters,
                responseType: ResponseType.plain,
              ));
        } else if (methodType == MethodType.patch) {
          response = await Dio().patch(mainUrl,
              data: params,
              options: Options(
                headers: headerParameters,
                responseType: ResponseType.plain,
              ));
        } else if (methodType == MethodType.delete) {
          response = await Dio().delete(mainUrl,
              data: params,
              options: Options(
                headers: headerParameters,
                responseType: ResponseType.plain,
              ));
        } else {
          response = await Dio().post(mainUrl,
              data: params,
              options: Options(
                headers: headerParameters,
                responseType: ResponseType.plain,
              ));
        }

        if (handleResponse(response)) {
          if (kDebugMode) {
            print('LOGIN TOKEN ${storage.read(ApiConfig.loginToken) ?? ""}');
            print(url);
            print(params);
            print(response.data);
            //print(response);
          }

          ///postman response Code guj
          Map<String, dynamic>? responseData;
          responseData = jsonDecode(response.data);
          if (isHideLoader!) {
            hideProgressDialog();
          }

          if (responseData?["success"] == 1) {
            //#region alert
            if (errorMessageType == ErrorMessageType.snackBarOnlySuccess || errorMessageType == ErrorMessageType.snackBarOnResponse) {
              // getX.Get.snackbar("success", responseData?["message"]);

              Fluttertoast.showToast(msg: responseData?["message"]);
            }
            // else if (errorMessageType == ErrorMessageType.dialogOnlySuccess ||
            //     errorMessageType == ErrorMessageType.dialogOnResponse) {
            //   await apiAlertDialog(
            //       title: 'Error!',
            //       message: responseData?["message"],
            //       buttonTitle: "Okay");
            // }
            //#endregion alert

            print("res===${responseData?["Token"]}");

            if ((responseData?.containsKey("Token") ?? false) && (responseData?["Token"].toString().isNotEmpty ?? false)) {
              storage.write(ApiConfig.loginToken, responseData?["Token"]);
            }

            success(responseData);
          } else {
            //region 401 = Session Expired  Manage Authentication/Session Expire
            if (response.statusCode == 401 || response.statusCode == 403) {
              unauthorizedDialog(responseData?["message"]);
            } else {
              //#region alert
              if (errorMessageType == ErrorMessageType.snackBarOnlyError || errorMessageType == ErrorMessageType.snackBarOnResponse) {
                // getX.Get.snackbar("Error", responseData?["message"]);
                Fluttertoast.showToast(msg: responseData?["message"]);
              } else if (errorMessageType == ErrorMessageType.dialogOnlyError || errorMessageType == ErrorMessageType.dialogOnResponse) {
                await apiAlertDialog(title: 'Error!', message: responseData?["message"], buttonTitle: "Okay");
              }
              if (error != null) {
                //#endregion alert
                debugPrint("data ===fdfdf=====>${responseData?["message"]}");
                error(responseData);
              }
            }
            //endregion
          }
          isLoading.value = false;
        } else {
          if (isHideLoader!) {
            hideProgressDialog();
          }
          showErrorMessage(
              title: 'Error!',
              message: responseMessage,
              isRecall: true,
              callBack: () {
                getX.Get.back();
                call(params: params, url: url, success: success, error: error, isProgressShow: isProgressShow, methodType: methodType, isHideLoader: isHideLoader);
              });
          if (error != null) {
            error(jsonDecode(response.data));
            // error(response.toString());
          }
          isLoading.value = false;
        }
        isLoading.value = false;
      } on DioError catch (dioError) {
        hideProgressDialog();
        isLoading.value = true;
        print("data ===fdfdf=====>${dioError.response?.data}");

        Map<String, dynamic> data = jsonDecode(dioError.response?.data);

        if (dioError.response?.statusCode == 422) {
          if (data.containsKey("errors")) {
            // getX.Get.snackbar("Error", data["errors"].entries.first.value);
            Fluttertoast.showToast(msg: data["errors"].entries.first.value);
          } else {
            // getX.Get.snackbar("Error", data["message"]);
            Fluttertoast.showToast(msg: data["message"]);
          }
          error!(dioError.response);
        } else if (dioError.response?.statusCode == 401 || dioError.response?.statusCode == 403) {
          // getX.Get.offAll(() => const LoginOptionScreen());
          //  storage.remove(ApiConfig.loginToken);
          // getX.Get.snackbar("Error", data["message"]);
          Fluttertoast.showToast(msg: data["message"]);
        } else {
          //#region alert
          if (errorMessageType == ErrorMessageType.snackBarOnlyError || errorMessageType == ErrorMessageType.snackBarOnResponse) {
            Fluttertoast.showToast(msg: data["message"]);

            // getX.Get.snackbar("Error", data["message"]);
          } else if (errorMessageType == ErrorMessageType.dialogOnlyError || errorMessageType == ErrorMessageType.dialogOnResponse) {
            await apiAlertDialog(title: 'Error!', message: data["message"], buttonTitle: "Okay");
          }
          if (error != null) {
            //#endregion alert
            print("data ===fdfdf=====>${data["message"]}");
            error(data);
          }
        }
      } catch (e) {
        //#region catch
        if (kDebugMode) {
          print("====>>>>$e");
        }
        hideProgressDialog();
        showErrorMessage(
            title: 'Error!',
            message: e.toString(),
            isRecall: true,
            callBack: () {
              getX.Get.back();
              call(params: params, url: url, success: success, error: error, isProgressShow: isProgressShow, methodType: methodType, isHideLoader: isHideLoader);
            });
        isLoading.value = false;
        //#endregion catch
      }
    } else {
      //#region No Internet
      showErrorMessage(
          title: 'Error!',
          message: interNetMessage,
          isRecall: true,
          callBack: () {
            getX.Get.back();
            call(params: params, url: url, success: success, error: error, isProgressShow: isProgressShow, methodType: methodType, isHideLoader: isHideLoader);
          });
      //#endregion No Internet
    }
  }
}

showErrorMessage({required String title, required String message, required bool isRecall, required Function callBack}) {
  serviceCallCount = 0;
  // serviceCallCount++;
  hideProgressDialog();
  apiAlertDialog(
      title: title,
      buttonTitle: serviceCallCount < 3 ? tryAgain : "Restart App",
      message: message,
      buttonCallBack: () {
        callBack();
      });
}

void showProgressDialog({bool isLoading = true}) {
  isLoading = true;
  getX.Get.dialog(
      WillPopScope(
        onWillPop: () => Future.value(false),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      barrierColor: Colors.black12,
      barrierDismissible: false);
}

void hideProgressDialog({bool isLoading = true, bool isProgressShow = true, bool isHideLoader = true}) {
  isLoading = false;
  if ((isProgressShow || isHideLoader) && getX.Get.isDialogOpen!) {
    getX.Get.back();
  }
}

dioErrorCall({required DioError dioError, required Function onCallBack}) {
  switch (dioError.type) {
    case DioErrorType.unknown:
    case DioErrorType.connectionError:
      // onCallBack(connectionTimeOutMessage, false);
      onCallBack(dioError.message, true);
      break;
    case DioErrorType.badResponse:
    case DioErrorType.cancel:
    case DioErrorType.receiveTimeout:
    case DioErrorType.sendTimeout:
    default:
      onCallBack(dioError.message, true);
      break;
  }
}

Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

unauthorizedDialog(message) async {
  if (!getX.Get.isDialogOpen!) {
    getX.Get.dialog(
      WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: CupertinoAlertDialog(
          title: const Text("Neax"),
          content: Text(message ?? authenticationMessage),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("Okay"),
              onPressed: () {
                //restart the application
                storage.erase();
                getX.Get.offAll(const LoginOptionScreen());
              },
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeInCubic,
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

isNotEmptyString(String? string) {
  return string != null && string.isNotEmpty;
}

bool handleResponse(Response response) {
  try {
    if (isNotEmptyString(response.toString())) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

apiAlertDialog({required String title, required String message, String? buttonTitle, Function? buttonCallBack, bool isShowGoBack = true}) async {
  if (!getX.Get.isDialogOpen!) {
    await getX.Get.dialog(
      WillPopScope(
        onWillPop: () {
          return isShowGoBack ? Future.value(true) : Future.value(false);
        },
        child: CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: isShowGoBack
              ? [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(isNotEmptyString(buttonTitle) ? buttonTitle! : "Try again"),
                    onPressed: () {
                      if (buttonCallBack != null) {
                        buttonCallBack();
                      } else {
                        getX.Get.back();
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text("Go Back"),
                    onPressed: () {
                      getX.Get.back();
                      getX.Get.back();
                    },
                  )
                ]
              : [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(isNotEmptyString(buttonTitle) ? buttonTitle! : "Try again"),
                    onPressed: () {
                      if (buttonCallBack != null) {
                        buttonCallBack();
                      } else {
                        getX.Get.back();
                      }
                    },
                  ),
                ],
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeInCubic,
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

enum MethodType { get, post, put, patch, delete }

enum ErrorMessageType { snackBarOnlyError, snackBarOnlySuccess, snackBarOnResponse, dialogOnlyError, dialogOnlySuccess, dialogOnResponse, none }

class ApiConfig {
  static const String loginToken = 'loginToken';
}
