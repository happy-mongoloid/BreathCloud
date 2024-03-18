precision mediump float;


uniform vec2 u_resolution;
uniform float u_time;

#define pi 3.14159265359
#define resolution u_resolution
#define time u_time

vec3 theme_color = vec3(0.1,0.9,0.6);


vec2 rotateUV(vec2 uv, float rotation)
{
    return vec2(
        cos(rotation) * uv.x + sin(rotation) * uv.y,
        cos(rotation) * uv.y - sin(rotation) * uv.x
    );
}

float drawLeaf(vec2 uv, float rotation, float i, float scale, float close,float roundness)
{

    uv.y -= abs(rotation)/6.;
    uv = rotateUV(uv, rotation);
    uv.y += abs(rotation)/6.;


    float factor = 1.0;
    if(i< 0.0)
    {
      factor = 1.0 - rotation/12.;
    }else{
        factor = 1.0 - rotation/12.;
    }
    float band = smoothstep(0.0, 0.32, abs(uv.y - 0.5) * (1. - abs(rotation) ) * abs(rotation) ) ;

    close *= 3.;
    close = clamp(close,0.0,1.0);
    vec2 uv2 = uv;
    uv2.y -= 0.5;
    uv2 = mix(uv2,vec2(uv2.x,uv2.y/1.3),close);

    float l2 = abs(uv.x ) + length(uv2);	
    l2 = mix(smoothstep(0.21,mix(0.2,0.,close),length(uv2)),smoothstep(0.22,0.,l2),close);
     float x = abs(uv.x- band * sign( (rotation)) /scale)  ;
    
	float alpha = pow(uv.y,   0.5 - abs(rotation)/16.   )/.3;
    float grassEdgeX = sin(alpha);
    grassEdgeX *= (0.1 + .9*uv.y*uv.y);
	float l = grassEdgeX-x; 
    l = smoothstep(0.1, mix(0.12,0.12,clamp(abs(rotation),0.0,1.0)), l);

     uv.y -= 0.7+roundness/62.;
    uv.y *= 0.5*uv.y;
    float rounded = length(uv);
    l *= smoothstep(0.13,0.12,rounded );
     l = mix(l2,l,  close); ;

    return l;
}

float modd(float a, float b)
{
    return a - b * floor(a / b);
}

float lotus(vec2 uv, float time,float scale,float scaleB)
{
   float leaf = 0.0;
        for(int i = 1; i <=6; i++){
            
            
            float itr = float(i);
            if(modd(float(i), float(2)) == 0.){
                itr -= 1.;
                itr = -itr;         
            }
            float rad = (time * pi * (itr / scale) );
            leaf += drawLeaf(uv,rad,itr, scaleB,abs(time),float(abs(itr)))/4.;
        }
    return leaf;
}

float lotusMai(vec2 uv, float time )
{
   
         float leaf = lotus(uv, time,10.,1.2);
        uv.y -= 0.1;
        leaf  += lotus(uv*1.2, time,25., 0.8);
        
    return leaf;
}
float lotusFlower(vec2 uv, float t )
{
     uv /= mix(1.0, 1.2,abs(t));
         uv *= 1.025;
        uv.y += 0.5;        
        vec2 spos = uv;
       
         uv.y -= 0.1;
        uv.y *= 1.15; 
       float flower = lotus(
         mix(spos,uv*1.1,pow(abs(t),0.5))
        ,t, 9.5,1.2);
        uv.y /= 1.15;
        flower  += lotus(
            mix(spos,uv*1.2,pow(abs(t),0.5))
            , t, 23., 0.8);
        flower = clamp(flower,0.0,1.0);
    return flower;
}

void main()
{
   vec2 uv = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    uv.x *= u_resolution.x / u_resolution.y;
    
    vec3 col = vec3(0.);

    vec3 color = vec3(0.0);
   
        float breath = 0.0;//sin(time/4. );
         breath = sin(time/4. );
         float flower = lotusFlower(uv,breath);
        color = theme_color*flower;
  
    
  

    gl_FragColor = vec4(color,1.0);
}