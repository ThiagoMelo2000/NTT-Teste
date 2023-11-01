@IsTest
public with sharing class AccountUtilsTest {
    
    @IsTest
    static void shouldValidateCPFTrue(){
        String cpf = '12345678910';

        Assert.isTrue(AccountUtils.validaCPF(cpf), 'CPF is not valid');
    }

    @IsTest
    static void shouldValidateCPFFalse(){
        String cpf = '123acb789&';

        Assert.isFalse(AccountUtils.validaCPF(cpf), 'CPF is valid');
    }

    @IsTest
    static void shouldValidateCNPJTrue(){
        String cnpj = '12345678912345';

        Assert.isTrue(AccountUtils.validaCNPJ(cnpj), 'CNPJ is not valid');
    }

    @IsTest
    static void shouldValidateCNPJFalse(){
        String cnpj = '123456789123455451231654';

        Assert.isFalse(AccountUtils.validaCNPJ(cnpj), 'CNPJ is valid');
    }

    @IsTest
    static void shoudBlockAccountCreation(){
        Account acc = new Account();
        
        try {
            AccountUtils.blockAccountCreation(acc);
        } catch (Exception e) {
            Assert.areEqual('Número do cliente é inválido', e.getMessage());
        }
    }
}