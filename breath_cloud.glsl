precision mediump float;






uniform vec2 u_resolution;
uniform float u_time;
 vec3 theme_color = vec3(0.1,0.9,0.6);





#define pi  (3.14159265359*2.)
#define steps  12.
vec3 rings(vec2 uv ,vec3 color, float phaseVal,float mainMovement,float talk){


        vec3 col = vec3(0.);
        uv /= 1.0 + clamp(0.5,1.0,phaseVal*12.) ;
         for(float i = 1.;i<(steps+1.);i++){

            vec2 p = vec2( sin((pi / steps )* i + (mainMovement))*(phaseVal*1.5 + talk/2. ) , cos((pi / steps) * i + (mainMovement))*phaseVal*1.5 );
            

        //base circle
        float d = length(uv-p);

        //Drawing circle stroke
        float strokeDist = smoothstep(0.202,0.201,d);
        strokeDist -= smoothstep(0.2,0.199,d);
        vec3 strokeColor = (color/2.);
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

    // Transforming the pixel coordinates to the range of [-1, 1]
    vec2 position = gl_FragCoord.xy/u_resolution.xy * 2.0 - 1.0;

    position.x *= u_resolution.x / u_resolution.y;

    float distance = length(position );
//   phasor_whole = u_time;
    
    //  vec3 particleCol = vec3(0.0);

    float breathValue =  abs(sin(u_time/4.))/17.;
// float breathValue = u_time;

  

    vec3 col = rings(position, theme_color, breathValue ,breathValue,0.);
        
    gl_FragColor = vec4(col, 1.0);

}



