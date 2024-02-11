precision mediump float;


#define steps  12.
#define pi  (3.14159265359*2.)/steps


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

float quadOut(float t) {
    return -t * (t - 2.0);
}







vec3 rings(vec2 uv ,vec3 colorA, vec3 colorB, float u_time){

//uv.x *= resolution.x/resolution.y;
 colorA = theme_color;
 colorB = theme_color;
float d = length(uv);
d = smoothstep(0.201,0.2,d);
vec3 col = vec3(0.);
float breath = abs( sin(u_time/4.)*sin(u_time/4.)  );
uv /= breath+.2;     
  


for(float i = 1.;i<(steps+1.);i++){

    vec2 p = vec2( sin(pi * i + sin(u_time/3.)) , cos(pi * i + sin(u_time/3.)) );
    p *= 0.1 * (breath);

    float dd = length(uv-p);
    // float dd = length(uv);
float str = smoothstep(0.202,0.201,dd);
str -= smoothstep(0.2,0.199,dd);
vec3 stroke = vec3(str);
d = smoothstep(0.201,0.2,dd);
float nd = smoothstep(0.201,0.1,dd);
float sh = smoothstep(0.1,0.4,length(uv));
vec3 c = mix(colorA,colorB,sin(pi * i + u_time));

col +=  (vec3(d)/(10.) )*colorA + (stroke)*sh/2.;

// col = vec3(sh);
}
return col;
}

void main()
{

    // Transforming the pixel coordinates to the range of [-1, 1]
    vec2 position = gl_FragCoord.xy/resolution.xy * 2.0 - 1.0;

    position.x *= resolution.x / resolution.y;

    float distance = length(position - center);

    float radius_phase = 0.0;
    if (breath_part == 0 || breath_part == 4) {
        radius_phase = 0.0;
    } else if (breath_part == 1) {
        radius_phase = quadOut(phasor_part);
    } else if (breath_part == 2) {
        radius_phase = 1.0;
    } else if (breath_part == 3) {
        radius_phase = quadOut(1.0-phasor_part);
    }

    float radius = radius_min + (radius_max - radius_min) * radius_phase;
    float progress_radius = radius*(1.0-session_part_progress);
    
 
        gl_FragColor = vec4(rings(position, theme_color, theme_color,session_part_progress * 12.), 1.0);

}






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

float quadOut(float t) {
    return -t * (t - 2.0);
}

void main()
{
    // Transforming the pixel coordinates to the range of [-1, 1]
    vec2 position = gl_FragCoord.xy/resolution.xy * 2.0 - 1.0;

    position.x *= resolution.x / resolution.y;

    float distance = length(position - center);

    float radius_phase = 0.0;
    if (breath_part == 0 || breath_part == 4) {
        radius_phase = 0.0;
    } else if (breath_part == 1) {
        radius_phase = quadOut(phasor_part);
    } else if (breath_part == 2) {
        radius_phase = 1.0;
    } else if (breath_part == 3) {
        radius_phase = quadOut(1.0-phasor_part);
    }

    float radius = radius_min + (radius_max - radius_min) * radius_phase;
    float progress_radius = radius*(1.0-session_part_progress);

    if (distance < progress_radius) {
        gl_FragColor = vec4(pow(theme_color, vec3(2.0)), 1.0);
    } else if (distance < radius) {
        gl_FragColor = vec4(theme_color, 1.0);
    } else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
}