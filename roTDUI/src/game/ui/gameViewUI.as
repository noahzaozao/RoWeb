/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class gameViewUI extends View {
		public var speedBtn:Button;
		public var menuBtn:Image;
		public var txtCoin:Label;
		protected var uiXML:XML =
			<View>
			  <Image url="png.td_interface.topBg" x="0" y="0" mouseChildren="false" mouseEnabled="false"/>
			  <Image url="png.td_interface.coin" x="8" y="8"/>
			  <Button skin="png.td_interface.btn_speed" x="780" y="8" var="speedBtn" name="speedBtn"/>
			  <Image url="png.td_interface.menuBtn" x="904" y="8" var="menuBtn" name="menuBtn"/>
			  <Label text="999999" x="70" y="8" color="0xffff00" size="36" align="right" bold="true" var="txtCoin" name="txtCoin" mouseChildren="false" mouseEnabled="false"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}