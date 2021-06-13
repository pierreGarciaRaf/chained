shader_type canvas_item;
const float pi = 3.14159;

uniform sampler2D noise: hint_white;
uniform float tenseFactor : hint_range(0.2,1);

/*
	h : given in radians.
	s : from 0 to 1.
	v : from 0 to 1.
*/
vec3 hsvToRgb(vec3 hsv){/* disgusting (and not understood) but from wikipedia :
						https://fr.wikipedia.org/wiki/Teinte_Saturation_Valeur */
    float s = hsv.y;
    float v = hsv.z;
    
    
    vec3 rgb;
    hsv.x *= 180.f/pi;
    hsv.x = mod(hsv.x,360.f);
    int state = int(hsv.x/60.f)%6;
    float f = hsv.x/60.f - float(state);
    
    float l = (1.f - s);
    float m = (1.f - s * f);
    float n = (1.f - (1.f-f) * s);
	vec3 c = 	vec3(1,n,l) * float(state == 0)+
	            vec3(m,1,l) * float(state == 1)+
	            vec3(l,1,n) * float(state == 2)+
	            vec3(l,m,1) * float(state == 3)+
	            vec3(n,l,1) * float(state == 4)+
	            vec3(1,l,m) * float(state == 5);
    return v * c;
}
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}


vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment(){
	vec2 stretchedUV = UV;
	stretchedUV.y = clamp(+.5 + (stretchedUV.y -.5) / tenseFactor, 0.0, 1.0);
	stretchedUV.y += (1.0-tenseFactor)*.5 * texture(noise,stretchedUV + (1.2-tenseFactor) * TIME).y;
	vec4 c = texture(TEXTURE, stretchedUV);
	vec3 hsv = rgb2hsv(vec3(c.x,c.y,c.z));
	hsv.z = (hsv.z / tenseFactor);
	float evenness = float((1+int(10.0*(1.0 - tenseFactor )*TIME))%2);
// 3.0 69.0 98.0
	hsv =  evenness * hsv + (1.0-evenness) * (round(1.0 - tenseFactor ) * vec3(3.0, 200.0, 200.0)/255.0 + round(tenseFactor) * hsv);
	
	
	vec3 newC = hsv2rgb(hsv);
	COLOR = vec4(newC.r,newC.g,newC.b,c.a);
}