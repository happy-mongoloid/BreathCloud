precision mediump float;






uniform vec2 u_resolution;
uniform float u_time;
 vec3 theme_color = vec3(0.1,0.9,0.6);



#define pi  (3.14159265359*2.)
#define steps  18.
#define iResolution u_resolution
#define iTime u_time
#define fragCoord gl_FragCoord


mat2 rot(float a){
    return mat2(cos(a),-sin(a),sin(a),cos(a));
}
float branch(vec2 uv,float height,float size){
vec2 branch = vec2(0,clamp(uv.y,0.,height));
    float d = length(uv - branch);
    return size/d;

}

void main()
{

    // Transforming the pixel coordinates to the range of [-1, 1]
   vec2 uv = gl_FragCoord.xy/u_resolution.xy - vec2(.5,0);
    uv.x *= u_resolution.x/u_resolution.y;
    vec3 col;
    float size = .0005;
    float height = .3;
    uv *= 3.;
    float d = branch(uv,height,size);
   
    for(float i =0.;i<12.;i++){
            uv.x = abs(uv.x);
            uv.y -= height;
        
            height/=1.1;
            uv *= rot(sin(u_time)/12.);
            float d2 = branch(uv,height,size);
            d = max(d,d2);
    }
    col+= d;
    float D = branch(uv,height,size);

    col+= D;
   gl_FragColor = vec4(col,1.0);

}



