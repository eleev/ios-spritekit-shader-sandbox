#define tri(t, scale, shift) ( abs(t * 2. - 1.) - shift ) * (scale)

float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

void main(void)
{
    vec2 R = u_resolution.xy,
    uv = ( gl_FragCoord.xy - .5 * R ) / R.y + .5;
    
    // flip the image along y axis
    uv = vec2(uv.x, 1.0 - uv.y);
    
    // sun
    float dist = length(uv-vec2(0.5,0.5));
    float divisions = 6.0;
    float divisionsShift= 0.5;
    
    float pattern = tri(fract(( uv.y + 0.5)* 20.0), 2.0/  divisions, divisionsShift)- (-uv.y + 0.26) * 0.85;
    float sunOutline = smoothstep( 0.0,-0.015, max( dist - 0.315, -pattern)) ;
    
    vec3 c = sunOutline * mix(vec3( 4.0, 0.0, 0.2), vec3(1.0, 1.1, 0.0), uv.y);
    
    // glow
    float glow = max(0.0, 1.0 - dist * 1.25);
    glow = min(glow * glow * glow, 0.325);
    c += glow * vec3(1.5, 0.3, (sin(u_time)+ 1.0)) * 1.1;
    
    
    vec2 ground;
    
    vec2 planeuv = uv;
    
    planeuv.x =  (planeuv.x - 0.5) * (-planeuv.y) + 0.5;
    //    planeuv.y *= planeuv.y;
    
    planeuv.y += (u_time  ) * 0.13;
    ground.x = tri(fract(( planeuv.x + 0.5)* 10.0), 1.0/10.0, 0.0);
    ground.y = tri(fract(( planeuv.y + 0.5)* 10.0), 1.0/10.0, 0.0);
    
    float groud_lines = smin(ground.x,ground.y, 0.015);
    float ground_glow = smin(ground.x,ground.y, 0.06);
    
    float ground_line_color =  smoothstep( 0.01,-0.01, groud_lines);
    float ground_color =  smoothstep( 0.08,-0.0, ground_glow);
    c = vec3(1.5,2,1) * ground_line_color + vec3(0.1,0.2,0.4) *ground_color;
    gl_FragColor = vec4(c,1.0);
}
