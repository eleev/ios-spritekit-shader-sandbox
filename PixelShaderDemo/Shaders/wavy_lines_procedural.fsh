

#define PI 3.14159265359
#define FOV (PI*0.4)

#define rot(a) mat2(cos(a+PI*vec4(0,1.5,0.5,0)))

// hash function for dithering
vec3 hash33(vec3 p3) {
    p3 = fract(p3 * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+19.19);
    return fract((p3.xxy + p3.yxx)*p3.zyx);
}

// parametric equation for the path of a single strand
// https://en.wikipedia.org/wiki/Braiding_machine
vec2 path( float x ) {
    float v = step(fract(x), 0.5)*2.0-1.0;
    float th = (mod(x, 0.5)*2.0)*-2.0*PI*v;
    return vec2(v*cos(th)*0.5+v*-0.5, v*sin(th)*0.5);
}

// main distance function
float de( vec3 p, out float id ) {
    
    float sky = 10.0-length(p.xy);
    p.z *= 0.07;
    
    vec2 inS = vec2(0);
    float scale = 1.0;
    id = 0.0;
    
    for (int i = 0 ; i < 3 ; i++) {
        
        // figure out the path of the 3 strands
        vec2 inA = p.xy - path(p.z)*scale;
        vec2 inB = p.xy - path(p.z + (1.0/3.0))*scale;
        vec2 inC = p.xy - path(p.z + (2.0/3.0))*scale;
        
        // pick the closest center
        float dA = dot(inA, inA);
        float dB = dot(inB, inB);
        float dC = dot(inC, inC);
        if (dA < dB && dA < dC) {
            inS = inA;
        } else if (dB < dC) {
            inS = inB;
            id += pow(3.0, float(i));
        } else {
            inS = inC;
            id += 2.0*pow(3.0, float(i));
        }
        
        p.z /= scale;
        p.xy = inS;
        scale *= 0.3;
        
    }
    
    // base primitive is a cylinder
    float de = length(inS) - 1.5*scale;
    
    // compare the distance to the sky
    if (sky < de) {
        id = -1.0;
        return sky;
    }
    
    return de;
    
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    
    vec2 uv = (fragCoord.xy - iResolution.xy*0.5) / iResolution.x;
    vec3 from = vec3(0, -4.3, 0);
    vec3 dir = normalize(vec3(uv.x, 1.0 / tan(FOV*0.5), uv.y));
    
    
    vec2 mouse= (iMouse.xy - iResolution.xy * 0.5) / iResolution.x;
    if (iMouse.z < 1.0) mouse = vec2(0.0);
    mat2 rotx = rot(-mouse.x*4.0);
    mat2 roty = rot(mouse.y*3.0);
    from.yz *= roty;
    from.xy *= rotx;
    dir.yz  *= roty;
    dir.xy  *= rotx;
    from.z += iTime;
    
    // dithering
    vec3 dither = hash33(vec3(fragCoord.xy, iFrame));
    
    // get the sine of the angular extent of a pixel
    float sinPix = sin(FOV / iResolution.x);
    // accumulate color front to back
    vec4 acc = vec4(0, 0, 0, 1);
    
    float id = 0.0;
    float totdist = 0.0;
    totdist += dither.r*de(from, id)*0.4;
    
    for (int i = 0 ; i < 200 ; i++) {
        vec3 p = from + totdist * dir;
        float dist = de(p, id);
        
        // compute color
        vec3 color = vec3(sin(id)*0.3+0.7);
        if (id < -0.5) color = vec3(0.2);
        else if (id < 0.5) color = vec3(0.6, 0.1, 0.1);
        color *= pow(1.0 - float(i)/200.0, 6.0);
        
        // cone trace the surface
        float prox = dist / (totdist*sinPix);
        float alpha = clamp(prox * -0.5 + 0.5, 0.0, 1.0);
        
        if (alpha > 0.01) {
            // accumulate color
            acc.rgb += acc.a * (alpha*color.rgb);
            acc.a *= (1.0 - alpha);
        }
        
        // hit a surface, stop
        if (acc.a < 0.01) {
            break;
        }
        
        // continue forward
        totdist += abs(dist*0.4);
    }
    
    fragColor.rgb = acc.rgb + (dither - 0.5)*0.01;
    fragColor.a = 1.0;
}
