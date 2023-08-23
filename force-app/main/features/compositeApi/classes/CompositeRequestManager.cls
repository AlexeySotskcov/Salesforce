public with sharing class CompositeRequestManager extends HttpManager {
    public CompositeRequestManager() {
        this.setBaseURL(URL.getSalesforceBaseUrl().toExternalForm());
        this.setHeaders(
            new Map<String, String>{
                HEADER_CONTENT_TYPE => APPLICATION_JSON,
                HEADER_AUTHORIZATION => 'Bearer ' + UserInfo.getSessionId()
            }
        );
    }

    public override HttpResponse sendRequest() {
        HttpResponse response = super.sendRequest();

        if (response.getStatusCode() == 400) {
            //    todo: throw exception
        }

        return response;
    }
}