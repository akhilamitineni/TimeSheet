public class CurrencyExchangeRate {
    
    @InvocableMethod
	public static List<Decimal> convertCurrency(List<List<String>> strings){
        
        System.debug('Entered the Converted Currency Method');
        System.debug('The strings[0][0] is : ' + strings[0][0]);
        System.debug('The strings[0][1] is : ' + strings[0][1]);
        
        // Endpoint Url
        String url = 'callout:Exchange_Rates/fixer/latest?symbols='+strings[0][1]+'&base='+strings[0][0];
		System.debug('The url is : '+ url);
        
        // Initial default for the conversion rate
        Decimal ConversionRate = 0.0;
        List<Decimal> ConversionRates = new List<Decimal>();
        
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('apikey', '3u8jBK8808viEsHgS9uQajFp6SPUb6TH');
        
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug('The res.getStatus() value is : '+ res.getStatus());
        
        // If the request is successful, parse the JSON response.
        if(res.getStatusCode()==200){
            System.debug('The res.getBody() value is : '+ res.getBody());
            
            // Deserialize the JSON string into collections of primitive data types.
            Map<String,Object> results = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
            System.debug('The results are : '+ results);
            Map<String,Object> value = (Map<String,Object>)results.get('rates');
            System.debug('The value is : '+ value);
            ConversionRate = (Decimal)value.get(strings[0][1]);
            System.debug('The Conversion rate is : '+ ConversionRate);
            conversionRates.add(conversionRate);
    	}
    	return conversionRates;
	}
}