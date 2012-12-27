/*
   ═ f4.Skin ═══════════════════════════════════════════════════════════════
   Software: f4.Skin - flash video player skin class
   Version: 1.3.5
   Support: http://gokercebeci.com/dev/f4player
   Author: goker.cebeci
   Contact: http://gokercebeci.com
   -------------------------------------------------------------------------
   License: Distributed under the GNU General Public License (GPLv3)
   http://www.gnu.org/copyleft/gpl.html
   This program is distributed in the hope that it will be useful - WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
   FITNESS FOR A PARTICULAR PURPOSE.
 ═══════════════════════════════════════════════════════════════════════════ */
package
{
	import f4.PlayerInterface;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	
	public class mySkin extends MovieClip
	{
		var player:PlayerInterface;
		var info:Object = new Object();
		var fullscreen:Boolean = true;
		var playing:Boolean = false;
		var volumeCache:Number;
		var status:String;
		var W:int = 480;
		var H:int = 270;
		var video:String;
		var image:MovieClip = new MovieClip();
		var seeking:Boolean = false;
		
		public function mySkin()
		{
			trace("mySkin loaded!");
			pose(W, H);
		}
		
		public function initialization(player:PlayerInterface, W:Number, H:Number, video:String, thumbnail:String, autoplay:Boolean = false, fullscreen:Boolean = true):void
		{
			fullscreen = fullscreen;
			this.W = info.width = W;
			this.H = info.height = H;
			info.progress = 0;
			pose(W, H);
			nav.pauseButton.visible = false;
			nav.seeker.visible = false;
			buffering.visible = false;
			
			//thumbnail [
			if (thumbnail)
			{
				image = player.Thumbnail(thumbnail, W, H);
				screen.addChildAt(image, 1);
				screen.width = W;
				screen.height = H;
			}
			// ] thumbnail
			
			var callback:Function = function(i:Object)
			{
				if ((i.width && i.height) && i.width != info.width && i.height != info.height)
				{
					info = i;
					pose(W, H);
				}
				info = i;
				nav.progressBar.width = (info.progress * nav.bar.width);
				nav.playingBar.width = (info.playing * nav.bar.width);
				nav.notify.text = formatTime(info.time) + " / " + formatTime(info.duration);
				
				if (status != info.status)
				{
					switch (info.status)
					{
						case "NetConnection.Connect.Success": 
							//movie [
							var movie:Video = player.Movie(W, H);
							screen.addChildAt(movie, 1);
							// ] movie
							// repose
							pose(W, H);
							break;
						case "NetConnection.Connect.Closed": 
							stopEvent(new MouseEvent(MouseEvent.CLICK));
							break;
						case "NetStream.Play.Start": 
							image.visible = false;
							buffering.visible = false;
							break;
						case "NetStream.Unpause.Notify": 
						case "NetStream.Buffer.Empty": 
						case "NetStream.Seek.Notify": 
							buffering.visible = true;
							break;
						case "NetStream.Buffer.Full": 
							buffering.visible = false;
							break;
						case "NetStream.Play.Stop": 
							stopEvent(new MouseEvent(MouseEvent.CLICK));
							break;
						case "NetStream.Failed": 
							stopEvent(new MouseEvent(MouseEvent.CLICK));
						default: 
							nav.notify.text = info.status;
							break;
					}
					status = info.status;
				}
			};
			// Callback Function
			player.Callback(callback);
//═ PLAY ══════════════════════════════════════════════════════════════════════
			var playEvent:Function = function(e:Event):void
			{
				trace('playEvent');
				if (playing)
				{
					player.Pause();
				}
				else
				{
					playing = player.Play(video);
					overButton.visible = !playing;
					image.visible = !playing;
				}
				nav.playButton.visible = !playing;
				nav.pauseButton.visible = playing;
			};
			overButton.addEventListener(MouseEvent.CLICK, playEvent);
			nav.playButton.addEventListener(MouseEvent.CLICK, playEvent);
			
			// AUTOPLAY;
			if (autoplay)
			{
				playEvent(new MouseEvent(MouseEvent.CLICK));
			}
			
//═ PAUSE ══════════════════════════════════════════════════════════════════════
			var pauseEvent:Function = function(e:Event):void
			{
				var isPause:Boolean = player.Pause();
				nav.playButton.visible = isPause;
				nav.pauseButton.visible = !isPause;
			};
			overlay.addEventListener(MouseEvent.CLICK, pauseEvent);
			nav.pauseButton.addEventListener(MouseEvent.CLICK, pauseEvent);
			//═ STOP ══════════════════════════════════════════════════════════════════════;
			var stopEvent:Function = function(e:Event):void
			{
				trace('stopEvent');
				playing = false;
				nav.playButton.visible = !playing;
				nav.pauseButton.visible = playing;
				buffering.visible = playing;
				player.Stop();
			};
//═ HIDE CONTROLS ═════════════════════════════════════════════════════════════
			var controlDisplayEvent:Function = function(e:Event):void
			{
				nav.y = e.type == 'mouseOver' || !playing ? overlay.height - 26 : overlay.height + 8;
			};
			overlay.addEventListener(MouseEvent.MOUSE_OVER, controlDisplayEvent);
			overlay.addEventListener(MouseEvent.MOUSE_OUT, controlDisplayEvent);
			nav.addEventListener(MouseEvent.MOUSE_OVER, controlDisplayEvent);
			nav.addEventListener(MouseEvent.MOUSE_OUT, controlDisplayEvent);
//═ SEEK ══════════════════════════════════════════════════════════════════════
			var playingBarEvent:Function = function(e:MouseEvent):void
			{
				if(e.type == "click" || e.buttonDown == true){
					var point:Number = e.localX * info.playing;
					var seekpoint:Number = (point / 100) * info.duration;
					player.Seek(seekpoint);
				}
			};
			nav.playingBar.buttonMode = true;
			nav.playingBar.addEventListener(MouseEvent.CLICK, playingBarEvent);
			nav.playingBar.addEventListener(MouseEvent.MOUSE_MOVE, playingBarEvent);
			var progressBarEvent:Function = function(e:MouseEvent):void
			{
				if(e.type == "click" || e.buttonDown == true){
					var point:Number = e.localX * info.progress;
					var seekpoint:Number = (point / 100) * info.duration;
					player.Seek(seekpoint);
				}
			};
			nav.progressBar.buttonMode = true;
			nav.progressBar.addEventListener(MouseEvent.CLICK, progressBarEvent);
			nav.progressBar.addEventListener(MouseEvent.MOUSE_MOVE, progressBarEvent);
			
//═ VOLUME ══════════════════════════════════════════════════════════════════════
			var setVolume:Function = function(newVolume:Number):void
			{
				player.Volume(newVolume);
				nav.volumeBar.mute.gotoAndStop((newVolume > 0) ? 1 : 2);
				nav.volumeBar.volumeOne.gotoAndStop((newVolume >= 0.2) ? 1 : 2);
				nav.volumeBar.volumeTwo.gotoAndStop((newVolume >= 0.4) ? 1 : 2);
				nav.volumeBar.volumeThree.gotoAndStop((newVolume >= 0.6) ? 1 : 2);
				nav.volumeBar.volumeFour.gotoAndStop((newVolume >= 0.8) ? 1 : 2);
				nav.volumeBar.volumeFive.gotoAndStop((newVolume == 1) ? 1 : 2);
			};
			var volumeEvent:Function = function(e:MouseEvent):void
			{
				if (e.buttonDown || e.type == 'click')
					switch (e.currentTarget)
				{
					case nav.volumeBar.mute: 
						setVolume(player.Mute());
						break;
					case nav.volumeBar.volumeOne: 
						setVolume(.2);
						break;
					case nav.volumeBar.volumeTwo: 
						setVolume(.4);
						break;
					case nav.volumeBar.volumeThree: 
						setVolume(.6);
						break;
					case nav.volumeBar.volumeFour: 
						setVolume(.8);
						break;
					case nav.volumeBar.volumeFive: 
						setVolume(1);
						break;
				}
			};
			nav.volumeBar.mute.addEventListener(MouseEvent.CLICK, volumeEvent);
			nav.volumeBar.mute.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
			nav.volumeBar.volumeOne.addEventListener(MouseEvent.CLICK, volumeEvent);
			nav.volumeBar.volumeOne.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
			nav.volumeBar.volumeTwo.addEventListener(MouseEvent.CLICK, volumeEvent);
			nav.volumeBar.volumeTwo.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
			nav.volumeBar.volumeThree.addEventListener(MouseEvent.CLICK, volumeEvent);
			nav.volumeBar.volumeThree.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
			nav.volumeBar.volumeFour.addEventListener(MouseEvent.CLICK, volumeEvent);
			nav.volumeBar.volumeFour.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
			nav.volumeBar.volumeFive.addEventListener(MouseEvent.CLICK, volumeEvent);
			nav.volumeBar.volumeFive.addEventListener(MouseEvent.ROLL_OVER, volumeEvent);
//═ FULLSCREEN ══════════════════════════════════════════════════════════════════════;
			var fullscreenEvent:Function = function(e:Event):void
			{
				player.Fullscreen(stage);
			};
			nav.fullscreen.addEventListener(MouseEvent.CLICK, fullscreenEvent);
		
		}
		
//═ POSE ══════════════════════════════════════════════════════════════════════;
		public function pose(W:Number, H:Number):void
		{
			trace('Pose: ' + W + 'x' + H);
			this.W = W;
			this.H = H;
			background.x = screen.x = overlay.x = 0;
			background.y = screen.y = overlay.y = 0;
			background.width = overlay.width = W;
			background.height = overlay.height = H;
			overlay.alpha = 0;
			var proportion:Number = W / H;
			var videoproportion:Number = info.width / info.height;
			if (videoproportion >= proportion)
			{ //<= (H / W)
				screen.width = W;
				screen.height = W / videoproportion;
			}
			else
			{
				screen.width = H * videoproportion;
				screen.height = H;
			}
			screen.x = (W - screen.width) * .5;
			screen.y = (H - screen.height) * .5;
			overButton.x = (W - overButton.width) * .5;
			overButton.y = (H - overButton.height) * .5;
			buffering.x = (W - buffering.width) * .5;
			buffering.y = (H - buffering.height) * .5;
			//NAVIGATOR
			nav.y = H - 26;
			nav.bar.width = W;
			nav.pauseButton.y = nav.playButton.y;
			nav.progressBar.x = 0;
			nav.progressBar.y = nav.playingBar.y = nav.bar.y - 10;
			if (fullscreen)
			{
				nav.fullscreen.x = nav.bar.width - nav.fullscreen.width - 10;
			}
			else
			{
				nav.fullscreen.visible = false;
			}
			nav.volumeBar.x = nav.playButton.width + 10;
			nav.notify.x = nav.volumeBar.x + nav.volumeBar.width + 10;
			nav.progressBar.width = nav.playingBar.width = W;
			nav.progressBar.width = ((info.progress * W * .01) >> 0);
		}
		
		private function formatTime(time:Number):String
		{
			if (time > 0)
			{
				var integer:String = String((time / 60) >> 0);
				var decimal:String = String((time % 60) >> 0);
				return ((integer.length < 2) ? "0" + integer : integer) + ":" + ((decimal.length < 2) ? "0" + decimal : decimal);
			}
			else
			{
				return String("00:00");
			}
		
		}
	}
}