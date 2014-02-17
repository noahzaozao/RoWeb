package cg.game.map.player.ui 
{
	import cg.com.extra.SoundManager;

	import flash.display.Bitmap;

	import cg.com.extra.MathTools;

	import com.greensock.TweenMax;

	import flash.geom.Rectangle;
	import flash.display.LineScaleMode;

	import cg.com.lib.FilterLib;
	import cg.com.lib.TextFormatLib;
	import cg.com.ui.lable.Lable;

	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * @author Administrator
	 */
	public class ChatBubble extends Sprite
	{

		private var aniCue: Shape; 
		private var lable: Lable; 
		private var maxAlpha: Number = 0.65;

		public function ChatBubble()
		{
			//addChild(MathTools.makeBall(1 ) );
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.visible = false;
            
			this.aniCue = new Shape();
			this.aniCue.filters = [FilterLib.drop_verySoft];
          
			this.addChildAt(this.aniCue, 0 );
			this.aniCue.cacheAsBitmap = true;
			this.lable = new Lable("", TextFormatLib.white_12px, [FilterLib.drop_classic] ); 
			this.lable.wordWrap = true;
			this.lable.multiline = true;
			this.lable.autoSize = "left";
			this.lable.x = 5;
			this.lable.y = 5; 
			this.lable.width = 120; 
			this.addChild(this.lable );
            // 
		}

		public function showChat(text: String): void
		{ 
			//this.parent && this.parent.addChild(this );
			TweenMax.killDelayedCallsTo(hide ); 
			//return;
			//text = "<p><font color='#55ffff'></font>测试说话内容，撒旦法爱上<p/>"; 
			this.visible = true;
			this.alpha = 1; 
			this.lable.htmlText = text;
			if(this.lable.length == 0)
			{
				return;
			} 
			this.lable.visible = false; 
			//
			var w: int = this.lable.textWidth + 15;
			var h: int = this.lable.textHeight + 13; 
			//
			this.aniCue.graphics.clear();
			this.aniCue.graphics.beginFill(0x000000, 1 );
			this.aniCue.graphics.lineStyle(1, 0xbfe9ff, 1, true, LineScaleMode.NONE ); 
			this.aniCue.graphics.drawRoundRect(0, 0, w, h, 14, 14 ); 
			this.aniCue.scale9Grid = new Rectangle(10, 8, w - 20, h - 16 ); 
			//
			this.aniCue.width = 10;
			this.aniCue.height = 10;
			this.aniCue.alpha = 0; 
			this.aniCue.x = - this.aniCue.width / 2;
			this.aniCue.y = - this.aniCue.height;
            
			TweenMax.to(this.aniCue, 0.15, {width:w , height:h , x:- w / 2 , y:- h , alpha:maxAlpha , onComplete:this.showOver} );
		}

		private function showOver(): void
		{
			this.lable.x = this.aniCue.x + 5;
			this.lable.y = this.aniCue.y + 5;
			this.lable.height;
			this.lable.visible = true;   
            
			TweenMax.delayedCall(2.5, hide );
		}     

		private function hide(): void
		{ 
			//TweenMax.to(this, 0.1, {alpha:0 , visible:false} );
			this.lable.visible = false; 
			TweenMax.to(this.aniCue, 0.1, {width:10 , height:10 , x:- 5 , y: - 10 , alpha:0 } );
		}
	}
}
