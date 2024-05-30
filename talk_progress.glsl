#ifdef GL_ES
 precision mediump float;
 precision mediump int;
 #endif


 uniform float u_time;
 uniform vec2 u_mouse;
 uniform vec2 u_resolution;
vec3 theme_color = vec3(0.1,0.9,0.6);
#define pi 3.14159265358979 * 2.

float noise11(float x) {
    float fractX = fract(x);
    float intX = floor(x);
    float r0 = fract(sin(intX) * 43758.5453);
    float r1 = fract(sin(intX + 1.0) * 43758.5453);
    return mix(r0, r1, fractX);
}

float modd(float a, float b)
{
    return a - b * floor(a / b);
}
float talkAnimation(vec2 uv,float value ){
     float d = length(uv);
    d  = smoothstep(0.212,0.205,d);

    for(float i = 0.; i< 8.;i++){
        
         float itr = float(8. - i);
         float itrS = float(8. - i);
         if(modd(float(i), float(2)) == 0.){
                itr -= 1.;
                 itr = -itr;
                  itrS -= 1.;
                 itrS = -itrS;
            }
        

        float shift = (itr) / 8.;
         float shiftS = (1. - abs(itrS) / 8.) * sign(itrS) / 6. ;
         shiftS *= value;
    float dIterate = length(vec2(uv.x + shiftS,uv.y));
    dIterate = smoothstep(0.212*(0.7 + abs(shift/3.)) ,0.2*(0.7 + abs(shift/3.)) ,dIterate)/6.;
    d += dIterate;
    }
        return clamp(d,0.0,1.0);
    }

float diffuseSphere(vec2 p,vec2 c, float r,vec3 l)
{
    float px = p.x - c.x;
    float py = p.y - c.y;
    float sq = r*r - px*px - py*py;
    if(sq<0.)
    {
    	return 0.;
        //return smoothstep(-.1,0.,sq);
    }
    
	float z = sqrt(sq);
	vec3 normal = normalize(vec3(px, py, z));
	float diffuse = max(0., dot(normal, l));
	return diffuse;
}
 float progressAnimation(vec2 uv,float value ){
     float progress = value;
 float r = .2;   
    vec3 vp = vec3(sin(0.0), cos(progress*.2 - pi / 2.  ), sin(progress*.2 + pi* 2.));
    vec3 vl = normalize(vp);
    vec2 pc = vec2(0.);
	float diffuse = diffuseSphere(uv,pc,r,vl);
    
    return mix(diffuse,1.0,clamp(((value  / (6.))-1. )*2.5,0.0,2.0)/2.);
 }  
void main()
{
 vec2 uv = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    uv.x *= u_resolution.x / u_resolution.y;

    float t = 0.0 ;
    
     t = clamp(u_time,0.0,1.);


float v = (t*14.);
float d =  (progressAnimation(uv,v*1.2 -pi));
//  d *= 3.;      
 
  d = talkAnimation(uv,abs(sin(u_time)));

gl_FragColor = vec4(theme_color*d,1.0);
}