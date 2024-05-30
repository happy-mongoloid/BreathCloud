precision mediump float;






uniform vec2 u_resolution;
uniform float u_time;
 vec3 theme_color = vec3(0.1,0.9,0.6);



float line(vec2 p, vec2 a, vec2 b){
    vec2 pa = p-a;
    vec2 ba = b-a;

    float t = clamp(dot(pa, ba)/dot(ba,ba),0.,1.0);
    vec2 cv = pa - ba*t;
    
    float d = length(cv);
    if(distance(a, b)>2.){return 2.;}else{
    return ( d);
    }
}

#define pi  (3.14159265359*2.)
#define steps  22.
vec2 rotateUV(vec2 uv, float rotation)
{
    return vec2(
        cos(rotation) * uv.x + sin(rotation) * uv.y,
        cos(rotation) * uv.y - sin(rotation) * uv.x
    );
}
float rings(vec2 uv , float rotation,float phaseVal,float talk){


        float col = (0.);
        float st = steps + 1.;//*(phaseVal*2.);
        // uv /= 1.0 + clamp(0.5,1.0,phaseVal*12.) ;
        float rot = 0.0;
        vec2 nUv = uv;
         for(float i = 1.;i<(steps+1.);i++){

            // vec2 p = vec2( (pi / steps )/ i + (mainMovement))*(phaseVal*1.5 + talk/2. , (pi / steps) / i + (mainMovement)*phaseVal*1.5 );
            
            // p /= 32.;
        //base circle
        // float d = length(uv/p - p/(i));
        nUv =  rotateUV(nUv,  sin((rotation * pi)) * ( i / st) /2. );

        // uv = nUv;
        uv = mix(nUv,uv,phaseVal);
        float val = i /(st+1.);
        val = mix(val,0.0,phaseVal);
        float d = line(uv,vec2(-val/22.),vec2(val/22.) ) + (1. * abs(sin(rotation * pi) + 1.0) )/5.;
        

        //Drawing a circle
        float cSize = (1.0-val)*3.;
        cSize = mix(cSize,1.0,phaseVal);
        d = smoothstep(0.201 * cSize  ,0.2 * cSize ,d);

        //seting circle transparency
        d /= steps;

        //adding circles with stroke
        col +=  (d) ;//+ (strokeDist)/2.;

        }
     
    return col;
}

void main()
{

    // Transforming the pixel coordinates to the range of [-1, 1]
    vec2 position = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    position.x *= u_resolution.x / u_resolution.y;

    float distance = length(position );
//   phasor_whole = u_time;
    
    //  vec3 particleCol = vec3(0.0);

    float breathValue =  abs((u_time/2.));
// float breathValue = u_time;

  float phaseVal =  abs(sin(u_time/2.));
    //  position =  rotateUV(position, u_time/2.);
    vec3 col = rings(position , breathValue/8. ,0.0,phaseVal)*theme_color;
        
    gl_FragColor = vec4(col, 1.0);

}



