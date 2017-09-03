#version 120

void main()
{
	gl_FragColor = vec4(gl_FragCoord.z / gl_FragCoord.w,gl_FragCoord.z / gl_FragCoord.w,gl_FragCoord.z / gl_FragCoord.w,1.0f);
}