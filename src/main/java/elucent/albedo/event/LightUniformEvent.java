package elucent.albedo.event;

import java.util.ArrayList;

import elucent.albedo.lighting.Light;
import net.minecraftforge.fml.common.eventhandler.Event;

public class LightUniformEvent extends Event {
	public LightUniformEvent(){
		super();
	}
	
	@Override
	public boolean isCancelable(){
		return false;
	}
}
