package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class main extends MovieClip {
		public var idnet;
		// please read http://dev.id.net/docs/actionscript/ for details about this example
		private var appID:String = 'YOUR APP ID';// your application id
		private var verbose = true;// display idnet messages

		// Event listener to handle the buttons in the example
		function handleDemoClicks(e:MouseEvent) {
			if (idnet) {
				// main buttons
				if (e.target.name == 'loginBut') {
					this.idnet.toggleInterface();
				}
				if (e.target.name == 'regBut') {
					this.idnet.toggleInterface('registration');
				}
				if (e.target.name == 'scoreBut') {
					this.idnet.toggleInterface('scoreboard');
				}
				// Logout is for testing only, please do Not use it in games. Logout is handled through id.net.
				if (e.target.name == 'logoutBut') {
					this.idnet.logout();
				}
				// save string buttons
				if (e.target.name == 'setBut') {
					this.idnet.submitUserData(saveStrKey.text, strToSave.text);
				}
				if (e.target.name == 'getBut') {
					this.idnet.retrieveUserData(getStrKey.text);
				}
				if (e.target.name == 'deleteBut') {
					this.idnet.removeUserData(deleteStrKey.text);
				}
				// save object buttons
				if (e.target.name == 'setObjBut') {
					// normally the object is already in an object type. For the example, we parse a string to visualize it.
					var object = JSON.parse(objToSave.text);
					this.idnet.submitUserData(saveObjKey.text, JSON.stringify(object));
				}
				if (e.target.name == 'getObjBut') {
					this.idnet.retrieveUserData(saveObjKey.text);
				}
				// score buttons
				if (e.target.name == 'getScore') {
					this.idnet.getPlayersScore();
				}
				if (e.target.name == 'scoreSubmit') {
					this.idnet.submitScore(scoreSet.text);
				}

			} else {
				trace('Interface not loaded yet.');
			}
		}
		// handleIDNET is where you will want to edit to send data to the rest of your application. 
		function handleIDNET(e:Event) {
			if (idnet.type == 'login') {
				trace('Nickname: '+idnet.data.user.nickname);
				trace('Pid: '+idnet.data.user.pid);
			}
			if (idnet.type == 'submit') {
				trace('Status: '+idnet.data.status);
			}
			if (idnet.type == 'retrieve') {
				if (idnet.data.hasOwnProperty('error') === false) {
					trace('Key '+idnet.data.key);
					trace('Data: '+idnet.data.jsondata);

					// in this example, we are saving strings and the gameSave object, so we check for that here.
					if (idnet.data.key == 'gameSave') {
						var retrievedObj = decodeURIComponent(idnet.data.jsondata);
						objToGet.text = retrievedObj;
						// normally you would want this back into an object to work with. Here we keep it as text to visualize it.
						// var gameSave = JSON.parse(retrievedObj);
					} else {
						// we decode string to make sure accented characters are returned as normal
						strToGet.text = decodeURIComponent(idnet.data.jsondata);
					}
				} else {
					trace('Error: '+idnet.data.error);
				}
			}
			if (idnet.type == 'getScore') {
				scoreGet.text = idnet.data.score;
			}
		}


		// Below is the loader for the id.net interface. Do Not edit below.
		public function main() {
			Security.allowInsecureDomain('*');
			Security.allowDomain('*');
			addEventListener(MouseEvent.CLICK, handleDemoClicks);
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		private function onStage(e:Event):void {
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			if (Security.sandboxType != "localTrusted") {
				loaderContext.securityDomain = SecurityDomain.currentDomain;// Sets the security 
			}
			var sdk_url:String = "https://www.id.net/swf/idnet-client.swc?="+new Date().getTime();
			var urlRequest:URLRequest = new URLRequest(sdk_url);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
			loader.load(urlRequest, loaderContext);
		}

		function loadComplete(e:Event):void {
			idnet = e.currentTarget.content;
			idnet.addEventListener('IDNET', handleIDNET);
			stage.addChild(idnet);
			idnet.init(stage, appID, '', verbose);
		}
	}
}