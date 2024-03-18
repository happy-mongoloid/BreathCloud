precision mediump float;



#define pi  (3.14159265359*2.)


float radius_min = 0.2;
float radius_max = 0.4;
float center = 0.0;

uniform vec2 u_resolution;
uniform float u_time;
 vec3 theme_color = vec3(0.1,0.9,0.6);

int session_part;
float session_part_progress;
int breath_part;
float phasor_whole;
float phasor_half;
float phasor_part;



#define iTime u_time
#define time u_time


float easyIn(float val){
    return pow(val, 2.0);
}

float easyOut(float val){
    return 1.0 - pow(1.0 - val, 2.0);
}

float easyInEasyOut(float val){
    return (val < 0.5) ? easyIn(val * 2.0) / 2.0 : easyOut(val * 2.0 - 1.0) / 2.0 + 0.5;
}

float particles(vec2 uv, float phaseVal,float mainMovement,float talk, vec2 particlesUv){

particlesUv *= 0.8;
    float center = length(uv);
   float smoothMix = mix(0.0,0.015,phaseVal);

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
            particleSize /= mix( (0.5),((phaseVal) + 1.),easyIn(phaseVal)  );//pow( 1. + phaseVal, 2.0) * .;
            particleSize = clamp(0.,1.0,particleSize);
            // particleSize += talk;
            dist = smoothstep(particleSize + 0.1,particleSize + 0.05,dist);
        	particlesSum +=  (dist);
            

    	}
    }

    particlesSum = clamp(0.0,1.0,particlesSum);
    return particlesSum ;
}


void main()
{

    // Transforming the pixel coordinates to the range of [-1, 1]
    vec2 uv = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    uv.x *= u_resolution.x / u_resolution.y;
    
     

    float talk_value = 0.0;
    
    //  position /= 1.0 + talk_value; 
     phasor_whole = u_time;
    
     vec3 particleCol = vec3(0.0);

    float phase = abs(sin(u_time/4.));

     float particleSum = particles(uv, phase,phasor_whole,0.0, uv * mix(4.5,5.5 ,(1.-phase) ) );

       particleCol = vec3(particleSum)*theme_color;
 
        gl_FragColor = vec4(particleCol, 1.0);

}





