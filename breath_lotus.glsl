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

float drawLeaf(vec2 uv, float rotation, float i, float scale, float close,float roundness, float timeL3,float timeL4)
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
    float smoothZeroCircle = mix(0.2,0.1,close);
    close *= 3.; 
    close = clamp(close,0.0,1.0);
    vec2 uv2 = uv;
    uv2.y -= 0.5;
    uv2 = mix(uv2,vec2(uv2.x,uv2.y/1.3),close);

    float l2 = abs(uv.x ) + length(uv2);	
    float l3 = abs(uv.x )*(1.3 - timeL4 ) + length(uv2)/(1.3);// + (sin(abs(uv.y - 0.5)*22. - u_time))/112.;	
     l3 = smoothstep(0.32,0.,l3);
    

    l2 = mix(smoothstep(0.22,mix(0.2,0.,close),length(uv2)),smoothstep(0.22,0.,l2),close);
     float x = abs(uv.x- band * sign( (rotation)) /scale)  ;
    
	float alpha = pow(uv.y,   0.5 - abs(rotation)/16.   )/.3;
    float grassEdgeX = sin(alpha);
    grassEdgeX *= (0.1 + .9*uv.y*uv.y);
	float l = grassEdgeX-x; 
    l = smoothstep(0.1, mix(0.12,0.12,clamp(abs(rotation),0.0,1.0)), l);

     uv.y -= 0.7+roundness/62.;
    uv.y *= 0.5*uv.y;
    float rounded = length(uv);
    l *= smoothstep(0.14,0.11,rounded );
    if(timeL3 > 0.1){
        l2 = l3;
    } 
     l = mix(l2,l,  close); ;

    return l;
}

float lotusL(vec2 uv, float time,float scale,float scaleB, int count,float timeL3,float timeL4)
{
   float leaf = 0.0;
        for(int i = 1; i <= 8; i++){
            
            
            float itr = float(i);
            if(modd(float(i), float(2)) == 0.){
                itr -= 1.;
                itr = -itr;         
            }
            float rad = (time * pi * (itr / scale) )/1.1;
            leaf += drawLeaf(uv,rad,itr, scaleB,abs(time),float(abs(itr)),timeL3,timeL4)/6.;
        }
    return leaf;
}

float lotusS(vec2 uv, float time,float scale,float scaleB, int count,float timeL3,float timeL4)
{
   float leaf = 0.0;
        for(int i = 1; i <= 6; i++){
            
            
            float itr = float(i);
            if(modd(float(i), float(2)) == 0.){
                itr -= 1.;
                itr = -itr;         
            }
            float rad = (time * pi * (itr / scale) )/1.1;
            leaf += drawLeaf(uv,rad,itr, scaleB,abs(time),float(abs(itr)),timeL3,timeL4)/6.;
        }
    return leaf;
}
float lotusFlower(vec2 uv, float t ,float timeL3,float timeL4)
{
     uv /= mix(1.0, 1.2,abs(t));
         uv *= 1.025;
        uv.y += 0.5;        
        vec2 spos = uv;
       
         uv.y -= 0.1;
        uv.y *= 1.15; 
       float flower = lotusL(
         mix(spos,uv*1.1,pow(abs(t),0.75))
        ,t, 11.5,1.2,6,timeL3,timeL4);
        uv.y /= 1.15;
        flower  += lotusS(
            mix(spos,uv*1.2,pow(abs(t),0.75))
            , t, 23., 0.8,6,timeL3,timeL4);
        flower = clamp(flower,0.0,1.0);
         flower *= 2.0; 
        flower = pow(flower,mix(1.0,0.5,t));
        flower /= 2.0;
        
        
        
    return flower;
}

void main()
{
   vec2 uv = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    uv.x *= u_resolution.x / u_resolution.y;
    
    vec3 col = vec3(0.);

    vec3 color = vec3(0.0);
   
   
    float d = 0.0;
    for(float i = 0.; i< 8.;i++){
         float ns = (sin( noise11(i)*pi*2. )/12. ) * abs(sin(u_time));
        float shift = i / 8.;
    float dIterate = length(vec2(uv.x + ns/2.,uv.y));
    dIterate = smoothstep(0.212,0.205,dIterate)/8.;
    d += dIterate;
    }
    
    
    

        float breath = abs(sin(time/4. ));
        // breath = (breath + clamp(u_time/14.,0.0,0.07)) * 0.9;
        //  breath = sin(time/4. );
        // breath = 0.0;   
         float flower = lotusFlower(uv,breath,0.21,sin(time));
   
    
        //  flower = clamp(0.,0.9,flower+0.1);
        //  flower = d;
        color = theme_color*flower;
  
    
  

    gl_FragColor = vec4(color,1.0);
}