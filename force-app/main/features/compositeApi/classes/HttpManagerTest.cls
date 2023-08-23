@isTest
public class HttpManagerTest {
    private static final String WRONG_CONSTRUCTOR = 'Constructor have set parameters incorrectly';
    private static final String WRONG_PARAMETER = 'Given parameter was set incorrectly';
    private static final String WRONG_RESPONSE = 'Invalid response';

    @IsTest
    public static void constructorTest() {
        HttpManager builder = new HttpManager();
        System.assertNotEquals(null, builder.getHeaders(), WRONG_CONSTRUCTOR);
        System.assert(builder.getHeaders().isEmpty(), WRONG_CONSTRUCTOR);
        System.assertNotEquals(null, builder.getParams(), WRONG_CONSTRUCTOR);
        System.assert(builder.getParams().isEmpty(), WRONG_CONSTRUCTOR);
        System.assertEquals(null, builder.getFullURL(), WRONG_CONSTRUCTOR);
        System.assertEquals(120000, builder.getTimeout(), WRONG_CONSTRUCTOR);
        System.assertEquals(
            HttpManager.Method.GET,
            builder.getMethod(),
            WRONG_CONSTRUCTOR
        );
        System.assertEquals(null, builder.getBaseURL(), WRONG_CONSTRUCTOR);
        System.assertEquals(null, builder.getPath(), WRONG_CONSTRUCTOR);
    }

    @IsTest
    public static void getFullURLTest() {
        HttpManager emptyBuilder = new HttpManager();
        System.assertEquals(null, emptyBuilder.getFullURL(), WRONG_PARAMETER);

        HttpManager builderWithBaseURL = new HttpManager()
            .setBaseURL('https://example.com');
        System.assertEquals(
            'https://example.com',
            builderWithBaseURL.getFullURL(),
            WRONG_PARAMETER
        );

        HttpManager builderWithFullURL = new HttpManager()
            .setBaseURL('https://example.com')
            .setPath('random-path/page');
        System.assertEquals(
            'https://example.com/random-path/page',
            builderWithFullURL.getFullURL(),
            WRONG_PARAMETER
        );
    }

    @IsTest
    public static void builderSettersTest() {
        HttpManager builder = new HttpManager()
            .setHeaders(new Map<String, String>{ 'RandomHeader' => 'RandomValue' })
            .setHeader('RandomHeader2', 'RandomValue2')
            .setParams(new Map<String, String>{ 'RandomParam' => 'RandomValue' })
            .setParam('RandomParam2', 'RandomValue2')
            .setBaseURL('https://example.com')
            .setPath('api')
            .setBody('body')
            .setMethod(HttpManager.Method.POST)
            .setTimeout(100000);

        System.assertEquals(
            'https://example.com/api?RandomParam=RandomValue&RandomParam2=RandomValue2',
            builder.getFullURL(),
            WRONG_PARAMETER
        );
        System.assertEquals('POST', builder.getMethodName(), WRONG_PARAMETER);
        System.assertEquals('body', builder.getBody(), WRONG_PARAMETER);

        Map<String, String> headers = builder.getHeaders();
        System.assertEquals(2, headers.size(), WRONG_PARAMETER);
        for (String hKey : headers.keySet()) {
            String hValue = headers.get(hKey);
            if (hKey == 'RandomHeader') {
                System.assertEquals('RandomValue', hValue, WRONG_PARAMETER);
            } else {
                System.assertEquals('RandomValue2', hValue, WRONG_PARAMETER);
            }
        }
    }

    @IsTest
    public static void sendRequestTest() {
        HttpManager builder = new HttpManager()
            .setHeaders(new Map<String, String>{ 'RandomHeader' => 'RandomValue' })
            .setParams(new Map<String, String>{ 'RandomParam' => 'RandomValue' })
            .setBaseURL('https://example.com')
            .setPath('api')
            .setBody('body')
            .setMethod(HttpManager.Method.POST);

        System.Test.setMock(HttpCalloutMock.class, new YourHttpCalloutMockImpl());

        HttpResponse res = null;
        System.Test.startTest();
        res = builder.sendRequest();
        System.Test.stopTest();

        System.assertNotEquals(null, res, WRONG_RESPONSE);
        System.assertEquals('RandomValue', res.getHeader('RandomHeader'), WRONG_RESPONSE);
        System.assertEquals('body', res.getBody(), WRONG_RESPONSE);
        System.assertEquals(200, res.getStatusCode(), WRONG_RESPONSE);
    }

    public class YourHttpCalloutMockImpl implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('RandomHeader', req.getHeader('RandomHeader'));
            res.setBody(req.getBody());
            res.setStatusCode(200);
            return res;
        }
    }
}