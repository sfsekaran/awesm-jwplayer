package {
	import flash.display.Sprite;
	import com.longtailvideo.jwplayer.utils.Logger;
	import com.longtailvideo.jwplayer.player.*;
	import com.longtailvideo.jwplayer.plugins.*;
	import com.longtailvideo.jwplayer.events.*;
	import mx.rpc.http.*;
	import mx.rpc.events.*;

	public class Awesm extends Sprite implements IPlugin {

		/** Configuration list of the plugin. **/
		private var config:PluginConfig;
		/** Reference to the JW Player API. **/
		private var api:IPlayer;
		/** Awesm API key **/
		private var awesmApiKey:String;
		/** Awesm ID **/
		private var awesmId:String;
		/** Already recorded semaphore variable **/
		private var alreadyRecordedThisPlay:Boolean = false;

		/** This function is automatically called by the player after the plugin has loaded. **/
		public function initPlugin(player:IPlayer, conf:PluginConfig):void {
			api = player;
			config = conf;
			awesmApiKey = conf.apikey;
			awesmId = player.config.awesm;
			Logger.log('apikey: ' + awesmApiKey, 'Awesm');
			Logger.log('id: ' + awesmId, 'Awesm');

			// Listen for play position callbacks.
			api.addEventListener(MediaEvent.JWPLAYER_MEDIA_TIME, playPosition);
		}

		/** This should be a unique, lower-case identifier (e.g. "myplugin") **/
		public function get id():String {
			return "awesm";
		}

		/** Called when the player has resized.  The dimensions of the plugin are passed in here. **/
		public function resize(width:Number, height:Number):void {
			// Lay out plugin here, if necessary.
		}

		/* Private */

		private function playPosition(event:MediaEvent):void {
			if (alreadyRecordedThisPlay) return;

			var fraction:Number = (event.position / event.duration);
			// Logger.log("Play percentage: " + fraction * 100, 'Awesm');
			if (fraction >= 0.2) {
				recordAwesmConversion();
			}
		}

		private function recordAwesmConversion():void {
			if (alreadyRecordedThisPlay) return;
			alreadyRecordedThisPlay = true;

			Logger.log('Beginning conversion call...', 'Awesm');

			// make the call to awesm
			var http:HTTPService = new HTTPService();

			// register event handlers (resultHandler and faultHandler functions)
			http.addEventListener( ResultEvent.RESULT, resultHandler );
			http.addEventListener( FaultEvent.FAULT, faultHandler );

			// specify the url to request, the method and result format
			http.url = "http://api.awe.sm/conversions/new";
			http.method = "GET";
			http.resultFormat = "text";

			var params:Object = { key: awesmApiKey, awesm_key: awesmId, conversion_type: 'goal_3', conversion_value: 1 };

			// send the request
			http.send(params);

			Logger.log('Conversion call sent...', 'Awesm');
		}

		private function resultHandler(event:ResultEvent):void {
			Logger.log('Play conversion successful.', 'Awesm');
			Logger.log(event.result, 'Awesm');
		}

		private function faultHandler(event:FaultEvent):void {
			Logger.log('Play conversion failed.', 'Awesm');
		}
	}
}
