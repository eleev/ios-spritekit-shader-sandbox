#define extent 3.5

float pattern(vec4 date) {
    return sin(1.+fract(.7971*floor(date.w/2.)));
}

float magicBox(vec3 p, vec4 date, float iterations) {
    vec3 uvw = p;
    p = 1. - abs(1. - mod(uvw, 2.));
    float lL = length(p), nL = lL, tot = 0., c = pattern(date);
    
    for (int i=0; i < iterations; i++) {
        p = abs(p)/(lL*lL) - c;
        nL = length(p);
        tot += abs(nL-lL);
        lL = nL;
    }
    
    return tot;
}

void main(void) {;
    vec2 s = u_resolution.xy;
    vec2 uv = (gl_FragCoord.xy - u_resolution.xy / 2.5) / u_resolution.y * 7.;
    
    float a = 0.;
    // Used to differentiate splash sides with respect to x axes
//    if (uv.x >= 0.) a = atan(uv.x, uv.y) * 1.275;
//    if (uv.x < 0.) a =  3.14159 - atan(-uv.x, -uv.y) * 1.66;
//    a =  3.14159 - atan(-uv.x, -uv.y) * 5.66;

    if (uv.x >= 0.) a = atan(uv.x, uv.y) * u_left_distribution;
    if (uv.x < 0.)  a =  3.14159 - atan(uv.x, uv.y) * u_right_distribution;
    
    float date = u_date.w;
    float t = date;
    
    t = exp(t * 50. - 10.);
    if (t>extent) t = extent;
    
    float fc = magicBox(vec3(uv,a), date, u_iterations) + 1.;
    fc = 1. - smoothstep(fc, fc + 0.001, t / dot(uv,uv));
    
    vec3 tex = texture2D(u_image, gl_FragCoord.xy / s).rgb;
    vec3 splash = vec3(1.-fc) * vec3(.42, .05, .08);
    
    vec3 mixed = mix(tex, splash, (splash.r == 0.? 0. : 1.));
    gl_FragColor = vec4(mixed, 1.0);
}
