part of flutter_core;

class HttpController extends ChangeNotifier{

  bool isLoading = false;
  bool isError = false;
  bool isEmpty = false;

  String errorMessage = '';

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void onSuccess(){
    isLoading = false;
    isError = false;
    isEmpty = false;
    errorMessage = '';
    notifyListeners();
  }

  void onError(DioError e){
    isLoading = false;
    isError = true;
    errorMessage = e.message;
    notifyListeners();
  }

  void onEmpty(){
    isLoading = false;
    isEmpty = true;
    notifyListeners();
  }
}