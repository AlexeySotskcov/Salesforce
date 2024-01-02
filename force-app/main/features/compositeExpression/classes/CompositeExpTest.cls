@IsTest
public with sharing class CompositeExpTest {
    @IsTest
    static void behaviorTest1() {
        //1 OR (2 AND 3)
        Expression expr = (new OrCompositeExp())
            // variable on the left side
            .add(new Variable('1'))
            .add(
                // variable on the right side
                (new AndCompositeExp()).add(new Variable('2')).add(new Variable('3'))
            )
            .set('1', false)
            .set('2', true)
            .set('3', false);

        System.assertEquals(false, expr.evaluate(), 'False OR (True AND False) => false');

        expr.set('2', false);
        System.assertEquals(false, expr.evaluate(), 'False OR (False AND False) => false');

        expr.set('1', true);
        System.assertEquals(true, expr.evaluate(), 'True OR (False AND False) => true');
    }
}
