/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	import game.ui.loseDialogUI;
	import game.ui.menuDialogUI;
	import game.ui.winDialogUI;
	public class gameViewUI extends View {
		public var speedBtn:Button;
		public var menuBtn:Image;
		public var pauseBtn:Image;
		public var txtCoin:Label;
		protected var uiXML:XML =
			<View>
			  <Image url="png.td_interface.topBg" x="0" y="0"/>
			  <Image url="png.td_interface.coin" x="8" y="8"/>
			  <Button skin="png.td_interface.btn_speed" x="738" y="8" var="speedBtn" name="speedBtn"/>
			  <Image url="png.td_interface.menuBtn" x="904" y="8" var="menuBtn" name="menuBtn"/>
			  <Image url="png.td_interface.pauseBtn" x="846" y="8" var="pauseBtn" name="pauseBtn"/>
			  <menuDialog x="681" y="341" runtime="game.ui.menuDialogUI"/>
			  <winDialog x="300" y="418" runtime="game.ui.winDialogUI"/>
			  <loseDialog x="59" y="506" runtime="game.ui.loseDialogUI"/>
			  <Label text="999999" x="70" y="8" color="0xffff00" size="36" align="center" bold="true" var="txtCoin" name="txtCoin"/>
			</View>;
		override protected function createChildren():void {
			viewClassMap["game.ui.loseDialogUI"] = loseDialogUI;
			viewClassMap["game.ui.menuDialogUI"] = menuDialogUI;
			viewClassMap["game.ui.winDialogUI"] = winDialogUI;
			createView(uiXML);
		}
	}
}