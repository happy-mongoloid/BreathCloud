#ifdef GL_ES
 precision mediump float;
 precision mediump int;
 #endif


 uniform float u_time;
 uniform vec2 u_mouse;
 uniform vec2 u_resolution;
vec3 theme_color = vec3(0.1,0.9,0.6);
#define pi 3.14159265358979

float noise11(float x) {
    float fractX = fract(x);
    float intX = floor(x);
    float r0 = fract(sin(intX) * 43758.5453);
    float r1 = fract(sin(intX + 1.0) * 43758.5453);
    return mix(r0, r1, fractX);
}
float talkAnimation(vec2 uv,float value ){
float d = 0.0;
    for(float i = 0.; i< 8.;i++){
         float ns = (sin( noise11(i)*pi*2. )/12. ) * value;
        float shift = i / 8.;
    float dIterate = length(vec2(uv.x + ns,uv.y));
    dIterate = smoothstep(0.212,0.205,dIterate)/8.;
    d += dIterate;
    }
        return d;
    }


void main()
{
 vec2 uv = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    uv.x *= u_resolution.x / u_resolution.y;


float d = talkAnimation(uv,abs(sin(u_time)));



gl_FragColor = vec4(theme_color*d,1.0);
}