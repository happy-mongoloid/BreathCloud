precision mediump float;


uniform vec2 u_resolution;
uniform float u_time;

#define pi 3.14159265359
#define resolution u_resolution
#define time u_time

uniform vec3 theme_color;


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
    //   factor *= ;
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
    l2 = mix(smoothstep(0.22,mix(0.2,0.,close),length(uv2)),smoothstep(0.22,0.,l2),close);
     float x = abs(uv.x- band * sign( (rotation)) /scale)  ;
    
	float alpha = pow(uv.y,   0.5 - abs(rotation)/16.   )/.3;
    float grassEdgeX = sin(alpha);
    grassEdgeX *= (0.1 + .9*uv.y*uv.y);
	float l = grassEdgeX-x; 
    l = smoothstep(0.1, mix(0.12,0.12,clamp(abs(rotation),0.0,1.0)), l);

     uv.y -= 0.7+roundness/62.;
      uv.x -= 0.015;
    uv.y *= 0.5*uv.y;
    float rounded = length(uv);
    l *= smoothstep(0.16,0.13,rounded );


    
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
            // rad /= smoothstep() float(itr) ;
            // leaf = smoothstep(0.0, 2., leaf);
            //   leaf *= 1.0 - drawLeaf(uv,rad,itr, scaleB,abs(time));
            leaf += drawLeaf(uv,rad,itr, scaleB,abs(time),float(abs(itr)))/6.;
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


void main()
{
    vec2 uv = gl_FragCoord.xy/resolution.xy * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
    
    vec3 col = vec3(0.);
    
    // vec3 mixedCol = mix(vec3(1.0, 1.0, 1.0),vec3(0.0, 0.4784, 0.502),abs(uv.y / 1.5));
    
    vec3 color = vec3(0.0);
     uv.y += 0.5;
   


        uv *= 1.0 + length(uv)/12. ;
        float t = sin(time/4. );
        // float t = 0.0;//sin(time/2.);
       float leaf = lotus(uv,t, 10.,1.2);
        uv.y -= 0.1;
        leaf  += lotus(uv*1.2, t, 25., 0.8);

        leaf = clamp(leaf,0.0,1.0);

        uv.y -= 0.4;
        float d = length(uv);//length(uv / l);
        
        d = smoothstep(0.22,0.2,d);
        // leaf = mix(d,leaf,t);
        color = vec3(0.7647, 0.9294, 0.9804)*leaf;

  

    gl_FragColor = vec4(color,1.0);
}