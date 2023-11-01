public with sharing class AccountUtils {
    private static final String regexPattern = '.*[a-zA-Z\\W_].*';

    public static Boolean validaCNPJ(String value){
        System.Pattern pattern = System.Pattern.compile(regexPattern);
        System.Matcher matcher = pattern.matcher(value);
        return value.length() == 14 && !matcher.matches();
    }

    public static Boolean validaCPF(String value){
        System.Pattern pattern =  System.Pattern.compile(regexPattern);
        System.Matcher matcher = pattern.matcher(value);

        return value.length() == 11 && !matcher.matches();
    }

    public static void blockAccountCreation(Account acc){
        acc.addError('Número do cliente é inválido');
    }
}