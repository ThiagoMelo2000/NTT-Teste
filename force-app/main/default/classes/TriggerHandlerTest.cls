@IsTest
public with sharing class TriggerHandlerTest {

    private static String lastMethodCalled;
    private static TriggerHandlerTest.TestHandler handler;
    private static final String TRIGGER_CONTEXT_ERROR = 'Trigger handler called outside of Trigger execution';

    static {
        handler = new TriggerHandlerTest.TestHandler();
        handler.isTriggerExecuting = true;
    }
    
    @IsTest
    static void shouldRunBeforeInsert() {
        beforeInsertMode();
        handler.run();
        Assert.areEqual('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    }
    
    @IsTest
    static void shouldRunBeforeUpdate() {
        beforeUpdateMode();
        handler.run();
        Assert.areEqual('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
    }

    @IsTest
    static void shouldRunAfterInsert() {
        afterInsertMode();
        handler.run();
        Assert.areEqual('afterInsert', lastMethodCalled, 'last method should be afterInsert');
    }

    @IsTest
    static void shouldRunVirtualMethods() {
        TriggerHandler triggerHandlerMock = new TriggerHandler();
        triggerHandlerMock.beforeInsert();
        triggerHandlerMock.beforeUpdate();
        triggerHandlerMock.afterInsert();
    }

    private static void beforeInsertMode() {
        handler.setTriggerContext('before insert', true);
    }

    private static void beforeUpdateMode() {
        handler.setTriggerContext('before update', true);
    }

    private static void afterInsertMode() {
        handler.setTriggerContext('after insert', true);
    }

    private class TestHandler extends TriggerHandler {
        public override void beforeInsert() {
            TriggerHandlerTest.lastMethodCalled = 'beforeInsert';
        }
        
        public override void  beforeUpdate() {
            TriggerHandlerTest.lastMethodCalled = 'beforeUpdate';
        }
        
        public override void afterInsert() {
            TriggerHandlerTest.lastMethodCalled = 'afterInsert';
        }
    }
}