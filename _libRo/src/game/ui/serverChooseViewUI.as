/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class serverChooseViewUI extends View {
		protected var uiXML:XML =
			<View>
			  <Image url="png.login_interface.win_service" x="0" y="0"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}