precision mediump float;


#define steps  12.
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




const float numRings = 1.;
const float offsetMult = 12.;
const float tau = 6.23813;
#define p0 0.5, 0.5, 0.5,  0.5, 0.5, 0.5,  1.0, 1.0, 1.0,  0.0, 0.33, 0.67	
#define iTime u_time
#define time u_time



float quadOut(float t) {
    return -t * (t - 2.0);
}
vec3 saturation(vec3 rgb, float adj)
{
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adj);
}

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
float line(vec2 p, vec2 a, vec2 b){
    vec2 pa = p-a;
    vec2 ba = b-a;
    float t = clamp(dot(pa, ba)/dot(ba,ba),0.,1.0);
    vec2 cv = pa - ba*t;
    float d = length(cv);
    return ( d);
}

float particles(vec2 uv, float phaseVal,float mainMovement,float talk, vec2 particlesUv){
// particlesUv *= mix(0.5,1.0,phaseVal);
particlesUv *= 0.8;
    float center = length(uv);
   float smoothMix = mix(0.0,0.015,phaseVal);
   
    // center = smoothstep(0.2 + smoothMix,0.2,center);
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
            particleSize /= mix( (0.5),((phaseVal) + 1.),easyIn(phaseVal)  );//pow( 1. + phaseVal, 2.0) * .;
            particleSize = clamp(0.,1.0,particleSize);
            // particleSize += talk;
            dist = smoothstep(particleSize + 0.1,particleSize + 0.05,dist);
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

    // Transforming the pixel coordinates to the range of [-1, 1]
    vec2 uv = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    uv.x *= u_resolution.x / u_resolution.y;
    
    

    float talk_value = noise11(u_time*7.)/12.;
    
    //  position /= 1.0 + talk_value; 
     phasor_whole = u_time;
    
     vec3 particleCol = vec3(0.0);

    float phase = 0.0;//abs(sin(u_time/4.));

     float particleSum = particles(uv, phase,u_time,noise11(u_time)/112., uv * mix(4.5,5.5 ,(1.-phase) ) );

       particleCol = vec3(particleSum)*theme_color;
        gl_FragColor = vec4(particleCol, 1.0);

}





