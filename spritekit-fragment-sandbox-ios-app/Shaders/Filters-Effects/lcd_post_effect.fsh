void main(void) {
    // Get pos relative to 0-1 screen space
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;;
    // Flip image along y axis
    uv = vec2(uv.x, 1.0 - uv.y);
    
    // Map texture to 0-1 space
    vec4 texColor = texture2D(u_texture0,uv);
    
    // Default lcd colour (affects brightness)
    float pb = 0.4;
    vec4 lcdColor = vec4(pb,pb,pb,1.0);
    
    // Change every 1st, 2nd, and 3rd vertical strip to RGB respectively
    int px = int(mod(gl_FragCoord.x,3.0));
    if (px == 1) lcdColor.r = 1.0;
    else if (px == 2) lcdColor.g = 1.0;
    else lcdColor.b = 1.0;
    
    // Darken every 3rd horizontal strip for scanline
    float sclV = 0.25;
    if (int(mod(gl_FragCoord.y,3.0)) == 0) lcdColor.rgb = vec3(sclV,sclV,sclV);
    
    
    gl_FragColor = texColor*lcdColor;
}
