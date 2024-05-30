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
#define steps  18.
vec2 rotateUV(vec2 uv, float rotation)
{
    return vec2(
        cos(rotation) * uv.x + sin(rotation) * uv.y,
        cos(rotation) * uv.y - sin(rotation) * uv.x
    );
}
float branch(vec2 uv, float colorIn , int step){


        vec2 pos = vec2(0.0);
        float branchL = 0.1;
        float branchStroke = 0.1;
        uv -= pos;
        float d = line(uv,vec2(0., -branchL/2.),vec2(0., branchL/2.) ) ;
        d = smoothstep(branchStroke + 0.02  ,branchStroke,d);
        float col = (d) ;
        return col;
}

void main()
{

    // Transforming the pixel coordinates to the range of [-1, 1]
    vec2 uv = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    uv.x *= u_resolution.x / u_resolution.y;

    float distance = length(uv );
//   phasor_whole = u_time;
    
    //  vec3 particleCol = vec3(0.0);

    float breathValue =  abs((u_time/2.));
// float breathValue = u_time;

  float phaseVal =  abs(sin(u_time/2.));
    //  position =  rotateUV(position, u_time/2.);
    vec3 col = branch(uv,0.0,0) * theme_color;
        
    for(int i = 0; i < 6; i++){

         col += branch(uv,0.0,0) * theme_color;
         
    }


    gl_FragColor = vec4(col, 1.0);

}



