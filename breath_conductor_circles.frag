precision mediump float;




float radius_min = 0.2;
float radius_max = 0.4;
float center = 0.0;

uniform vec2 resolution;
uniform vec3 theme_color;

uniform int session_part;
uniform float session_part_progress;
uniform int breath_part;
uniform float phasor_whole;
uniform float phasor_half;
uniform float phasor_part;

//Talk amplitude vale should come here
//uniform float talk_value;
 float talk_value = 0.0;
 
 
//here is a noise function to simulate talk visualization
float noise11(float x) {
    float fractX = fract(x);
    float intX = floor(x);
    float r0 = fract(sin(intX) * 43758.5453);
    float r1 = fract(sin(intX + 1.0) * 43758.5453);
    return mix(r0, r1, fractX);
}

float easyIn(float val){
    return pow(val, 2.0);
}

float easyOut(float val){
    return 1.0 - pow(1.0 - val, 2.0);
}

float easyInEasyOut(float val){
    return (val < 0.5) ? easyIn(val * 2.0) / 2.0 : easyOut(val * 2.0 - 1.0) / 2.0 + 0.5;
}

vec3 saturation(vec3 rgb, float adj)
{
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adj);
}

float quadOut(float t) {
    return -t * (t - 2.0);
}

//debug circle
vec3 testCircle( float  testValue, vec2 pos,vec2 position,int testInt){
 vec3 testCol = vec3(0.0);
       

       if(testInt == 0){
        testCol = vec3(1.0);
      }else if(testInt == 1){
            testCol = vec3(1.0, 0.0, 0.0);
      }else if(testInt == 2){
            testCol = vec3(0.2,0.7,0.6);
      }else if(testInt == 3){
           testCol =  vec3(0.2,0.1,0.7);
      }else if(testInt == 4){
           testCol =  vec3(0.7, 0.0, 1.0);
      }
    float distance = length(position - pos);
    distance = smoothstep(0.1 + 
    float(testValue/2.)/2.,
    float(testValue/2.)/2.,
    distance) ; 
    vec3 c = testCol * distance ;
    return c;
}

//circles count
#define steps  12.

#define pi  (3.14159265359*2.)/steps

vec3 rings(vec2 uv ,vec3 color, float phaseVal,float mainMovement,float talk){


vec3 col = vec3(0.);



uv /= 1.0 + clamp(0.5,1.0,phaseVal*12.) ;



for(float i = 1.;i<(steps+1.);i++){

    vec2 p = vec2( sin(pi * i + (mainMovement))*(phaseVal + talk/2. ) , cos(pi * i + (mainMovement))*phaseVal );
    

//base circle
float d = length(uv-p);

//Drawing circle stroke
float strokeDist = smoothstep(0.202,0.201,d);
strokeDist -= smoothstep(0.2,0.199,d);
vec3 strokeColor = saturation(color,0.3);
vec3 stroke = vec3(strokeDist)*strokeColor;
stroke = (stroke)*smoothstep(0.1,0.4,length(uv));

//Drawing a circle 
d = smoothstep(0.201,0.2,d);

//seting circle transparency 
d /= 10.;

//adding circles with stroke
col +=  vec3(d)*color + (stroke);

}

//center smooth circle
float d = length(uv);
float centerD = length(uv);
float centerD2 = centerD;
centerD = smoothstep(0.2,0.1,centerD);
centerD2 = smoothstep(0.2,0.1,centerD2);
vec3 centerCol =  vec3(centerD2)*color;

//adding center smooth circle
col *= 1.0 - centerD;
col += centerCol;
col.r = clamp(0.0,color.r,col.r);
col.g = clamp(0.0,color.g,col.g);
col.b = clamp(0.0,color.b,col.b);
return col;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/resolution.xy * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
    vec3 col = vec3(0.);
    
    //to debug uniforms 
//    col += testCircle(float(session_part_progress/2.),vec2(0.25,0.8), uv,session_part);
   


   //adding talk movement
   if(session_part == 1){
      //perlin noise talk simulation
    talk_value = noise11(session_part_progress*117.)/12.;
   }

   //wrapping breath parts in one value
   float breathValue = 0.0;
   if(breath_part == 0){
   breathValue = 0.0;
   }else if(breath_part == 1){
   talk_value -= phasor_part;
   breathValue = easyInEasyOut( phasor_part);
   }else if(breath_part == 2){
   breathValue = 1.0;
   }else if(breath_part == 3){
   breathValue = 1.0 - easyInEasyOut( phasor_part);
   }else if(breath_part == 4){
   breathValue = 0.0;
   }
   
   //set the circle scale
    uv /= 1.0; 
   //scale down animation 
   breathValue /= 17.;
   
   col += rings(uv, theme_color, breathValue ,phasor_whole,talk_value);
      
        gl_FragColor = vec4(col, 1.0);
}







































