package elucent.albedo.asm;

import java.util.Map;

import net.minecraftforge.fml.relauncher.IFMLLoadingPlugin;

@IFMLLoadingPlugin.TransformerExclusions({"elucent.albedo.asm"})
@IFMLLoadingPlugin.MCVersion("1.12.1")
@IFMLLoadingPlugin.SortingIndex(65536)
public class FMLPlugin implements IFMLLoadingPlugin {
	public static boolean runtimeDeobfEnabled = false;
	@Override
	public String[] getASMTransformerClass() {
		return new String[]{"elucent.albedo.asm.ASMTransformer"};
	}

	@Override
	public String getModContainerClass() {
		return "elucent.albedo.asm.AlbedoCore";
	}

	@Override
	public String getSetupClass() {
		return null;
	}

	@Override
	public void injectData(Map<String, Object> data) {
        runtimeDeobfEnabled = (Boolean) data.get("runtimeDeobfuscationEnabled");
		
	}

	@Override
	public String getAccessTransformerClass() {
		return null;
	}

}
