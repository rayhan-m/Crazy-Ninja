//MD. Rayhan Mahmud
//ID:181-16-289

package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.system.fscommand;

	public class main extends MovieClip
	{
		private var menu_bg:MovieClip;
		private var bg:MovieClip;
		private var total_score:MovieClip;
		private var total_apple:MovieClip;

		private var game_over:MovieClip;
		private var levelComplete:MovieClip;
		private var instraction:MovieClip;
		private var btn_left:MovieClip;
		private var btn_right:MovieClip;
		private var btn_up:MovieClip;
		private var hero:MovieClip;
		private var hp:MovieClip;
		private var apple:MovieClip;

		private var eat_apple:Sound;
		private var get_coin:Sound;
		private var enimy_hit:Sound;
		private var bg_music:Sound;
		private var kn_hit:Sound;
		private var win:Sound;
		private var soundChannel:SoundChannel;
	
		var xvelocity = 0;
		var yvelocity = 0;
		var Gravety = 1;
		var friction = .6;
		var score:int = 0;
		var C_apple:int = 0;

		var rightPress:Boolean = false;
		var leftPress:Boolean = false;
		var upPress:Boolean = false;

		var rightRelease:Boolean = true;
		var leftRelease:Boolean = true;
		var upRelease:Boolean = true;

		var onGround:Boolean = false;

		var downArr = new Array(-10,0,20);
		var vertArr = new Array(-20,-30);
		var upArr = new Array(-3,0,3);

		public function main()
		{
			// constructor code
			trace('Bismillah');
			menu_bg= new menu_Bg();
			this.addChild(menu_bg);

			bg= new Bg();
			this.addChild(bg);
			bg.visible = false;
			
			instraction =new Instraction();
			this.addChild(instraction);
			instraction.visible = false;
			
			game_over =new Gameover();
			this.addChild(game_over);
			game_over.visible = false;
			
			levelComplete =new LevelCompelte();
			this.addChild(levelComplete);
			levelComplete.visible = false;

			btn_up= new btn_Up();
			this.addChild(btn_up);
			btn_up.x = 250;
			btn_up.y = 100;
			btn_up.visible = false;

			btn_left= new btn_Left();
			this.addChild(btn_left);
			btn_left.x = 40;
			btn_left.y = 200;
			btn_left.visible = false;

			btn_right= new btn_Right();
			this.addChild(btn_right);
			btn_right.x = 950;
			btn_right.y = 200;
			btn_right.visible = false;

			menu_bg.btn_play.addEventListener(MouseEvent.CLICK,Play);
			menu_bg.ins.addEventListener(MouseEvent.CLICK,ShowInstraction);
			instraction.ins_close.addEventListener(MouseEvent.CLICK,closeInstraction);
			game_over.btn_replay.addEventListener(MouseEvent.CLICK,replayTheGame);
			menu_bg.btn_close.addEventListener(MouseEvent.CLICK, CloseApp);

		}
		function CloseApp(event:MouseEvent) {
			stop();
			trace('close');
		}
		private function ShowInstraction(e:MouseEvent):void
		{
			instraction.visible = true;
		}
		private function closeInstraction(e:MouseEvent):void
		{
			instraction.visible = false;
		}
		private function Play(e:MouseEvent):void
		{
			menu_bg.visible = false;
			
			btn_up.visible = true;
			btn_right.visible = true;
			btn_left.visible = true;
			//hp.visible=true;
			//hero.visible=true;

			eat_apple = new EatApple();
			get_coin = new GetCoin();
			enimy_hit = new EnimyHit();
			bg_music = new BgMusic();
			kn_hit = new KnHit();
			win = new Win();
			soundChannel = new SoundChannel();
			gameStart();
			bg.soundChannel=bg_music.play();
			
		}
		public function replayTheGame(e:MouseEvent):void
		{
			game_over.visible = false;
			//bg.reload;
			hero.x = 20;
			hero.y = 100;
			score = 0;
			C_apple=0;
			gameStart();
		}
		public function gameStart()
		{
			bg.visible = true;
			hp= new Hp();
			this.addChild(hp);
			
			hp.x = 50;
			hp.y = 10;
			hp.scaleX = hp.scaleY = .5;
			
			bg.enimy1.gotoAndPlay(1);
			bg.enimy2.gotoAndPlay(1);
			bg.enimy3.gotoAndPlay(1);
			bg.enimy4.gotoAndPlay(1);
			bg.enimy5.gotoAndPlay(1);
			bg.enimy6.gotoAndPlay(1);
			bg.enimy7.gotoAndPlay(1);
			bg.enimy8.gotoAndPlay(1);
			bg.enimy9.gotoAndPlay(1);

			total_score= new total_Score();
			this.addChild(total_score);
			total_score.x = 800;
			total_score.y = 10;
			total_score.scaleX = total_score.scaleY = .5;
			
			total_apple= new total_Apple();
			this.addChild(total_apple);
			total_apple.x = 970;
			total_apple.y = 10;
			total_apple.scaleX = total_apple.scaleY = .5;

			if (! hero)
			{
				hero= new Hero();
				this.addChild(hero);
				hero.x = 20;
				hero.y = 100;
			}
			this.addEventListener(Event.ENTER_FRAME, onEnter);
			btn_left.addEventListener(MouseEvent.MOUSE_UP, LeftClickUp);
			btn_left.addEventListener(MouseEvent.MOUSE_DOWN, LeftClickDown);
			btn_right.addEventListener(MouseEvent.MOUSE_UP, RightClickUp);
			btn_right.addEventListener(MouseEvent.MOUSE_DOWN, RightClickDown);
			btn_up.addEventListener(MouseEvent.CLICK, UpClick);
			
		}
		public function controlHero()
		{
			if (rightPress)
			{
				xvelocity +=  3;
				hero.scaleX = 1;
			}
			if (leftPress)
			{
				xvelocity -=  3;
				hero.scaleX = -1;
			}
		}
		public function jumpHero()
		{
			onGround = false;
			yvelocity = -15;
		}
		public function UpClick(event:MouseEvent)
		{
			trace('Up');
			if (upPress && onGround)
			{
				jumpHero();
			}
			upPress = true;
		}
		public function RightClickUp(event:MouseEvent)
		{
			trace('Right');
			rightPress = false;
			hero.nextFrame();
		}
		public function RightClickDown(event:MouseEvent)
		{
			trace('Right');
			rightPress = true;
		}
		public function LeftClickUp(event:MouseEvent)
		{
			leftPress = false;
			trace('left');
		}
		public function LeftClickDown(event:MouseEvent)
		{
			leftPress = true;
			trace('left');
		}

		public function bgMove()
		{
			var newx =  -  hero.x * 2;
			bg.x = newx;

		}
		public function physic()
		{
			hero.x +=  xvelocity;
			hero.y +=  yvelocity;

			xvelocity *=  friction;
			yvelocity +=  Gravety;

			downPush(hero);
			upPush(hero);
			leftPush(hero);
			rightPush(hero);
		}

		public function upPush(p)
		{
			for (var i=0; i<downArr.length; i++)
			{
				var num = downArr[i];
				var tx = p.x + num;
				var ty = p.y;

				while (bg.ground.hitTestPoint(tx,ty, true))
				{
					onGround = true;
					p.y--;
					ty--;
					yvelocity = 0;
				}
			}
		}
		public function leftPush(p)
		{
			p.virtx = p.x + xvelocity;
			p.verty = p.y;
			for (var i=0; i<vertArr.length; i++)
			{
				var num = vertArr[i];
				var tx = p.virtx - 20;
				var ty = p.verty + num;

				while (bg.ground.hitTestPoint(tx,ty, true))
				{
					onGround = true;
					p.vertx++;
					p.x++;
					tx++;
					xvelocity = 0;
				}
			}
		}
		public function rightPush(p)
		{
			p.virtx = p.x + xvelocity;
			p.verty = p.y;
			for (var i=0; i<vertArr.length; i++)
			{
				var num = vertArr[i];
				var tx = p.virtx + 20;
				var ty = p.verty + num;

				while (bg.ground.hitTestPoint(tx,ty, true))
				{
					onGround = true;
					p.verty--;
					p.x--;
					tx--;
					xvelocity = 0;
				}
			}
		}
		public function downPush(p)
		{
			p.virtx = p.x;
			p.verty = p.y;
			for (var i=0; i<upArr.length; i++)
			{
				var num = upArr[i];
				var tx = p.virtx + num;
				var ty = p.verty - 70;

				while (bg.ground.hitTestPoint(tx,ty, true))
				{
					p.verty++;
					p.y++;
					ty++;
					yvelocity = 1;
				}
			}
		}
		public function onEnter(e:Event)
		{

			physic();
			controlHero();
			bgMove();
			hpstop();
			spMove();
			collectCoin();
			collectApple();
			gameCheck();
			checkEnimy();
			
			if (hero.hitTestObject(bg.fallDown))
			{
				hp.gotoAndStop('30');
				trace('rrrr');
			}
			if (hero.hitTestObject(bg.door))
			{
				levelComplete.visible=true;
				this.removeEventListener(Event.ENTER_FRAME, onEnter);
				levelComplete.txt_coin.text= score;
				levelComplete.txt_apple.text = C_apple;
				bg.soundChannel=win.play();
			}
		}
		public function checkEnimy(){
			
			if (bg.enimy1.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy1.stop();
				trace('enimy Hit');
				
			}
			if (bg.enimy2.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy2.stop();
				trace('enimy Hit');
			}
			if (bg.enimy3.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy2.stop();
				trace('enimy Hit');
			}
			if (bg.enimy4.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy4.stop();
				trace('enimy Hit');
			}
			if (bg.enimy5.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy5.stop();
				trace('enimy Hit');
			}
			if (bg.enimy6.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy6.stop();
				trace('enimy Hit');
			}
			if (bg.enimy7.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy7.stop();
				trace('enimy Hit');
			}
			if (bg.enimy8.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy8.stop();
				trace('enimy Hit');
			}
			if (bg.enimy9.hitTestObject(hero))
			{
				hp.gotoAndStop('30');
				
				bg.enimy9.stop();
				trace('enimy Hit');
			}
		}

		public function spMove()
		{
			bg.kn.rotation +=  3;
			bg.kn1.rotation +=  3;
			bg.kn2.rotation +=  3;
			bg.kn3.rotation +=  3;

			if (hero.hitTestObject(bg.kn))
			{
				hp.nextFrame();
				bg.soundChannel=kn_hit.play();
				trace('rrrr');
			}
			if (hero.hitTestObject(bg.kn1))
			{
				hp.nextFrame();
				bg.soundChannel=kn_hit.play();
				trace('ssss');
			}
			if (hero.hitTestObject(bg.kn2))
			{
				hp.nextFrame();
				bg.soundChannel=kn_hit.play();
				trace('rrrr');
			}
			if (hero.hitTestObject(bg.kn3))
			{
				hp.nextFrame();
				bg.soundChannel=kn_hit.play();
				trace('ssss');
			}
		}
		public function hpstop()
		{
			hp.stop();

		}
		public function gameCheck()
		{
			if (hp.currentFrame == 30)
			{
				trace('Game Over');
				bg.soundChannel=enimy_hit.play();
				this.removeEventListener(Event.ENTER_FRAME, onEnter);
				game_over.txt_coin.text= score;
				game_over.txt_apple.text = C_apple;
				game_over.visible = true;
			}
		}

		public function collectCoin()
		{
			if (stage.contains(bg.coin1))
			{
				if(hero.hitTestObject(bg.coin1)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin1);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin2))
			{
				if(hero.hitTestObject(bg.coin2)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin2);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin3))
			{
				if(hero.hitTestObject(bg.coin3)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin3);
						
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin4))
			{
				if(hero.hitTestObject(bg.coin4)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin4);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin5))
			{
				if(hero.hitTestObject(bg.coin5)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin5);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin6))
			{
				if(hero.hitTestObject(bg.coin6)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin6);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin7))
			{
				if(hero.hitTestObject(bg.coin7)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin7);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin8))
			{
				if(hero.hitTestObject(bg.coin8)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin8);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin9))
			{
				if(hero.hitTestObject(bg.coin9)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin9);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
			if (stage.contains(bg.coin10))
			{
				if(hero.hitTestObject(bg.coin10)){
					bg.soundChannel=get_coin.play();
					bg.removeChild(bg.coin10);
					trace('0');
					score +=  10;
					total_score.txt_score.text = score;
				}
			}
		}
		public function collectApple()
		{
			if (stage.contains(bg.apple1))
			{
				if(hero.hitTestObject(bg.apple1)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple1);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple2))
			{
				if(hero.hitTestObject(bg.apple2)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple2);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple3))
			{
				if(hero.hitTestObject(bg.apple3)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple3);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple4))
			{
				if(hero.hitTestObject(bg.apple4)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple4);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple5))
			{
				if(hero.hitTestObject(bg.apple5)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple5);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple6))
			{
				if(hero.hitTestObject(bg.apple6)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple6);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple7))
			{
				if(hero.hitTestObject(bg.apple7)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple7);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple8))
			{
				if(hero.hitTestObject(bg.apple8)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple8);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple9))
			{
				if(hero.hitTestObject(bg.apple9)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple9);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple10))
			{
				if(hero.hitTestObject(bg.apple10)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple10);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple11))
			{
				if(hero.hitTestObject(bg.apple11)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple11);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple12))
			{
				if(hero.hitTestObject(bg.apple12)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple12);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple13))
			{
				if(hero.hitTestObject(bg.apple13)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple13);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple14))
			{
				if(hero.hitTestObject(bg.apple14)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple14);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple15))
			{
				if(hero.hitTestObject(bg.apple15)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple15);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
			if (stage.contains(bg.apple16))
			{
				if(hero.hitTestObject(bg.apple16)){
					bg.soundChannel=eat_apple.play();
					bg.removeChild(bg.apple16);
					trace('0');
					C_apple +=  5;
					total_apple.txt_apple.text = C_apple;
				}
			}
		}

	}
}