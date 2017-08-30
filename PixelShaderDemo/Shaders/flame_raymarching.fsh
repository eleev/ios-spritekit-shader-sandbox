

float hash(vec2 p) {
    vec3 p2 = vec3(p.xy, 1.0);
    return fract(sin(dot(p2, vec3(40., 60., 80.))) * 10000.);
}

float noise2d(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f *= f * (3.0 - 2.0 * f);
    
    return mix(mix(hash(i + vec2(0.,0.)), hash(i + vec2(1., 0.)), f.x),
               mix(hash(i + vec2(0.,1.)), hash(i + vec2(1., 1.)), f.x),
               f.y);
}

float noise(vec3 p) {
    vec3 i = floor(p);
    vec4 a = dot(i, vec3(1., 57., 21.)) + vec4(0., 57., 21., 78.);
    vec3 f = cos((p - i) * acos(-1.)) * (-.5) + .5;
    a = mix(sin(cos(a) * a), sin(cos(1.+a) * (1. + a)), f.x);
    a.xy = mix(a.xz, a.yw, f.y);
    return mix(a.x, a.y, f.z);
}

float sphere(vec3 p, vec4 spr) {
    return length(spr.xyz - p) - spr.w;
}

float flame(vec3 p, float time) {
    float d = sphere(p * vec3(1.,.5, 1.), vec4(.0,-1., .0,1.));
    //    return d + (noise(p + vec3(.0, time * 2., .0)) + noise(p * 3.) * .5) * .25 * (p.y);
    return d + (noise2d(p.xy + vec2(.0, time * 2.)) + noise2d(p.xy * 3.) * .5) * .25 * (p.y);
    
}

float scene(vec3 p, float time) {
    return min(100.-length(p) , abs(flame(p, time)) );
}

vec4 raymarch(float num, vec3 org, vec3 dir, float time) {
    float d = 0.0, glow = 0.0, eps = 0.02;
    vec3  p = org;
    bool glowed = false;
    
    for(int i=0; i < num; i++) {
        d = scene(p, time) + eps;
        p += d * dir;
        
        if( d > eps ) {
            if(flame(p, time) < .0)
                glowed = true;
            if(glowed)
                glow = float(i) / num;
        }
    }
    return vec4(p, glow);
}

void main(void) {
    vec2 v = -1.0 + 3.0 * gl_FragCoord.xy / resolution.xy;
    v.x *= resolution.x / resolution.y;
    
    vec3 org = vec3(0., -4.5, 5.0);
    vec3 dir = normalize(vec3(v.x * 1.6, v.y, -1.5));
    
    float time = u_time;
    
    vec4 p = raymarch(iterations, org, dir, time);
    float glow = p.w;
    
    vec4 col = mix(vec4(1., .5, .1, 1.), vec4(0.1, .5, 1., 1.), p.y * .02 + .4);
    
    gl_FragColor = mix(vec4(0.), col, pow(glow * 2.,4.));
}


