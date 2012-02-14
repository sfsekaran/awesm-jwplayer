package
{
  /* 
  * AS3 Wrapper for jsonp
  *   Hack around flash's cross-domain security policy for 
  *   loading json on remote servers. ONLY works when flash is in a browser.
  *
  * example: 
  *   JSONP.get("http://api.twitter.com/statuses/user_timeline.json", 
  *             "{screen_name:'puppybits', count:'1'}", 
  *             function(data):void{ 
  *               trace('flash recieved cross-domain json:'+data)
  *             });
  *
  * Test in FF and Webkit with twitter api. Will add IE support as needed.
  *
  * Licensed under WTFGPL
  * © Bobby Schultz 2011
  */
  import flash.external.ExternalInterface;
  
  public class JSONP {
  
    public static function get(url:String, params:String, callback:Function):void {
      var proxy:String = "flashCallback"+Math.random()*100000000000000000;
      
      //json returns to flash
      ExternalInterface.addCallback(proxy, function(results:Object):void{
        ExternalInterface.addCallback(proxy, null);
        callback(results);
      });
      
      //calls remote service on other domain via javascript
      var jsonp_get:String = "(function(flashurl, flashparams, flashcallback) {" +
      "  var jsonp, key," +
      "  proxy = 'jsonp_proxy' + Math.random() * 10000000000000000000," +
      "  " +
      "  query = '?';" +
      "  for(key in flashparams) {" +
      "    if(flashparams.hasOwnProperty(key)) {" +
      "      query += key + '=' + flashparams[key] + '&';" +
      "    }" +
      "  }" +
      "  flashurl += encodeURI(query += '&callback='+ proxy);" +
      "  " +
      "  /*callback wrapper to remove script from dom*/" +
      "  window[proxy] = function (data) {" +
      "    if(document.getElementsByTagName('object').hasOwnProperty(0)) {" +
      "      document.getElementsByTagName('object')[0][flashcallback](data);" +
      "    }" +
      "    jsonp.parentNode.removeChild( jsonp );" +
      "    try {" +
      "      delete window[proxy];" +
      "    } catch(e){}" +
      "    window[proxy] = null;" +
      "  };" +
      "  " +
      "  /*load json*/" +
      "  jsonp = document.createElement('script');" +
      "  jsonp.src = flashurl;" +
      "  jsonp.language = 'application/json';" +
      "  jsonp.async = true;" +
      "  " +
      "  document.getElementsByTagName('head')[0].appendChild(jsonp);" +
      "})('" + url + "' , " + params + " , '" + proxy + "')";
      
      ExternalInterface.call("eval", jsonp_get);
    }
  }
}
