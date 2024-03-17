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
 uniform float narration_amplitude;

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
    float(testValue)/2.,
    float(testValue)/2.,
    distance) ;
    vec3 c = testCol * distance ;
    return c;
}

//circles count
#define steps  12.

#define pi  (3.14159265359*2.)

float particles(vec2 uv, float phaseVal,float mainMovement,float talk, vec2 particlesUv){

    float center = length(uv);
   float smoothMix = mix(0.0,0.015,phaseVal);
    center = smoothstep(0.2 + smoothMix,0.2,center);
    // center = mix(smoothstep(0.201,0.2,center),smoothstep(0.4,0.2,center),phaseVal);
     float particlesSum = 0.0;
     
         for (float iCircle = 1.; iCircle <= 5.; iCircle+=1.0){
             float numParticles = 3. * iCircle;
            for (float iParticle = 0.; iParticle < 100.; iParticle++) {
                if (iParticle >= numParticles) {
                     break;
                 }
            float rad = (pi / numParticles) * iParticle;

            float direction = 0.5 - iCircle/12.;

            if((iCircle == 1.)||(iCircle == 3.)||(iCircle == 5.)){
                direction *= -1.0;
            }

            float posX = sin(rad + mainMovement*direction) * (iCircle/2. + 0.) * phaseVal*1.0;
            float posY = cos(rad + mainMovement*direction) * (iCircle/2. + 0.) * phaseVal*1.0;
            vec2 particlePos = vec2(posX,posY);

            float dist = length(particlesUv - particlePos);
            // dist += line(uv,particlePos,vec2(0.0));
            float particleSize = 0.1 ;
            float iterateCircle = (5. - iCircle)/1.;
            particleSize *= iterateCircle;
            particleSize /= mix( 0.5,((phaseVal) + 1.),easyIn(phaseVal)  );//pow( 1. + phaseVal, 2.0) * .;
            particleSize = clamp(0.,1.0,particleSize);
            particleSize += talk;
            dist = smoothstep(particleSize + 0.1,particleSize,dist);
            particlesSum +=  (dist);
            

        }
    }
    // particlesSum *= 1.0 - center;
    // particlesSum += center/2.;
    particlesSum = clamp(0.0,1.0,particlesSum);
    return particlesSum ;
}

void main()
{
    vec2 uv = gl_FragCoord.xy/resolution.xy * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
    vec3 col = vec3(0.);
    
    //to debug uniforms
  //  col += testCircle(float(phasor_part),vec2(0.25,0.8), uv,session_part);
   


   //adding talk movement
   if(session_part == 1){
      //perlin noise talk simulation
      talk_value = noise11(narration_amplitude*117.)/12.;
   }

   //wrapping breath parts in one value
   float breathValue = 0.0;
   if(breath_part == 0){
   breathValue = 0.0;
   }else if(breath_part == 1){
   breathValue = easyOut( phasor_part);
   }else if(breath_part == 2){
   breathValue = 1.0;
   }else if(breath_part == 3){
   breathValue = 1.0 - easyIn( phasor_part);
   }else if(breath_part == 4){
   breathValue = 0.0;
   }
   
   //set the circle scale
    uv /= 1.0;
   //set animation scale
//   breathValue /= 17.;
   
  // col += rings(uv, theme_color, breathValue ,phasor_whole,talk_value);
      
     float particleSum = particles(uv, breathValue,phasor_whole,narration_amplitude, uv * 7. );

      vec3 particleCol = vec3(particleSum)*theme_color;
       col += particleCol;
        gl_FragColor = vec4(col, 1.0);
}







































