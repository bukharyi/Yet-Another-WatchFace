using Toybox.Background;
using Toybox.System as Sys;
using Toybox.Communications as Comm;
using Toybox.Application as App;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.
//
(:background)
class BackgroundServiceDelegate extends Sys.ServiceDelegate 
{
	hidden var _syncCounter = 0;
	hidden var _location;
	hidden var _city;
	hidden var _received = {}; 
	 
	function initialize() 
	{
		Sys.ServiceDelegate.initialize();
	}
	
    function onTemporalEvent() 
    {
    	try
    	{
	    	// Request Currency
	    	//
	    	if (Setting.GetIsShowExchangeRate())
			{
				RequestExchangeRate();
			}
	    
	    	_location = Setting.GetLastKnownLocation();
	    	var apiKey = Setting.GetWeatherApiKey();
	    	
	    	if (_location == null || _location.size() != 2)
	    	{
	    		return;
	    	}
	    	
			// Request Weather
			//
	    	if (apiKey != null && apiKey.length() > 0)
	    	{
				RequestWeather(apiKey, _location);
			}
			
			// Request Location
			//
			if (Setting.GetIsShowCity())
			{
				// avoid unnecessary web requests
				// 
				_city = Setting.GetCity();
				if(_city == null ||
					(_location[0] != _city["lrloc"][0] || 
					_location[1] != _city["lrloc"][1]))
				{
					RequestLocation(_location);
				}
			}
		}
		catch(ex)
		{
			Sys.println("temp event error: " + ex.getErrorMessage());
		}		
    }
    
    function RequestWeather(apiKey, location)
	{
		var url = Lang.format("$1$/$2$/$3$,$4$?exclude=minutely,hourly,daily,flags,alerts&units=si", [
			Setting.GetWeatherApiUrl(),
			apiKey,
			location[0],
			location[1]]);  
			
		//Sys.println(" :: weather request " + url);

        var options = {
          :method => Comm.HTTP_REQUEST_METHOD_GET,
          :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

		_syncCounter = _syncCounter + 1;
    	Comm.makeWebRequest(url, {}, options, method(:OnReceiveWeather));
	}  
	
	function OnReceiveWeather(responseCode, data)
	{
		try
		{
			if (responseCode == 200)
			{
				_received.put("weather", {
					"temp" => data["currently"]["temperature"].toFloat(),
					"wndSpeed" => data["currently"]["windSpeed"].toFloat(),
					"perception" => data["currently"]["precipProbability"].toFloat() * 100,
					"condition" => data["currently"]["icon"]});
			}
		}
		catch(ex)
		{
			Sys.println("get weather error : " + ex.getErrorMessage());
		}
		
		_syncCounter = _syncCounter - 1;
		if (_syncCounter == 0)
		{
			Background.exit(_received);
		}
	}
	
	function RequestLocation(location)
	{
		var url = Lang.format(
			"https://ivan-b.com/garminapi/wf-service/location?lat=$1$&lon=$2$&dId=$3$&v=$4$", [
			location[0],
			location[1],
			Sys.getDeviceSettings().uniqueIdentifier,
			Setting.GetAppVersion()]); 	
			
		//Sys.println(" :: location request: " + url);	
			
        var options = {
          :method => Comm.HTTP_REQUEST_METHOD_GET,
          :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

		_syncCounter = _syncCounter + 1;
    	Comm.makeWebRequest(url, {}, options, method(:OnReceiveLocation));
	}
	
	function OnReceiveLocation(responseCode, data)
	{
		//Sys.println("loc data" + data);
		try
		{
			if (responseCode == 200)
			{
				_received.put("city", { 
					"City" => data["cityName"],
					"lrloc" => _location});
			}
		}
		catch (ex)
		{
			Sys.println("get location error : " + ex.getErrorMessage());
		}
				
		_syncCounter = _syncCounter - 1;
		if (_syncCounter == 0)
		{
			Background.exit(_received);
		}
	}
	
	function RequestExchangeRate()
	{
		var url = Lang.format("https://api.exchangeratesapi.io/latest?base=$1$&symbols=$2$", [
			Setting.GetBaseCurrency(), 
			Setting.GetTargetCurrency()]);	
		 
		//Sys.println(" :: ex rate request: " + url);
		
		var options = {
        	:method => Comm.HTTP_REQUEST_METHOD_GET,
          	:responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
		};
		
		_syncCounter = _syncCounter + 1;
    	Comm.makeWebRequest(url, {}, options, method(:OnReceiveExchangeRate));
	}
	
	function OnReceiveExchangeRate(responseCode, data)
	{
		//Sys.println(" data = " + data);
		//Sys.println(" code = " + responseCode);
		try
		{
			if (responseCode == 200)
			{
				_received.put("exchange", {
					"ExchangeRate" => data["rates"][Setting.GetTargetCurrency()].toFloat()});
			}
		}
		catch(ex)
		{
			Sys.println("get ex rate error : " + ex.getErrorMessage());
		}
		
		_syncCounter = _syncCounter - 1;
		if (_syncCounter == 0)
		{
			Background.exit(_received);
		}
	}
}