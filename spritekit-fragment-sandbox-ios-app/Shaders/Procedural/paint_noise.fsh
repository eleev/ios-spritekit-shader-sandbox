void main() {
    vec3 p = vec3((gl_FragCoord.xy) / (resolution.y), finger.x);
    
    for (int i = 0; i < 50; i++){
        p.xzy = vec3(1.3, 0.999, 0.7) * (abs((abs(p) / dot(p, p) - vec3(1.0, 1.0, finger.y * 0.5))));
    }
    
    gl_FragColor = vec4(p, 1.0);
}
