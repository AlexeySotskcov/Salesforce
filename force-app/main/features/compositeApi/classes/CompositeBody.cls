public with sharing class CompositeBody {
    public boolean allOrNone;
    public List<CompositeRequest> compositeRequest;

    public class CompositeRequest {
        public String method;
        public String url;
        public String referenceId;
        public Map<String, Object> body;

        public CompositeRequest setMethod(String method) {
            this.method = method;
            return this;
        }

        public CompositeRequest setUrl(String url) {
            this.url = url;
            return this;
        }

        public CompositeRequest setReferenceId(String referenceId) {
            this.referenceId = referenceId;
            return this;
        }

        public CompositeRequest setBody(Map<String, Object> body) {
            this.body = body;
            return this;
        }
    }
}