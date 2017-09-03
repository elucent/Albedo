#version 120
varying vec3 normal;
varying float shift;
varying vec3 position;
varying vec4 uv;
varying vec4 lcolor;
varying float intens;

struct Light{
    vec4 color;
    vec3 position;
	float radius;
};

uniform int chunkX;
uniform int chunkY;
uniform int chunkZ;
uniform sampler2D sampler;
uniform sampler2D lightmap;
uniform mat4 modelview;
uniform Light lights[100];
uniform int lightCount;
uniform int maxLights;
uniform float ticks;
uniform int flickerMode;

float rand2(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898f,78.233f))) * 43758.5453f);
}

vec3 rand3(vec3 co){
    return vec3(rand2(co.xz)-0.5f,rand2(co.yx)-0.5f,rand2(co.zy)-0.5f);
}

float rand3f(vec3 co){
    return fract(sin(dot(co.xyz ,vec3(48.7731f, 12.9898f,78.233f))) * 43758.5453f);
}

vec3 rand3v(vec3 co){
    return vec3(rand3f(co.xzy)-0.5f,rand3f(co.yxz)-0.5f,rand3f(co.zyx)-0.5f);
}

float distSq(vec3 a, vec3 b){
	return pow((a.x-b.x),2)+pow((a.y-b.y),2)+pow((a.z-b.z),2);
}

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
    vec4 pos = gl_ModelViewProjectionMatrix * gl_Vertex;
	
	normal = gl_Normal;
	
	position = gl_Vertex.xyz+vec3(chunkX,chunkY,chunkZ);
	vec3 roundedPosition = vec3(0,0,0);
	roundedPosition.x = floor(position.x+0.66f);
	roundedPosition.y = floor(position.y+0.66f);
	roundedPosition.z = floor(position.z+0.66f);
	
	float offset = 0;
	
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_TexCoord[1] = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
	float magnitude = 0.0f*sin((ticks+(roundedPosition.x+roundedPosition.z)/2.0f)/2.0f);
	gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex + vec4(magnitude*rand3v(roundedPosition.xyz),0) + vec4(0,offset,0,0));
	
	gl_FrontColor = gl_Color;
	
	lcolor = vec4(0,0,0,1.0f);
	float sumR = 0;
	float sumG = 0;
	float sumB = 0;
	float count = 0;
	float maxIntens = 0;
	float totalIntens = 0;
	for (int i = 0; i < lightCount; i ++){
		if (distSq(lights[i].position,position) <= pow(lights[i].radius,2)){
			float faceexposure = 1.0f;
			float intensity = pow(max(0,1.0f-distance(lights[i].position,position)/(lights[i].radius)),2) * 1.0f * ((max(0,faceexposure)+0.5f)/1.5f);
			totalIntens += intensity;
			maxIntens = max(maxIntens,intensity);
		}
	}
	for (int i = 0; i < lightCount; i ++){
		if (distSq(lights[i].position,position) <= pow(lights[i].radius,2)){
			float faceexposure = 1.0f;
			float intensity = pow(max(0,1.0f-distance(lights[i].position,position)/(lights[i].radius)),2) * 1.0f * lights[i].color.w * ((max(0,faceexposure)+0.5f)/1.5f);
			sumR += (intensity/totalIntens)*lights[i].color.x;
			sumG += (intensity/totalIntens)*lights[i].color.y;
			sumB += (intensity/totalIntens)*lights[i].color.z;
		}
	}
	lcolor = vec4(max(sumR*1.5f,0.0f), max(sumG*1.5f,0.0f), max(sumB*1.5f,0.0f), 1.0f);
	intens = min(1.0f,maxIntens);
}