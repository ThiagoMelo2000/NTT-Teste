trigger AccountTrigger on Account (before insert, after insert, before update) {
    new AccountTriggerHandler().run();
}