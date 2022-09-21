precision highp float;

varying lowp vec2 vTextCoor;
varying lowp vec4 varyColor;
uniform sampler2D colorMap;

void main()
{
    //gl_FragColor = varyColor;
    //gl_FragColor = texture2D(colorMap, vTextCoor);
    
    vec4 weakMask = texture2D(colorMap, vTextCoor);
    vec4 mask = varyColor;
    float alpha = 0.3;
    
    vec4 tempColor = mask * (1.0 - alpha) + weakMask * alpha;
    gl_FragColor = tempColor;
}
