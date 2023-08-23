public virtual class HttpManager {
    public enum Method {
        GET,
        POST,
        PUT,
        PATCH
    }

    public static final String HEADER_ACCEPT = 'Accept';
    public static final String HEADER_AUTHORIZATION = 'Authorization';
    public static final String HEADER_CACHE_CONTROL = 'Cache-Control';
    public static final String HEADER_CONTENT_TYPE = 'Content-Type';

    public static final String BEARER = 'Bearer ';
    public static final String APPLICATION_JSON = 'application/json';
    public static final String MULTIPART_FORMDATA = 'multipart/form-data';
    public static final String NO_CACHE = 'no-cache';

    private Map<String, String> headers = new Map<String, String>();
    private Map<String, String> params = new Map<String, String>();
    private Integer timeout = 120000;
    private Method method = HttpManager.Method.GET;
    private String baseURL;
    private String path;
    private String body;
    private Blob bodyBlob;

    public Map<String, String> getHeaders() {
        return this.headers;
    }

    public HttpManager setHeaders(Map<String, String> headers) {
        this.headers.putAll(headers);
        return this;
    }

    public HttpManager setHeader(String headerKey, String headerValue) {
        this.headers.put(headerKey, headerValue);
        return this;
    }

    public HttpManager removeHeader(String headerKey) {
        this.headers.remove(headerKey);
        return this;
    }

    public Map<String, String> getParams() {
        return this.params;
    }

    public HttpManager setParams(Map<String, String> params) {
        this.params.putAll(params);
        return this;
    }

    public HttpManager setParam(String paramKey, String paramValue) {
        this.params.put(paramKey, paramValue);
        return this;
    }

    public Integer getTimeout() {
        return this.timeout;
    }

    public HttpManager setTimeout(Integer timeout) {
        this.timeout = timeout;
        return this;
    }

    public Method getMethod() {
        return this.method;
    }

    public HttpManager setMethod(Method method) {
        this.method = method;
        return this;
    }

    public String getMethodName() {
        return this.method.name();
    }

    public String getBaseURL() {
        return this.baseURL;
    }

    public HttpManager setBaseURL(String url) {
        this.baseURL = url;
        return this;
    }

    public String getPath() {
        return this.path;
    }

    public HttpManager setPath(String path) {
        this.path = path;
        return this;
    }

    public String getFullURL() {
        if (String.isBlank(this.baseURL)) {
            return null;
        }

        String fullRequestURL = String.isBlank(this.path)
            ? this.baseURL
            : this.baseURL + '/' + this.path;

        if (!this.params.isEmpty()) {
            List<String> paramsList = new List<String>();
            for (String pKey : this.params.keySet()) {
                paramsList.add(pKey + '=' + params.get(pKey));
            }

            fullRequestURL += '?' + String.join(paramsList, '&');
        }

        return fullRequestURL;
    }

    public String getBody() {
        return this.body;
    }

    public HttpManager setEncodedBody(Map<String, Object> keyToValueBody) {
        List<String> bodyList = new List<String>();

        for (String key : keyToValueBody.keySet()) {
            String value = String.valueOf(keyToValueBody.get(key));

            bodyList.add(this.encodeParam(key) + '=' + this.encodeParam(value));
        }

        return this.setBody(bodyList.isEmpty() ? '' : String.join(bodyList, '&'));
    }

    private String encodeParam(String param) {
        if (String.isNotBlank(param)) {
            param = EncodingUtil.urlEncode(param, 'UTF-8');
        }

        return param;
    }

    public HttpManager setBody(String body) {
        this.body = body;
        return this;
    }

    public Blob getBodyBlob() {
        return this.bodyBlob;
    }

    public HttpManager setBodyBlob(Blob bodyBlob) {
        this.bodyBlob = bodyBlob;
        return this;
    }

    public virtual HttpResponse sendRequest() {
        HttpRequest request = new HttpRequest();

        if (!this.headers.isEmpty()) {
            for (String hKey : this.headers.keySet()) {
                request.setHeader(hKey, this.headers.get(hKey));
            }
        }

        request.setTimeout(this.timeout);
        request.setMethod(this.getMethodName());
        request.setEndpoint(this.getFullURL());
        if (String.isNotBlank(body)) {
            request.setBody(body);
        } else if (bodyBlob != null) {
            request.setBodyAsBlob(bodyBlob);
        }

        String fullURL = this.getFullURL();

        Http http = new Http();
        HttpResponse response = new HttpResponse();

        try {
            response = http.send(request);
        } catch (Exception e) {
            // TODO: handle exception
        }

        return response;
    }
}