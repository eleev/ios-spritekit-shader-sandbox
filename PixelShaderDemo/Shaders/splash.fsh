#define value 299.
#define pattern sin(1.+fract(.7971*floor(value/2.)))
#define extent 7.2

float magicBox(vec3 p) {
    vec3 uvw = p;
    p = 1. - abs(1. - mod(uvw, 2.));
    float lL = length(p), nL = lL, tot = 0., c = pattern;
    
    for (int i=0; i < 13; i++) {
        p = abs(p)/(lL*lL) - c;
        nL = length(p);
        tot += abs(nL-lL);
        lL = nL;
    }
    
    return tot;
}

void main(void) {;
    vec2 s = resolution.xy;
    vec2 uv = (gl_FragCoord.xy - resolution.xy / 2.) / resolution.y * 8.;
    
    float a = 0.;
    if (uv.x >= 0.) a = atan(uv.x, uv.y) * .275;
    if (uv.x < 0.) a =  3.14159 - atan(-uv.x, -uv.y) * 1.66;
    
    float t = mod(value, 2.);
    t = exp(t*50.-10.);
    if (t>extent) t = extent;
    
    float fc = magicBox(vec3(uv,a)) + 1.;
    fc = 1.-smoothstep(fc, fc + 0.001, t/dot(uv,uv));
    
    vec3 tex = texture2D(image, gl_FragCoord.xy / s).rgb;
    vec3 splash = vec3(1.-fc)*vec3(.42, .02, .03);
    
    vec3 mixed = mix(tex, splash, (splash.r == 0.? 0. : 1.));
    gl_FragColor = vec4(mixed, 1.0);
}
