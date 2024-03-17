#ifdef GL_ES
 precision mediump float;
 precision mediump int;
 #endif


 uniform float u_time;
 uniform vec2 u_mouse;
 uniform vec2 u_resolution;

vec2 rotateUV(vec2 uv, float rotation)
{
    return vec2(
        cos(rotation) * uv.x + sin(rotation) * uv.y,
        cos(rotation) * uv.y - sin(rotation) * uv.x
    );
}
float smin( float a, float b, float k )
{
	float h = clamp( 0.5 + 0.5*(b-a)/k, 0.0, 1.0 );
	return mix( b, a, h ) - k*h*(1.0-h);
}

float drawLeaf(vec2 uv, float rotation, float scale,float close)
{

    uv.y -= 0.3;
    uv = rotateUV(uv, rotation);
    uv.y += 0.3;


    float factor = 1.0;
    if(scale< 0.0)
    {
      factor = 1.0 - rotation/12.;
    
    }else{
        factor = 1.0 - rotation/12.;
    }
    
 
    float x = abs(uv.x);	
    vec2 uv2 = uv;
    uv2.y -= 0.5;
    uv2 = mix(uv2,vec2(uv2.x,uv2.y/1.3),close);

    float l2 = abs(uv.x ) + length(uv2);	

    l2 = mix(smoothstep(0.22,0.,length(uv2)),smoothstep(0.22,0.,l2),close);

    // l2 = ;
    //  uv.y *= 1.3;
	float alpha = pow(uv.y, .5)/.3;
    float grassEdgeX = sin(alpha);
    grassEdgeX *= (0.1 + .9*uv.y*uv.y);
    
	float l = grassEdgeX-x; 
    float d = length(uv - l);//length(uv / l);
    
    d = smoothstep(0.22,0.2,d);
    l = mix(smoothstep(0.1,0.2,l),l2,0.5); 
    
    uv.y -= 0.4;

    // float d = length(uv);//length(uv / l);
    
    // d = smoothstep(0.22,0.2,d);

    float outP = l;//smin(d,l,d);//+ distance(l,1.-d);
    // return l;
     return outP;
}

void main()
{
vec2 uv = gl_FragCoord.xy / u_resolution.xy-0.5;
uv.x *= u_resolution.x/u_resolution.y;
uv.y += 0.3;

float d = length(uv);
d = smoothstep(0.22,0.2,d);
vec3 col = vec3(d);
float leaf = drawLeaf(uv,0.,1.,abs(sin(u_time))  );
col = vec3(leaf);

gl_FragColor = vec4(col,1.0);




}