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
		public var appID:String = 'YOUR APP ID';
		public var secretKey:String = 'YOUR SECRET KEY';

		/** 
		* Start the event listers for clicks and wait for the document class to be added to the stage.
		*/
		public function main() {
			Security.allowInsecureDomain('*');
			Security.allowDomain('*');
			addEventListener(MouseEvent.CLICK, handleDemoClicks);
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		/** 
		* Once on stage, download the IDNET interface and wait for a complete event.
		* 
		* @param e Event listener reference.
		*/
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
		/** 
		* Once the interface is downloaded, reference it to a varible, add it to stage, and initialize with appID and secretKey.
		* 
		* @param e Event listener reference.
		*/
		function loadComplete(e:Event):void {
			idnet = e.currentTarget.content;
			idnet.addEventListener('IDNET', handleIDNET);
			stage.addChild(idnet);
			idnet.init(stage, appID, secretKey, true);
		}
		/** 
		* Used to provide button interactivty in the example.
		* 
		* @param e MouseEvent listener reference.
		*/
		function handleDemoClicks(e:MouseEvent) {
			if (idnet) {
				if (e.target.name == 'scoreSubmit') {
					//this.idnet.submitScore(scoreTxt.text);
				}
				if (e.target.name == 'scoreBut') {
					this.idnet.toggleInterface('scoreBox');
				}
				if (e.target.name == 'regBut') {
					this.idnet.toggleInterface('registration');
				}
				if (e.target.name == 'loginBut') {
					this.idnet.toggleInterface();
				}
				if (e.target.name == 'getBut') {
					this.idnet.retrieveUserData(keyTxt.text);
				}
				if (e.target.name == 'setBut') {
					this.idnet.submitUserData(key2Txt.text, dataTxt.text);
				}
				if (e.target.name == 'deleteBut') {
					this.idnet.removeUserData(key3Txt.text);
				}
				if (e.target.name == 'logoutBut') {
					// This is for testing. It's not needed for most applications.
					this.idnet.logout();
				}
			} else {
				trace('Interface not loaded yet.');
			}
		}
		/** 
		* After an API request has been sent, this method 
		* will be called with and response information.
		* 
		* @param e IDNET Event listener reference.
		*/
		function handleIDNET(e:Event) {
			if (idnet.type == 'login') {
				if (idnet.data.hasOwnProperty('error') === false) {
					trace('Session Key: '+idnet.data.sessionKey);
					trace('Email: '+idnet.data.user.email);
					trace('Nickname: '+idnet.data.user.nickname);
					trace('Pid: '+idnet.data.user.pid);
				} else {
					trace('Error: '+idnet.data.error);
				}
			}
			if (idnet.type == 'submit') {
				if (idnet.data.hasOwnProperty('error') === false) {
					trace('Status: '+idnet.data.status);
				} else {
					trace('Error: '+idnet.data.error);
				}
			}
			if (idnet.type == 'retrieve') {
				if (idnet.data.hasOwnProperty('error') === false) {
					trace('Key '+idnet.data.key);
					trace('Data: '+idnet.data.jsondata);
				} else {
					trace('Error: '+idnet.data.error);
				}
			}
		}
	}
}