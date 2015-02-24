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
		
		private var gameSave1 = {
			level: 31,
			health: 66,
			inventory: [
				['healthpotion', 9],
				['sword', 'beastmode']
			]
		};

		// Event listener to handle the buttons in the example
		function handleDemoClicks(e:MouseEvent) {
			if (idnet) {
				if (e.target.name == 'loginBut') {
					idnet.toggleInterface();
				}
				if (e.target.name == 'regBut') {
					idnet.toggleInterface('registration');
				}
				// Logout is for testing only, please do Not use it in games. Logout is handled through id.net.
				if (e.target.name == 'logoutBut') {
					idnet.logout();
				}		
				// data save buttons
				if (e.target.name == 'setBut') {
					idnet.submitUserData('gameSave1', JSON.stringify(gameSave1));
				}
				if (e.target.name == 'getBut') {
					idnet.retrieveUserData('gameSave1');
				}
				if (e.target.name == 'deleteBut') {
					idnet.removeUserData('gameSave1');
				}
				// score buttons
				if(e.target.name == 'advancedScoreListBut'){
					idnet.advancedScoreList('Demo High Scores');
				}
				var randScore = Math.floor(Math.random() * (100000 - 1 + 1)) + 1;
				if(e.target.name == 'advancedScoreSubmitBut'){
					idnet.advancedScoreSubmit(randScore, 'Demo High Scores');
				}
				if(e.target.name == 'advancedScoreSubmitListBut'){
					idnet.advancedScoreSubmitList(randScore, 'Demo High Scores');
				}
				if(e.target.name == 'advancedScoreListPlayerBut'){
					idnet.advancedScoreListPlayer('Demo High Scores');
				}
				// achievements (not finished)
				if(e.target.name == 'achievementListBut'){
					idnet.toggleInterface('achievements');
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
				} else {
					trace('Error: '+idnet.data.error);
				}
			}
			if(idnet.type == 'advancedScoreListPlayer'){
				trace('player score: '+idnet.data.scores[0].points);
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