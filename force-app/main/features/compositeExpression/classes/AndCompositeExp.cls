public with sharing class AndCompositeExp extends CompositeExp {
    public override Boolean evaluate() {
        for (Expression expr : children) {
            if (!expr.evaluate()) {
                return false;
            }
        }
        return true;
    }
}
