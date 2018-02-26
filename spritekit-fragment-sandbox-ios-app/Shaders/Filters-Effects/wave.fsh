void main(void) {
    
    vec2 uv = gl_FragCoord.xy / size.xy;
    
    uv.y += (cos((uv.y + (u_time * 0.04)) * 45.0) * 0.0019) +
    (cos((uv.y + (u_time * 0.1)) * 10.0) * 0.002);
    
    uv.x += (sin((uv.y + (u_time * 0.07)) * 15.0) * 0.0029) +
    (sin((uv.y + (u_time * 0.1)) * 15.0) * 0.002);
    
    gl_FragColor = texture2D(customTexture, uv);
}
