public with sharing class OrCompositeExp extends CompositeExp {
    public override Boolean evaluate() {
        for (Expression expr : children) {
            if (expr.evaluate()) {
                return true;
            }
        }
        return false;
    }
}
