#version 120

varying vec3 normal;
varying float shift;
varying vec3 position;
varying float intens;
varying vec4 lcolor;
varying vec4 uv;

uniform int chunkX;
uniform int chunkZ;
uniform sampler2D sampler;
uniform sampler2D lightmap;
uniform vec3 playerPos;
uniform int bits;

float round(float f){
	if (fract(f) < 0.5f){
		return f - fract(f);
	}
	else {
		return f + (1.0f-fract(f));
	}
}

void main()
{
	vec3 lightdark = texture2D(lightmap,gl_TexCoord[1].st).xyz;
	lightdark = clamp(lightdark*lightdark,0.0f,1.0f);
	
	vec4 lcolor = vec4(max(lightdark,lcolor.xyz),lcolor.w);
	
	vec4 baseColor = gl_Color * texture2D(sampler,gl_TexCoord[0].st);
	
	vec3 dv = position-playerPos;
	float dist = max(sqrt(dv.x*dv.x+dv.y*dv.y+dv.z*dv.z) - gl_Fog.start,0.0f) / (gl_Fog.end-gl_Fog.start);
	
	float fog = gl_Fog.density * dist;
				  
	fog = 1.0f-clamp( fog, 0.0f, 1.0f );
	  
	baseColor = vec4(mix( vec3( gl_Fog.color ), baseColor.xyz, fog ).xyz,baseColor.w);
	
	vec4 color = vec4(max(mix(baseColor.xyz*lightdark,baseColor.xyz*lcolor.xyz,intens),lightdark*baseColor.xyz),baseColor.w);
	if (bits == 1){
		color = vec4(vec3(pow(color.x,1.5f),pow(color.y,1.5f),pow(color.z,1.5f))*1.25f,color.w);
		color = vec4(round(color.x*8.0f)/8.0f,round(color.y*8.0f)/8.0f,round(color.z*4.0f)/4.0f,color.w);
	}
	gl_FragColor = vec4(color.xyz,color.w);
}