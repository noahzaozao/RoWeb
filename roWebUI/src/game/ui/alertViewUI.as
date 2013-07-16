/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class alertViewUI extends Dialog {
		public var txtMsg:Label;
		private var uiXML:XML =
			<Dialog>
			  <Image url="png.login_interface.win_msgbox" x="0" y="0"/>
			  <Label text="label" x="15" y="30" width="250" height="50" var="txtMsg" name="txtMsg"/>
			  <Button skin="png.basic_interface.btn_ok" x="233" y="96"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}