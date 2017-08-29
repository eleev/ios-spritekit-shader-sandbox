
float hash(vec2 p) {
    vec3 p2 = vec3(p.xy, 1.0);
    return fract(sin(dot(p2, vec3(40., 60., 80.))) * 10000.);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f *= f * (3.0 - 2.0 * f);
    
    return mix(mix(hash(i + vec2(0.,0.)), hash(i + vec2(1., 0.)), f.x),
               mix(hash(i + vec2(0.,1.)), hash(i + vec2(1., 1.)), f.x),
               f.y);
}

float fbm(vec2 p) {
    float v = -0.25;
    v += noise(p * 1.0) * .5;
    v += noise(p * 2.) * .25;
    v += noise(p * 4.) * .125;
    return v * 1.0;
}

void main(void) {
    
    vec2 uv = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
    
    float lim = 3.;
    
    vec3 finalColor = vec3( 0.0 );
    
    for(int i = 1; i > 0; ++i ) {
        // Limiting the number of iterations that draws a fixed number of lighning paths per lightning
        if(i > int(lim)) break;
        float val = float(i);
        
        float pct = val / lim;
        
        // Lighning paths drawing
        float t = abs(pct * pct / ((uv.x - sin(u_time * 2. - uv.y) / 2.  + fbm( uv + (-u_time * 20.) / val)) * (lim * 15.0)));
        float u = abs(pct * pct / ((uv.x - sin(-u_time * 2. - uv.y) / 2.  + fbm( uv + (u_time * 20.) / val)) * (lim * 15.0)));
        float v = abs(pct * pct / ((uv.x - cos(u_time * 2. - uv.x) / 2.  + fbm( uv + (u_time * 20.) / val)) * (lim * 15.0)));

        // Coloring the lighning paths
        finalColor +=  t * vec3(pct + .75, 1., 1.0);
        finalColor +=  u * vec3(1., pct + .75, 1.0);
        finalColor +=  v * vec3(1., 1., pct + .75);
    }
    
    gl_FragColor = vec4(finalColor, 1.0 );
}
