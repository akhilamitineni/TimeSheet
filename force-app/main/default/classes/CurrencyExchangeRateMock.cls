@isTest
global class CurrencyExchangeRateMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('api_key', 'Api_security_token');
        response.setBody('{"success" : true, "base" : "USD" , "rates" : {"INR" : 1}}');
        response.setStatusCode(200);
        return response;
    }
}