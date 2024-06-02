precision mediump float;






uniform vec2 u_resolution;
uniform float u_time;
 vec3 theme_color = vec3(0.1,0.9,0.6);

vec2 rotateUV(vec2 uv, float rotation)
{
    return vec2(
        cos(rotation) * uv.x + sin(rotation) * uv.y,
        cos(rotation) * uv.y - sin(rotation) * uv.x
    );
}

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noiseFbm(vec2 p, float time){
	vec2 ip = floor(p+(time/21.));
	vec2 u = fract(p+(time/21.));
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}

#define NUM_OCTAVES 5
float fbm(vec2 x, float time) {
	float v = 0.0;
	float a = 0.5;
	vec2 shift = vec2(100);
	// Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));
	for (int i = 0; i < NUM_OCTAVES; ++i) {
		v += a * noiseFbm(x,time);
		x = rot * x * 2.0 + shift;
		a *= 0.5;
	}
	return v;
}


float hash21(vec2 p){
    p = fract(p*vec2(123.34, 456.21));
    p += sin( p*12.);
    return fract((p.x+2.)*p.y);
}
float noise(vec2 p, float freq ){
    
    float unit = freq; 
    vec2 ij = floor(p/unit);
    vec2 xy = mod(p,unit)/unit;
   
    
    float a = hash21((ij+vec2(0.,0.)));
    float b = hash21((ij+vec2(1.,0.)));
    float c = hash21((ij+vec2(0.,1.)));
    float d = hash21((ij+vec2(1.,1.)));
    float x1 = mix(a, b, xy.x);
    float x2 = mix(c, d, xy.x);
    return mix(x1, x2, xy.y);
}



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

float rings(vec2 uv , float rotation,float phaseVal,float talk){


        float col = (0.);
        float st = steps + 1.;//*(phaseVal*2.);
        // uv /= 1.0 + clamp(0.5,1.0,phaseVal*12.) ;
        float rot = 0.0;
        vec2 nUv = uv;
        float fbn = fbm(uv/2.,phaseVal)*2.;
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
        float d = line(uv,vec2(-val/162.),vec2(val/162.) ) + (1. * abs(sin(rotation * pi) + 1.0) )/5.;
        
        d *= 1.0 + fbn*((i + 1.0)/12.)*2.;
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
    float ring  = 1.0 - rings(position , breathValue/8. ,0.0,phaseVal);
    vec3 col = ring*theme_color * rings(position , breathValue/8. ,0.0,phaseVal) *2.0;
        
    gl_FragColor = vec4(col, 1.0);

}

