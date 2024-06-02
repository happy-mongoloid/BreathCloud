precision mediump float;






uniform vec2 u_resolution;
uniform float u_time;
 vec3 theme_color = vec3(0.8667, 1.0, 0.9451);


vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs((q.z + (q.w - q.y) / (6.0 * d + e))), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
// vec3(0.969, 0.996, 0.000)
// vec3(0.463, 0.031, 0.667)

// # Color Scheme 2
// vec3(0.039, 0.392, 0.643)
// vec3(1.000, 0.565, 0.000)
// Function to calculate the complementary color
vec3 getComplementaryColor(vec3 color) {
    // Convert RGB to HSV
    vec3 hsv = rgb2hsv(color);

    // Adjust the hue by 180 degrees (0.5 in normalized range)
    hsv.x = mod(hsv.x + 0.5, 1.0);

    // Convert back to RGB
    return hsv2rgb(hsv);
}

vec3 colorPalett(vec3 colorIn,float value){
     vec3 color = getComplementaryColor(colorIn);
    vec3 colorOut = mix(color,colorIn,pow(value,1.5))*value;

    return colorOut;
}



#define pi  (3.14159265359*2.)
#define steps  22.
float rings(vec2 uv , float phaseVal,float mainMovement,float talk){


        float col = (0.);
        
         for(float i = 1.;i<=6.;i++){

            for(float j = 1.;j<=6.;j++){
            
            // float valY = j / 5.;
            vec2 p = vec2(0.0);
            float a = (pi / 6.) * i ;
            float aj = (pi / 6.) * j ;
            
            float x = sin(a)*0.2 + sin(aj)*0.2;
            float y = cos(a)*0.2 + cos(aj)*0.2;
            

              p = vec2(x*phaseVal, y*phaseVal);
            // p.x /= phaseVal*12.;

        //base circle
        float d = length(uv-p);

        //Drawing circle stroke
        float strokeDist = smoothstep(0.21,0.2,d);
        strokeDist -= smoothstep(0.2,0.19,d);
       

        //adding circles with stroke
        col +=  strokeDist;
        
        }
}
      float d = length(uv);
        // d = smoothstep(0.101,0.1,d);
    float size = mix(0.2,0.6,phaseVal);
     float mainCircle = smoothstep(size + 0.03 ,size,d);
        mainCircle -= smoothstep(size,size - 0.01,d);
        col += mainCircle;
    col = clamp(col,0.0,1.);
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

    float breathValue =  abs(sin(u_time/4.));
// float breathValue = u_time;
    // breathValue = 0.9;
    float shift = 0.02;
       float d = length(position.y);
    shift *= d/2.;

    position.x += shift;
    float ringR =  rings(position, breathValue ,breathValue,0.);
    position.x -= shift;
    position.y -= shift;
    float ringG =  rings(position, breathValue ,breathValue,0.);
    float ringB =  rings(position, breathValue ,breathValue,0.);


    vec3 col = vec3(ringR,ringG,ringB)*theme_color;
        // vec3 col = colorPalett(theme_color,ring);
    gl_FragColor = vec4(col, 1.0);

}



