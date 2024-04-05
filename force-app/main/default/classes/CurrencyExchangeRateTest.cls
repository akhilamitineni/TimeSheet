@isTest
public class CurrencyExchangeRateTest {
    
    @isTest
    public static void testCurrencyExchangeRate() {
        System.debug('Entered the method of Test class');
        Test.setMock(HttpCalloutMock.class, new CurrencyExchangeRateMock());
        System.debug('Set Mock has been done');
        List<List<String>> strings = new List<List<String>>();
        List<String> values = new List<String>();
        values.add('USD');
        values.add('INR');
        System.debug(values);
        Strings.add(values);
        System.debug(strings);
        List<Decimal> ConversionRates = CurrencyExchangeRate.convertCurrency(strings);
        System.debug(ConversionRates);
        Decimal ConversionRate = conversionRates.get(0);
        System.debug(ConversionRate);
        System.assertEquals(1, ConversionRate, 'Assertion gone wrong for Conversion Rate');
    }
}