public with sharing class CompositeResponse {
    // body param is dynamic, it can be representation of RecordBody or List<RecordError>
    // check Salesforce Composite API docmentation
    // Composite Subrequest Result : https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_subrequest_result.htm

    // IMPORTANT: queries are not supported in this part of implementation
    public Object body { get; set; }
    public RequestHeaders httpHeaders { get; set; }
    public Integer httpStatusCode { get; set; }
    public String referenceId { get; set; }

    public class RecordBody {
        public String id { get; set; }
        public Boolean success { get; set; }
        public List<RequestErrors> errors { get; set; }
    }

    public class RecordError {
        public String errorCode { get; set; }
        public String message { get; set; }
    }

    public class RequestErrors {
        public String statusCode { get; set; }
        public String message { get; set; }
        public Object fields { get; set; }
    }

    public class RequestHeaders {
        public String Location { get; set; }
    }
}
