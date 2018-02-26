void main(void) {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    uv = vec2(uv.x, 1.0 - uv.y);
    
    // per row offset
    float f  = sin( uv.y * 320.0 * 3.14 );
    // scale to per pixel
    float o  = f * (0.35 / 320.0);
    // scale for subtle effect
    float s  = f * .03 + 0.97;
    // scan line fading
    float l  = sin( u_time * 32. )*.03 + 0.97;
    // sample in 3 colour offset
    float r = texture2D( u_texture0, vec2( uv.x+o, uv.y+o ) ).x;
    float g = texture2D( u_texture0, vec2( uv.x-o, uv.y+o ) ).y;
    float b = texture2D( u_texture0, vec2( uv.x  , uv.y-o ) ).z;
    // combine as
    gl_FragColor = vec4( r*0.7, g, b*0.9, l)*l*s;
}

