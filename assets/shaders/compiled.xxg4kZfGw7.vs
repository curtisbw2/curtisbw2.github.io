{@}AntimatterPass.vs{@}varying vec2 vUv;

void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}{@}AntimatterPosition.vs{@}uniform sampler2D tPos;
uniform float uDPR;

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = (0.02 * uDPR) * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}{@}AntimatterBasicFrag.fs{@}void main() {
    gl_FragColor = vec4(1.0);
}{@}antimatter.glsl{@}vec3 getData(sampler2D tex, vec2 uv) {
    return texture2D(tex, uv).xyz;
}

vec4 getData4(sampler2D tex, vec2 uv) {
    return texture2D(tex, uv);
}

{@}blendmodes.glsl{@}float blendColorDodge(float base, float blend) {
    return (blend == 1.0)?blend:min(base/(1.0-blend), 1.0);
}
vec3 blendColorDodge(vec3 base, vec3 blend) {
    return vec3(blendColorDodge(base.r, blend.r), blendColorDodge(base.g, blend.g), blendColorDodge(base.b, blend.b));
}
vec3 blendColorDodge(vec3 base, vec3 blend, float opacity) {
    return (blendColorDodge(base, blend) * opacity + base * (1.0 - opacity));
}
float blendColorBurn(float base, float blend) {
    return (blend == 0.0)?blend:max((1.0-((1.0-base)/blend)), 0.0);
}
vec3 blendColorBurn(vec3 base, vec3 blend) {
    return vec3(blendColorBurn(base.r, blend.r), blendColorBurn(base.g, blend.g), blendColorBurn(base.b, blend.b));
}
vec3 blendColorBurn(vec3 base, vec3 blend, float opacity) {
    return (blendColorBurn(base, blend) * opacity + base * (1.0 - opacity));
}
float blendVividLight(float base, float blend) {
    return (blend<0.5)?blendColorBurn(base, (2.0*blend)):blendColorDodge(base, (2.0*(blend-0.5)));
}
vec3 blendVividLight(vec3 base, vec3 blend) {
    return vec3(blendVividLight(base.r, blend.r), blendVividLight(base.g, blend.g), blendVividLight(base.b, blend.b));
}
vec3 blendVividLight(vec3 base, vec3 blend, float opacity) {
    return (blendVividLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendHardMix(float base, float blend) {
    return (blendVividLight(base, blend)<0.5)?0.0:1.0;
}
vec3 blendHardMix(vec3 base, vec3 blend) {
    return vec3(blendHardMix(base.r, blend.r), blendHardMix(base.g, blend.g), blendHardMix(base.b, blend.b));
}
vec3 blendHardMix(vec3 base, vec3 blend, float opacity) {
    return (blendHardMix(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearDodge(float base, float blend) {
    return min(base+blend, 1.0);
}
vec3 blendLinearDodge(vec3 base, vec3 blend) {
    return min(base+blend, vec3(1.0));
}
vec3 blendLinearDodge(vec3 base, vec3 blend, float opacity) {
    return (blendLinearDodge(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearBurn(float base, float blend) {
    return max(base+blend-1.0, 0.0);
}
vec3 blendLinearBurn(vec3 base, vec3 blend) {
    return max(base+blend-vec3(1.0), vec3(0.0));
}
vec3 blendLinearBurn(vec3 base, vec3 blend, float opacity) {
    return (blendLinearBurn(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLinearLight(float base, float blend) {
    return blend<0.5?blendLinearBurn(base, (2.0*blend)):blendLinearDodge(base, (2.0*(blend-0.5)));
}
vec3 blendLinearLight(vec3 base, vec3 blend) {
    return vec3(blendLinearLight(base.r, blend.r), blendLinearLight(base.g, blend.g), blendLinearLight(base.b, blend.b));
}
vec3 blendLinearLight(vec3 base, vec3 blend, float opacity) {
    return (blendLinearLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendLighten(float base, float blend) {
    return max(blend, base);
}
vec3 blendLighten(vec3 base, vec3 blend) {
    return vec3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
}
vec3 blendLighten(vec3 base, vec3 blend, float opacity) {
    return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
}
float blendDarken(float base, float blend) {
    return min(blend, base);
}
vec3 blendDarken(vec3 base, vec3 blend) {
    return vec3(blendDarken(base.r, blend.r), blendDarken(base.g, blend.g), blendDarken(base.b, blend.b));
}
vec3 blendDarken(vec3 base, vec3 blend, float opacity) {
    return (blendDarken(base, blend) * opacity + base * (1.0 - opacity));
}
float blendPinLight(float base, float blend) {
    return (blend<0.5)?blendDarken(base, (2.0*blend)):blendLighten(base, (2.0*(blend-0.5)));
}
vec3 blendPinLight(vec3 base, vec3 blend) {
    return vec3(blendPinLight(base.r, blend.r), blendPinLight(base.g, blend.g), blendPinLight(base.b, blend.b));
}
vec3 blendPinLight(vec3 base, vec3 blend, float opacity) {
    return (blendPinLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendReflect(float base, float blend) {
    return (blend == 1.0)?blend:min(base*base/(1.0-blend), 1.0);
}
vec3 blendReflect(vec3 base, vec3 blend) {
    return vec3(blendReflect(base.r, blend.r), blendReflect(base.g, blend.g), blendReflect(base.b, blend.b));
}
vec3 blendReflect(vec3 base, vec3 blend, float opacity) {
    return (blendReflect(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendGlow(vec3 base, vec3 blend) {
    return blendReflect(blend, base);
}
vec3 blendGlow(vec3 base, vec3 blend, float opacity) {
    return (blendGlow(base, blend) * opacity + base * (1.0 - opacity));
}
float blendOverlay(float base, float blend) {
    return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
}
vec3 blendOverlay(vec3 base, vec3 blend) {
    return vec3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
}
vec3 blendOverlay(vec3 base, vec3 blend, float opacity) {
    return (blendOverlay(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendHardLight(vec3 base, vec3 blend) {
    return blendOverlay(blend, base);
}
vec3 blendHardLight(vec3 base, vec3 blend, float opacity) {
    return (blendHardLight(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendPhoenix(vec3 base, vec3 blend) {
    return min(base, blend)-max(base, blend)+vec3(1.0);
}
vec3 blendPhoenix(vec3 base, vec3 blend, float opacity) {
    return (blendPhoenix(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendNormal(vec3 base, vec3 blend) {
    return blend;
}
vec3 blendNormal(vec3 base, vec3 blend, float opacity) {
    return (blendNormal(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendNegation(vec3 base, vec3 blend) {
    return vec3(1.0)-abs(vec3(1.0)-base-blend);
}
vec3 blendNegation(vec3 base, vec3 blend, float opacity) {
    return (blendNegation(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendMultiply(vec3 base, vec3 blend) {
    return base*blend;
}
vec3 blendMultiply(vec3 base, vec3 blend, float opacity) {
    return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendAverage(vec3 base, vec3 blend) {
    return (base+blend)/2.0;
}
vec3 blendAverage(vec3 base, vec3 blend, float opacity) {
    return (blendAverage(base, blend) * opacity + base * (1.0 - opacity));
}
float blendScreen(float base, float blend) {
    return 1.0-((1.0-base)*(1.0-blend));
}
vec3 blendScreen(vec3 base, vec3 blend) {
    return vec3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
}
vec3 blendScreen(vec3 base, vec3 blend, float opacity) {
    return (blendScreen(base, blend) * opacity + base * (1.0 - opacity));
}
float blendSoftLight(float base, float blend) {
    return (blend<0.5)?(2.0*base*blend+base*base*(1.0-2.0*blend)):(sqrt(base)*(2.0*blend-1.0)+2.0*base*(1.0-blend));
}
vec3 blendSoftLight(vec3 base, vec3 blend) {
    return vec3(blendSoftLight(base.r, blend.r), blendSoftLight(base.g, blend.g), blendSoftLight(base.b, blend.b));
}
vec3 blendSoftLight(vec3 base, vec3 blend, float opacity) {
    return (blendSoftLight(base, blend) * opacity + base * (1.0 - opacity));
}
float blendSubtract(float base, float blend) {
    return max(base+blend-1.0, 0.0);
}
vec3 blendSubtract(vec3 base, vec3 blend) {
    return max(base+blend-vec3(1.0), vec3(0.0));
}
vec3 blendSubtract(vec3 base, vec3 blend, float opacity) {
    return (blendSubtract(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendExclusion(vec3 base, vec3 blend) {
    return base+blend-2.0*base*blend;
}
vec3 blendExclusion(vec3 base, vec3 blend, float opacity) {
    return (blendExclusion(base, blend) * opacity + base * (1.0 - opacity));
}
vec3 blendDifference(vec3 base, vec3 blend) {
    return abs(base-blend);
}
vec3 blendDifference(vec3 base, vec3 blend, float opacity) {
    return (blendDifference(base, blend) * opacity + base * (1.0 - opacity));
}
float blendAdd(float base, float blend) {
    return min(base+blend, 1.0);
}
vec3 blendAdd(vec3 base, vec3 blend) {
    return min(base+blend, vec3(1.0));
}
vec3 blendAdd(vec3 base, vec3 blend, float opacity) {
    return (blendAdd(base, blend) * opacity + base * (1.0 - opacity));
}{@}contrast.glsl{@}vec3 adjustContrast(vec3 color, float c, float m) {
	float t = 0.5 - c * 0.5;
	color.rgb = color.rgb * c + t;
	return color * m;
}{@}curl.glsl{@}#test Device.mobile
float sinf2(float x) {
    x*=0.159155;
    x-=floor(x);
    float xx=x*x;
    float y=-6.87897;
    y=y*xx+33.7755;
    y=y*xx-72.5257;
    y=y*xx+80.5874;
    y=y*xx-41.2408;
    y=y*xx+6.28077;
    return x*y;
}

float cosf2(float x) {
    return sinf2(x+1.5708);
}
#endtest

#test !Device.mobile
    #define sinf2 sin
    #define cosf2 cos
#endtest

float potential1(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.x * 1.8 + v.z * 3.) + sinf2(v.x * 4.8 + v.z * 4.5) + sinf2(v.x * -7.0 + v.z * 1.2) + sinf2(v.x * -5.0 + v.z * 2.13);
    noise += sinf2(v.y * -0.48 + v.z * 5.4) + sinf2(v.y * 2.56 + v.z * 5.4) + sinf2(v.y * 4.16 + v.z * 2.4) + sinf2(v.y * -4.16 + v.z * 1.35);
    return noise;
}

float potential2(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.y * 1.8 + v.x * 3. - 2.82) + sinf2(v.y * 4.8 + v.x * 4.5 + 74.37) + sinf2(v.y * -7.0 + v.x * 1.2 - 256.72) + sinf2(v.y * -5.0 + v.x * 2.13 - 207.683);
    noise += sinf2(v.z * -0.48 + v.x * 5.4 -125.796) + sinf2(v.z * 2.56 + v.x * 5.4 + 17.692) + sinf2(v.z * 4.16 + v.x * 2.4 + 150.512) + sinf2(v.z * -4.16 + v.x * 1.35 - 222.137);
    return noise;
}

float potential3(vec3 v) {
    float noise = 0.0;
    noise += sinf2(v.z * 1.8 + v.y * 3. - 194.58) + sinf2(v.z * 4.8 + v.y * 4.5 - 83.13) + sinf2(v.z * -7.0 + v.y * 1.2 -845.2) + sinf2(v.z * -5.0 + v.y * 2.13 - 762.185);
    noise += sinf2(v.x * -0.48 + v.y * 5.4 - 707.916) + sinf2(v.x * 2.56 + v.y * 5.4 + -482.348) + sinf2(v.x * 4.16 + v.y * 2.4 + 9.872) + sinf2(v.x * -4.16 + v.y * 1.35 - 476.747);
    return noise;
}

vec3 snoiseVec3( vec3 x ) {
    float s  = potential1(x);
    float s1 = potential2(x);
    float s2 = potential3(x);
    return vec3( s , s1 , s2 );
}

//Analitic derivatives of the potentials for the curl noise, based on: http://weber.itn.liu.se/~stegu/TNM084-2019/bridson-siggraph2007-curlnoise.pdf

float dP3dY(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.z * 1.8 + v.y * 3. - 194.58) + 4.5 * cosf2(v.z * 4.8 + v.y * 4.5 - 83.13) + 1.2 * cosf2(v.z * -7.0 + v.y * 1.2 -845.2) + 2.13 * cosf2(v.z * -5.0 + v.y * 2.13 - 762.185);
    noise += 5.4 * cosf2(v.x * -0.48 + v.y * 5.4 - 707.916) + 5.4 * cosf2(v.x * 2.56 + v.y * 5.4 + -482.348) + 2.4 * cosf2(v.x * 4.16 + v.y * 2.4 + 9.872) + 1.35 * cosf2(v.x * -4.16 + v.y * 1.35 - 476.747);
    return noise;
}

float dP2dZ(vec3 v) {
    return -0.48 * cosf2(v.z * -0.48 + v.x * 5.4 -125.796) + 2.56 * cosf2(v.z * 2.56 + v.x * 5.4 + 17.692) + 4.16 * cosf2(v.z * 4.16 + v.x * 2.4 + 150.512) -4.16 * cosf2(v.z * -4.16 + v.x * 1.35 - 222.137);
}

float dP1dZ(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.x * 1.8 + v.z * 3.) + 4.5 * cosf2(v.x * 4.8 + v.z * 4.5) + 1.2 * cosf2(v.x * -7.0 + v.z * 1.2) + 2.13 * cosf2(v.x * -5.0 + v.z * 2.13);
    noise += 5.4 * cosf2(v.y * -0.48 + v.z * 5.4) + 5.4 * cosf2(v.y * 2.56 + v.z * 5.4) + 2.4 * cosf2(v.y * 4.16 + v.z * 2.4) + 1.35 * cosf2(v.y * -4.16 + v.z * 1.35);
    return noise;
}

float dP3dX(vec3 v) {
    return -0.48 * cosf2(v.x * -0.48 + v.y * 5.4 - 707.916) + 2.56 * cosf2(v.x * 2.56 + v.y * 5.4 + -482.348) + 4.16 * cosf2(v.x * 4.16 + v.y * 2.4 + 9.872) -4.16 * cosf2(v.x * -4.16 + v.y * 1.35 - 476.747);
}

float dP2dX(vec3 v) {
    float noise = 0.0;
    noise += 3. * cosf2(v.y * 1.8 + v.x * 3. - 2.82) + 4.5 * cosf2(v.y * 4.8 + v.x * 4.5 + 74.37) + 1.2 * cosf2(v.y * -7.0 + v.x * 1.2 - 256.72) + 2.13 * cosf2(v.y * -5.0 + v.x * 2.13 - 207.683);
    noise += 5.4 * cosf2(v.z * -0.48 + v.x * 5.4 -125.796) + 5.4 * cosf2(v.z * 2.56 + v.x * 5.4 + 17.692) + 2.4 * cosf2(v.z * 4.16 + v.x * 2.4 + 150.512) + 1.35 * cosf2(v.z * -4.16 + v.x * 1.35 - 222.137);
    return noise;
}

float dP1dY(vec3 v) {
    return -0.48 * cosf2(v.y * -0.48 + v.z * 5.4) + 2.56 * cosf2(v.y * 2.56 + v.z * 5.4) +  4.16 * cosf2(v.y * 4.16 + v.z * 2.4) -4.16 * cosf2(v.y * -4.16 + v.z * 1.35);
}


vec3 curlNoise( vec3 p ) {

    //A sinf2 or cosf2 call is a trigonometric function, these functions are expensive in the GPU
    //the partial derivatives with approximations require to calculate the snoiseVec3 function 4 times.
    //The previous function evaluate the potentials that include 8 trigonometric functions each.
    //
    //This means that the potentials are evaluated 12 times (4 calls to snoiseVec3 that make 3 potential calls).
    //The whole process call 12 * 8 trigonometric functions, a total of 96 times.


    /*
    const float e = 1e-1;
    vec3 dx = vec3( e   , 0.0 , 0.0 );
    vec3 dy = vec3( 0.0 , e   , 0.0 );
    vec3 dz = vec3( 0.0 , 0.0 , e   );
    vec3 p0 = snoiseVec3(p);
    vec3 p_x1 = snoiseVec3( p + dx );
    vec3 p_y1 = snoiseVec3( p + dy );
    vec3 p_z1 = snoiseVec3( p + dz );
    float x = p_y1.z - p0.z - p_z1.y + p0.y;
    float y = p_z1.x - p0.x - p_x1.z + p0.z;
    float z = p_x1.y - p0.y - p_y1.x + p0.x;
    return normalize( vec3( x , y , z ));
    */


    //The noise that is used to define the potentials is based on analitic functions that are easy to derivate,
    //meaning that the analitic solution would provide a much faster approach with the same visual results.
    //
    //Usinf2g the analitic derivatives the algorithm does not require to evaluate snoiseVec3, instead it uses the
    //analitic partial derivatives from each potential on the corresponding axis, providing a total of
    //36 calls to trigonometric functions, making the analytic evaluation almost 3 times faster than the aproximation method.


    float x = dP3dY(p) - dP2dZ(p);
    float y = dP1dZ(p) - dP3dX(p);
    float z = dP2dX(p) - dP1dY(p);


    return normalize( vec3( x , y , z ));



}{@}eases.glsl{@}#ifndef PI
#define PI 3.141592653589793
#endif

#ifndef HALF_PI
#define HALF_PI 1.5707963267948966
#endif

float backInOut(float t) {
  float f = t < 0.5
    ? 2.0 * t
    : 1.0 - (2.0 * t - 1.0);

  float g = pow(f, 3.0) - f * sin(f * PI);

  return t < 0.5
    ? 0.5 * g
    : 0.5 * (1.0 - g) + 0.5;
}

float backIn(float t) {
  return pow(t, 3.0) - t * sin(t * PI);
}

float backOut(float t) {
  float f = 1.0 - t;
  return 1.0 - (pow(f, 3.0) - f * sin(f * PI));
}

float bounceOut(float t) {
  const float a = 4.0 / 11.0;
  const float b = 8.0 / 11.0;
  const float c = 9.0 / 10.0;

  const float ca = 4356.0 / 361.0;
  const float cb = 35442.0 / 1805.0;
  const float cc = 16061.0 / 1805.0;

  float t2 = t * t;

  return t < a
    ? 7.5625 * t2
    : t < b
      ? 9.075 * t2 - 9.9 * t + 3.4
      : t < c
        ? ca * t2 - cb * t + cc
        : 10.8 * t * t - 20.52 * t + 10.72;
}

float bounceIn(float t) {
  return 1.0 - bounceOut(1.0 - t);
}

float bounceInOut(float t) {
  return t < 0.5
    ? 0.5 * (1.0 - bounceOut(1.0 - t * 2.0))
    : 0.5 * bounceOut(t * 2.0 - 1.0) + 0.5;
}

float circularInOut(float t) {
  return t < 0.5
    ? 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t))
    : 0.5 * (sqrt((3.0 - 2.0 * t) * (2.0 * t - 1.0)) + 1.0);
}

float circularIn(float t) {
  return 1.0 - sqrt(1.0 - t * t);
}

float circularOut(float t) {
  return sqrt((2.0 - t) * t);
}

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * -pow(2.0 - 2.0 * t, 3.0) + 1.0;
}

float cubicIn(float t) {
  return t * t * t;
}

float cubicOut(float t) {
  float f = t - 1.0;
  return f * f * f + 1.0;
}

float elasticInOut(float t) {
  return t < 0.5
    ? 0.5 * sin(+13.0 * HALF_PI * 2.0 * t) * pow(2.0, 10.0 * (2.0 * t - 1.0))
    : 0.5 * sin(-13.0 * HALF_PI * ((2.0 * t - 1.0) + 1.0)) * pow(2.0, -10.0 * (2.0 * t - 1.0)) + 1.0;
}

float elasticIn(float t) {
  return sin(13.0 * t * HALF_PI) * pow(2.0, 10.0 * (t - 1.0));
}

float elasticOut(float t) {
  return sin(-13.0 * (t + 1.0) * HALF_PI) * pow(2.0, -10.0 * t) + 1.0;
}

float expoInOut(float t) {
  return t == 0.0 || t == 1.0
    ? t
    : t < 0.5
      ? +0.5 * pow(2.0, (20.0 * t) - 10.0)
      : -0.5 * pow(2.0, 10.0 - (t * 20.0)) + 1.0;
}

float expoIn(float t) {
  return t == 0.0 ? t : pow(2.0, 10.0 * (t - 1.0));
}

float expoOut(float t) {
  return t == 1.0 ? t : 1.0 - pow(2.0, -10.0 * t);
}

float linear(float t) {
  return t;
}

float quadraticInOut(float t) {
  float p = 2.0 * t * t;
  return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
}

float quadraticIn(float t) {
  return t * t;
}

float quadraticOut(float t) {
  return -t * (t - 2.0);
}

float quarticInOut(float t) {
  return t < 0.5
    ? +8.0 * pow(t, 4.0)
    : -8.0 * pow(1.0 - t, 4.0) + 1.0;
}

float quarticIn(float t) {
  return pow(t, 4.0);
}

float quarticOut(float t) {
  return pow(1.0 - t, 3.0) * (t - 1.0) + 1.0;
}

float qinticInOut(float t) {
  return t < 0.5
    ? +16.0 * pow(t, 5.0)
    : -0.5 * pow(2.0 * t - 2.0, 5.0) + 1.0;
}

float qinticIn(float t) {
  return pow(t, 5.0);
}

float qinticOut(float t) {
  return 1.0 - (pow(1.0 - t, 5.0));
}

float sineInOut(float t) {
  return -0.5 * (cos(PI * t) - 1.0);
}

float sineIn(float t) {
  return sin((t - 1.0) * HALF_PI) + 1.0;
}

float sineOut(float t) {
  return sin(t * HALF_PI);
}
{@}ColorMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 color;
uniform float alpha;

#!VARYINGS

#!SHADER: ColorMaterial.vs
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: ColorMaterial.fs
void main() {
    gl_FragColor = vec4(color, alpha);
}{@}ScreenQuad.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;

#!VARYINGS

#!SHADER: ScreenQuad.vs
void main() {
    gl_Position = vec4(position, 1.0);
}

#!SHADER: ScreenQuad.fs
void main() {
    gl_FragColor = texture2D(tMap, gl_FragCoord.xy / resolution);
    gl_FragColor.a = 1.0;
}{@}TestMaterial.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float alpha;

#!VARYINGS
varying vec3 vNormal;

#!SHADER: TestMaterial.vs
void main() {
    vec3 pos = position;
    vNormal = normalMatrix * normal;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: TestMaterial.fs
void main() {
    gl_FragColor = vec4(vNormal, 1.0);
}{@}BlitPass.fs{@}void main() {
    gl_FragColor = texture2D(tDiffuse, vUv);
}
{@}NukePass.vs{@}varying vec2 vUv;

void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}{@}instance.vs{@}vec3 transformNormal(vec3 n, vec4 orientation) {
    vec3 nn = n + 2.0 * cross(orientation.xyz, cross(orientation.xyz, n) + orientation.w * n);
    return nn;
}

vec3 transformPosition(vec3 position, vec3 offset, vec3 scale, vec4 orientation) {
    vec3 _pos = position;
    _pos *= scale;

    _pos = _pos + 2.0 * cross(orientation.xyz, cross(orientation.xyz, _pos) + orientation.w * _pos);
    _pos += offset;
    return _pos;
}

vec3 transformPosition(vec3 position, vec3 offset, vec4 orientation) {
    vec3 _pos = position;

    _pos = _pos + 2.0 * cross(orientation.xyz, cross(orientation.xyz, _pos) + orientation.w * _pos);
    _pos += offset;
    return _pos;
}

vec3 transformPosition(vec3 position, vec3 offset, float scale, vec4 orientation) {
    return transformPosition(position, offset, vec3(scale), orientation);
}

vec3 transformPosition(vec3 position, vec3 offset) {
    return position + offset;
}

vec3 transformPosition(vec3 position, vec3 offset, float scale) {
    vec3 pos = position * scale;
    return pos + offset;
}

vec3 transformPosition(vec3 position, vec3 offset, vec3 scale) {
    vec3 pos = position * scale;
    return pos + offset;
}{@}fresnel.glsl{@}float getFresnel(vec3 normal, vec3 viewDir, float power) {
    float d = dot(normalize(normal), normalize(viewDir));
    return 1.0 - pow(abs(d), power);
}

float getFresnel(float inIOR, float outIOR, vec3 normal, vec3 viewDir) {
    float ro = (inIOR - outIOR) / (inIOR + outIOR);
    float d = dot(normalize(normal), normalize(viewDir));
    return ro + (1. - ro) * pow((1. - d), 5.);
}


//viewDir = -vec3(modelViewMatrix * vec4(position, 1.0));{@}glscreenprojection.glsl{@}vec2 frag_coord(vec4 glPos) {
    return ((glPos.xyz / glPos.w) * 0.5 + 0.5).xy;
}

vec2 getProjection(vec3 pos, mat4 projMatrix) {
    vec4 mvpPos = projMatrix * vec4(pos, 1.0);
    return frag_coord(mvpPos);
}

void applyNormal(inout vec3 pos, mat4 projNormalMatrix) {
    vec3 transformed = vec3(projNormalMatrix * vec4(pos, 0.0));
    pos = transformed;
}{@}DefaultText.glsl{@}#!ATTRIBUTES

#!UNIFORMS

uniform sampler2D tMap;
uniform vec3 uColor;
uniform float uAlpha;

#!VARYINGS

varying vec2 vUv;

#!SHADER: DefaultText.vs

void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

#!SHADER: DefaultText.fs

#require(msdf.glsl)

void main() {
    float alpha = msdf(tMap, vUv);

    gl_FragColor.rgb = uColor;
    gl_FragColor.a = alpha * uAlpha;
}
{@}msdf.glsl{@}float msdf(vec3 tex, vec2 uv, bool discards) {
    // TODO: fallback for fwidth for webgl1 (need to enable ext)
    float signedDist = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float d = fwidth(signedDist);
    float alpha = smoothstep(-d, d, signedDist);
    if (alpha < 0.01 && discards) discard;
    return alpha;
}

float msdf(sampler2D tMap, vec2 uv, bool discards) {
    vec3 tex = texture2D(tMap, uv).rgb;
    return msdf( tex, uv, discards );
}

float msdf(vec3 tex, vec2 uv) {
    return msdf( tex, uv, true );
}

float msdf(sampler2D tMap, vec2 uv) {
    vec3 tex = texture2D(tMap, uv).rgb;
    return msdf( tex, uv );
}

float strokemsdf(sampler2D tMap, vec2 uv, float stroke, float padding) {
    vec3 tex = texture2D(tMap, uv).rgb;
    float signedDist = max(min(tex.r, tex.g), min(max(tex.r, tex.g), tex.b)) - 0.5;
    float t = stroke;
    float alpha = smoothstep(-t, -t + padding, signedDist) * smoothstep(t, t - padding, signedDist);
    return alpha;
}
{@}radialblur.fs{@}vec3 radialBlur( sampler2D map, vec2 uv, float size, vec2 resolution, float quality ) {
    vec3 color = vec3(0.);

    const float pi2 = 3.141596 * 2.0;
    const float direction = 8.0;

    vec2 radius = size / resolution;
    float test = 1.0;

    for ( float d = 0.0; d < pi2 ; d += pi2 / direction ) {
        vec2 t = radius * vec2( cos(d), sin(d));
        for ( float i = 1.0; i <= 100.0; i += 1.0 ) {
            if (i >= quality) break;
            color += texture2D( map, uv + t * i / quality ).rgb ;
        }
    }

    return color / ( quality * direction);
}

vec3 radialBlur( sampler2D map, vec2 uv, float size, float quality ) {
    vec3 color = vec3(0.);

    const float pi2 = 3.141596 * 2.0;
    const float direction = 8.0;

    vec2 radius = size / vec2(1024.0);
    float test = 1.0;
    float samples = 0.0;

    for ( float d = 0.0; d < pi2 ; d += pi2 / direction ) {
        vec2 t = radius * vec2( cos(d), sin(d));
        for ( float i = 1.0; i <= 100.0; i += 1.0 ) {
            if (i >= quality) break;
            color += texture2D( map, uv + t * i / quality ).rgb ;
            samples += 1.0;
        }
    }

    return color / samples;
}
{@}range.glsl{@}

float range(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    vec3 sub = vec3(oldValue, newMax, oldMax) - vec3(oldMin, newMin, oldMin);
    return sub.x * sub.y / sub.z + newMin;
}

vec2 range(vec2 oldValue, vec2 oldMin, vec2 oldMax, vec2 newMin, vec2 newMax) {
    vec2 oldRange = oldMax - oldMin;
    vec2 newRange = newMax - newMin;
    vec2 val = oldValue - oldMin;
    return val * newRange / oldRange + newMin;
}

vec3 range(vec3 oldValue, vec3 oldMin, vec3 oldMax, vec3 newMin, vec3 newMax) {
    vec3 oldRange = oldMax - oldMin;
    vec3 newRange = newMax - newMin;
    vec3 val = oldValue - oldMin;
    return val * newRange / oldRange + newMin;
}

float crange(float oldValue, float oldMin, float oldMax, float newMin, float newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

vec2 crange(vec2 oldValue, vec2 oldMin, vec2 oldMax, vec2 newMin, vec2 newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

vec3 crange(vec3 oldValue, vec3 oldMin, vec3 oldMax, vec3 newMin, vec3 newMax) {
    return clamp(range(oldValue, oldMin, oldMax, newMin, newMax), min(newMin, newMax), max(newMin, newMax));
}

float rangeTransition(float t, float x, float padding) {
    float transition = crange(t, 0.0, 1.0, -padding, 1.0 + padding);
    return crange(x, transition - padding, transition + padding, 1.0, 0.0);
}
{@}rgb2hsv.fs{@}vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}{@}rgbshift.fs{@}vec4 getRGB(sampler2D tDiffuse, vec2 uv, float angle, float amount) {
    vec2 offset = vec2(cos(angle), sin(angle)) * amount;
    vec4 r = texture2D(tDiffuse, uv + offset);
    vec4 g = texture2D(tDiffuse, uv);
    vec4 b = texture2D(tDiffuse, uv - offset);
    return vec4(r.r, g.g, b.b, g.a);
}{@}simplenoise.glsl{@}float getNoise(vec2 uv, float time) {
    float x = uv.x * uv.y * time * 1000.0;
    x = mod(x, 13.0) * mod(x, 123.0);
    float dx = mod(x, 0.01);
    float amount = clamp(0.1 + dx * 100.0, 0.0, 1.0);
    return amount;
}

#test Device.mobile
float sinf(float x) {
    x*=0.159155;
    x-=floor(x);
    float xx=x*x;
    float y=-6.87897;
    y=y*xx+33.7755;
    y=y*xx-72.5257;
    y=y*xx+80.5874;
    y=y*xx-41.2408;
    y=y*xx+6.28077;
    return x*y;
}
#endtest

#test !Device.mobile
    #define sinf sin
#endtest

highp float getRandom(vec2 co) {
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt = dot(co.xy, vec2(a, b));
    highp float sn = mod(dt, 3.14);
    return fract(sin(sn) * c);
}

float cnoise(vec3 v) {
    float t = v.z * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += (sinf(v.x * 0.9 / s + t * 10.0) + sinf(v.x * 2.4 / s + t * 15.0) + sinf(v.x * -3.5 / s + t * 4.0) + sinf(v.x * -2.5 / s + t * 7.1)) * 0.3;
    noise += (sinf(v.y * -0.3 / s + t * 18.0) + sinf(v.y * 1.6 / s + t * 18.0) + sinf(v.y * 2.6 / s + t * 8.0) + sinf(v.y * -2.6 / s + t * 4.5)) * 0.3;
    return noise;
}

float cnoise(vec2 v) {
    float t = v.x * 0.3;
    v.y *= 0.8;
    float noise = 0.0;
    float s = 0.5;
    noise += (sinf(v.x * 0.9 / s + t * 10.0) + sinf(v.x * 2.4 / s + t * 15.0) + sinf(v.x * -3.5 / s + t * 4.0) + sinf(v.x * -2.5 / s + t * 7.1)) * 0.3;
    noise += (sinf(v.y * -0.3 / s + t * 18.0) + sinf(v.y * 1.6 / s + t * 18.0) + sinf(v.y * 2.6 / s + t * 8.0) + sinf(v.y * -2.6 / s + t * 4.5)) * 0.3;
    return noise;
}

float fbm(vec3 x, int octaves) {
    float v = 0.0;
    float a = 0.5;
    vec3 shift = vec3(100);

    for (int i = 0; i < 10; ++i) {
        if (i >= octaves){ break; }

        v += a * cnoise(x);
        x = x * 2.0 + shift;
        a *= 0.5;
    }

    return v;
}

float fbm(vec2 x, int octaves) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100);
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.50));

    for (int i = 0; i < 10; ++i) {
        if (i >= octaves){ break; }

        v += a * cnoise(x);
        x = rot * x * 2.0 + shift;
        a *= 0.5;
    }

    return v;
}
{@}transformUV.glsl{@}vec2 translateUV(vec2 uv, vec2 translate) {
    return uv - translate;
}

vec2 rotateUV(vec2 uv, float r, vec2 origin) {
    float c = cos(r);
    float s = sin(r);
    mat2 m = mat2(c, -s,
                  s, c);
    vec2 st = uv - origin;
    st = m * st;
    return st + origin;
}

vec2 scaleUV(vec2 uv, vec2 scale, vec2 origin) {
    vec2 st = uv - origin;
    st /= scale;
    return st + origin;
}

vec2 rotateUV(vec2 uv, float r) {
    return rotateUV(uv, r, vec2(0.5));
}

vec2 scaleUV(vec2 uv, vec2 scale) {
    return scaleUV(uv, scale, vec2(0.5));
}

vec2 skewUV(vec2 st, vec2 skew) {
    return st + st.gr * skew;
}

vec2 transformUV(vec2 uv, float a[9]) {

    // Array consists of the following
    // 0 translate.x
    // 1 translate.y
    // 2 skew.x
    // 3 skew.y
    // 4 rotate
    // 5 scale.x
    // 6 scale.y
    // 7 origin.x
    // 8 origin.y

    vec2 st = uv;

    //Translate
    st -= vec2(a[0], a[1]);

    //Skew
    st = st + st.gr * vec2(a[2], a[3]);

    //Rotate
    st = rotateUV(st, a[4], vec2(a[7], a[8]));

    //Scale
    st = scaleUV(st, vec2(a[5], a[6]), vec2(a[7], a[8]));

    return st;
}{@}DomSliceScreenQuad.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uBgColor;
uniform float uVertOffset;
uniform float uVertClip;
uniform float uTransition;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
#require(SliceScreenQuadVertex.vs)
void main() {
    vec3 pos = position;
    vUv = uv;
    applySliceOffset(pos, vUv);

    gl_Position = vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(uBgColor, 1.);
}
{@}SliceScreenQuad.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uVertOffset;
uniform float uVertClip;
uniform float uTransition;
uniform vec4 uScissor;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
#require(SliceScreenQuadVertex.vs)
void main() {
    vec3 pos = position;
    vUv = uv;
    applySliceOffset(pos, vUv, uScissor);

    gl_Position = vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    vec2 uv = vUv;
    gl_FragColor = texture2D(tMap, uv);
    gl_FragColor.a = 1.0;
}
{@}SliceScreenQuadVertex.vs{@}#require(range.glsl)
#require(transformUV.glsl)

void applySliceOffset(inout vec3 pos, inout vec2 uv) {
    // PlaneGeometry is -0.5...0.5, scale to -1...1 to fill viewport
    pos *= 2.0;
    // apply offset in vertex shader so webgl can eliminate unneeded fragments more efficiently
    pos.y *= uVertClip;
    pos.y -= uVertOffset * 2.0;

    // scale around viewport center
    float scale = range(uTransition, 0.0, 1.0, 1.0, 1.15);
    pos.xy -= 0.5;

    // don't shrink, only expand (will scale uvs in the shrink case, but don't want to leave empty space)
    pos.xy *= max(scale, 1.0);
    pos.xy += 0.5;

    uv = scaleUV(uv, vec2(min(scale, 1.0)) / vec2(1.0, uVertClip));
}

void applySliceOffset(inout vec3 pos, inout vec2 uv, vec4 scissor) {
    applySliceOffset(pos, uv);

    vec2 bl = scissor.xy;
    vec2 tr = scissor.xy + scissor.zw;
    vec2 insetPos = clamp(pos.xy, bl * 2.0 - 1.0, tr * 2.0 - 1.0);
    vec2 inset = insetPos - pos.xy;
    uv += inset * 0.5;
    pos.xy = insetPos;
}
{@}SolidBackgroundShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec3 uColor;

#!VARYINGS

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = vec4(uColor, 1.0);
}{@}LatticeParticleShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;
attribute vec3 colors;
attribute vec3 uv2;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tPointColor;
uniform sampler2D tMap;
uniform vec3 uLightPos;
uniform vec3 uTint;
uniform float DPR;
uniform float uScroll;
uniform float uScale;
uniform vec3 uColor;
uniform float uBright;
uniform float uDist;

#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying vec3 vWorldPos;
varying vec2 vUv;
varying vec3 vColors;
varying vec3 vNormal;
varying vec3 vWorldNormal;
varying vec3 vViewDir;
varying float vNoise;
varying float vCircularWave;

#!SHADER: Vertex

#require(range.glsl)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;
    vLightColor = texture2D(tPointColor, position.xy).rgb;
    vColors = colors;

    vNoise = cnoise(pos*0.13 + vec3(time*0.24,-time*0.12,time*0.12))*0.4;
    vNoise += cnoise(pos*0.08 + vec3(time*0.2,-time*0.1,time*0.22)) * 0.8;
    vNoise += cnoise(pos*0.3 + vec3(time*-0.3,-time*0.15,time*0.12)) * 0.18;
    //pos += vLightColor*0.15 * crange(vNoise,-0.5,1.0,2.0,4.0);
    pos.y += vNoise;

    vViewDir = -vec3(modelViewMatrix * vec4(pos, 1.0));
    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    vec3 waveOrigin = vec3(6.0,0.0,-12.0);
    float distToWaveCenter = distance(vec3(pos.x,0.0,pos.z), vec3(waveOrigin));
    float circularWave = crange(sin(-0.7*time + distToWaveCenter * 0.1),0.9,1.0,0.0,1.0);
    vCircularWave = circularWave;
    pos.y += crange(vCircularWave,0.0,1.0,-0.2,1.0);
    pos.y = mix(pos.y, 1.0, vCircularWave*0.3);

    vPos = pos;
    vRandom = random;


    vScale = 0.01;
    vScale *= 1.0 + (0.5 + sin(time * 5.0 + vRandom.x * 20.0) * 0.5) * 0.4;
    vScale *= mix(0.7, 1.2, random.z);
    vScale = mix(vScale, 0.03, circularWave*0.6);
    vScale *= 0.35;

    // matrix scaling for consistency across resolutions
    float halfDiag = 0.5 * length(resolution);
    float focal = halfDiag * projectionMatrix[1][1];
    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    float dist = length(mvPosition.xyz);

    gl_PointSize = DPR * 1.3 * vScale * (focal / dist);
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)
#require(fresnel.glsl)

vec3 hue(vec3 color, float hue) {
    const vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(hue);
    return vec3(color * cosAngle + cross(k, color) * sin(hue) + k * dot(k, color) * (1.0 - cosAngle));
}

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;

    vec3 color = vec3(1.4);
    //color += vLightColor*1.5;
    float waveMedium = crange(sin(time*3.0 + vLightColor.r*8.0),-1.0,1.0,0.3,0.5);
    float waveLarge = crange(sin(time + vLightColor.b*15.0),-1.0,1.0,0.5,1.2);
    color *= waveMedium;
    color *= waveLarge;
    

    vec3 sparkle = vec3(0.4 + sin(time * 8.0 + vRandom.y * 20.0));
    color += sparkle * pow(vRandom.z, 20.0) * 0.1;

    color = mix(color, vec3(0.95),vCircularWave*0.6);

    float distFromCenter = distance(vPos,vec3(0.0,vPos.y,0.0));
    distFromCenter = crange(distFromCenter,5.0,18.0,1.0,0.0);

    float op = color.r;
    op *= 1.1;

    color *= distFromCenter;
    op *= distFromCenter;





    #drawbuffer Color gl_FragColor = vec4(vec3(color), op);
}{@}DotShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;
attribute vec3 colors;

#!UNIFORMS
uniform sampler2D tPos;
uniform float DPR;
uniform float uScale;
uniform vec3 uColor;
uniform float uBright;
uniform float uDist;

#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying vec3 vWorldPos;
varying vec2 vUv;
varying vec3 vColors;
varying vec3 vNormal;
varying vec3 vWorldNormal;
varying vec3 vViewDir;
varying float vNoise;

#!SHADER: Vertex

#require(range.glsl)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;

    vNoise = cnoise(pos*1.7 + vec3(time*0.3,-time,0.0));
    vNoise += cnoise(pos*3.7 + vec3(time*0.3,-time,0.0)) * 0.6;
    vNoise += crange(cnoise(pos*13.7 + vec3(time*-0.1,-time*5.0,0.0)),0.0,1.0,0.0,0.25);
    //float noise = texture2D(tMap,vec2(pos.x,pos.y)).r;
    //vNoise = noise;

    vViewDir = -vec3(modelViewMatrix * vec4(pos, 1.0));
    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    vPos = pos;
    vRandom = random;

    vScale = 0.006;
    vScale *= 1.0 + (0.5 + sin(time * 5.0 + vRandom.x * 20.0) * 0.5) * 0.5;
    vScale *= mix(0.5, 1.9, random.z);
    vScale = mix(vScale, 0.006,0.7);
    //vScale = 1.0;

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = DPR * 2.0 * vScale * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)

vec3 hue(vec3 color, float hue) {
    const vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(hue);
    return vec3(color * cosAngle + cross(k, color) * sin(hue) + k * dot(k, color) * (1.0 - cosAngle));
}

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;

    vec3 color = vec3(0.1);

    vec3 sparkle = vec3(0.4 + sin(time * 8.0 + vRandom.y * 20.0));
    color += sparkle * pow(vRandom.z, 20.0) * 0.3;

    float op = 1.0;

    #drawbuffer Color gl_FragColor = vec4(vec3(color), op);
}{@}GlobeParticleShader.glsl{@}#!ATTRIBUTES
attribute vec4 random;
attribute vec3 colors;
attribute vec3 uv2;

#!UNIFORMS
uniform sampler2D tPos;
uniform sampler2D tPointColor;
uniform sampler2D tMap;
uniform vec3 uLightPos;
uniform vec3 uTint;
uniform float DPR;
uniform float uScroll;
uniform float uScale;
uniform vec3 uColor;
uniform float uBright;
uniform float uDist;

#!VARYINGS
varying vec3 vLightColor;
varying vec3 vPos;
varying vec4 vRandom;
varying float vScale;
varying float vDist;
varying float vRipple;
varying vec3 vWorldPos;
varying vec2 vUv;
varying vec3 vColors;
varying vec3 vNormal;
varying vec3 vWorldNormal;
varying vec3 vViewDir;
varying float vNoise;

#!SHADER: Vertex

#require(range.glsl)
#require(simplenoise.glsl)

void main() {
    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;
    vLightColor = texture2D(tPointColor, position.xy).rgb;
    vColors = colors;
    vec3 sphereN = normalize(pos);
    vWorldNormal = mat3(modelMatrix[0].xyz, modelMatrix[1].xyz, modelMatrix[2].xyz) * normalize(pos);
    vNormal = normalize(normalMatrix * normalize(pos));

    vNoise = cnoise(pos*1.7 + vec3(time*0.3,-time,0.0));
    vNoise += cnoise(pos*3.7 + vec3(time*0.3,-time,0.0)) * 0.6;
    vNoise += crange(cnoise(pos*13.7 + vec3(time*-0.1,-time*5.0,0.0)),0.0,1.0,0.0,0.25);
    vec2 movinguv = vec2(uv2.xy) + vec2(0.0,time);
    //float noise = texture2D(tMap,vec2(pos.x,pos.y)).r;
    //vNoise = noise;
    pos += sphereN * vLightColor*0.15 * crange(vNoise,-0.5,1.0,2.0,4.0);

    vViewDir = -vec3(modelViewMatrix * vec4(pos, 1.0));
    vec3 worldPos = vec3(modelMatrix * vec4(pos, 1.0));
    vWorldPos = worldPos;

    vPos = pos;
    vRandom = random;

    vScale = 0.006;
    vScale *= 1.0 + (0.5 + sin(time * 5.0 + vRandom.x * 20.0) * 0.5) * 0.5;
    vScale *= mix(0.5, 1.9, random.z);
    vScale = mix(vScale, 0.006,0.7);

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = DPR * 2.0 * vScale * (1000.0 / length(mvPosition.xyz));
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment

#require(range.glsl)
#require(transformUV.glsl)
#require(simplenoise.glsl)
#require(rgb2hsv.fs)
#require(blendmodes.glsl)
#require(fresnel.glsl)

vec3 hue(vec3 color, float hue) {
    const vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(hue);
    return vec3(color * cosAngle + cross(k, color) * sin(hue) + k * dot(k, color) * (1.0 - cosAngle));
}

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
    if (length(uv-0.5) > 0.5) discard;

    vec3 color = vec3(0.1);
    color += vLightColor*1.5;
    float fresnel = getFresnel(vNormal, vViewDir, 0.3);
    color += fresnel;

    vec3 sparkle = vec3(0.4 + sin(time * 8.0 + vRandom.y * 20.0));
    color += sparkle * pow(vRandom.z, 20.0) * 0.3;


    float op = 1.0;

    #drawbuffer Color gl_FragColor = vec4(vec3(color), op);
}{@}MovecComposite.fs{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tUpscaled;
uniform sampler2D tDiffuse;
uniform sampler2D tLoader;

uniform float uLoaded; // js {value: 0.0}

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);
    vUv = uv;
}

#!SHADER: Fragment
#require(simplenoise.glsl)
#require(blendmodes.glsl)
#require(UnrealBloom.fs)
#require(rgbshift.fs)
#require(contrast.glsl)
#require(range.glsl)
#require(radialblur.fs)
#require(eases.glsl)
#require(transformUV.glsl)

vec3 saturation(vec3 rgb, float adjustment) {
    const vec3 W = vec3(0.2126729, 0.7151522, 0.0721750);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

void main() {
    vec3 upscale = texture2D(tUpscaled, vUv).rgb;
    vec3 color = texture2D(tUpscaled, vUv).rgb;
    if ( uLoaded < 1.0 ) {
        float aspect = resolution.x / resolution.y;
        float aspectMult = crange( aspect, 1.0, 0.0, 1.0, 0.0 );
        vec3 loader = texture2D(tLoader, scaleUV(vUv, vec2(1920, 1080) / resolution * aspectMult)).rgb;
        color = mix(loader, color, uLoaded);
    }

    vec3 bloom = getUnrealBloom(vUv);
    vec3 noise = vec3(getNoise(vUv, time));

    color = blendOverlay(color, noise, 0.1);
    color += bloom;

    float d = length(vUv - vec2(0.5));
    float vig   = sineOut(crange(d, 0.0, 1.0, 1.0, 2.1));
    float bright= 0.15 * sineOut(crange(d, 0.0, 1.0, 1.4, 2.3));
    vec3 darkCol = saturation(color, 10.0) * 0.21;
    color = mix(darkCol, color, vig);
    color *= crange(bright, 0.0, 1.0, 0.8, 4.0);

    gl_FragColor = vec4(color, 1.0);
}
{@}ProductShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform vec4 uEdgeFade;
uniform float uEdgeFadeDist;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vec3 pos = position;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

#require(motionvector.fs)
#require(range.glsl)

void main() {
    vec4 color = getMVColor(vUv);

    float leftFade = crange(vUv.x,0.0,0.0+uEdgeFadeDist, 0.0,1.0);
    float rightFade = crange(vUv.x,1.0-uEdgeFadeDist,1.0, 1.0,0.0);
    float bottomFade = crange(vUv.y,0.0,0.0+uEdgeFadeDist, 0.0,1.0);
    float topFade = crange(vUv.y,1.0-uEdgeFadeDist,1.0, 1.0,0.0);

    color.rgb *= mix(1.0,leftFade, uEdgeFade.x);
    color.rgb *= mix(1.0,rightFade, uEdgeFade.y);
    color.rgb *= mix(1.0,bottomFade, uEdgeFade.z);
    color.rgb *= mix(1.0,topFade, uEdgeFade.a);

    float op = crange(color.a,0.4,1.0,0.0,1.0);
    if (op < 0.1) discard;
    gl_FragColor = vec4(color.rgb, op);
}
{@}SpiralGraphIcon.glsl{@}#!ATTRIBUTES
attribute float progress;
attribute vec2 cellCoord;

#!UNIFORMS
uniform sampler2D uMainTexture;
uniform sampler2D uSymbolTexture;
uniform vec2 uMainTextureGridSize;
uniform float uSymbolCount;
uniform vec2 uGridSize;
uniform vec3 uSymbolColor;

#!VARYINGS
varying vec2 vUv;
varying float vProgress;
varying vec2 vCellCoord;

#!SHADER: Vertex
void main() {
    vec3 pos = position;
    vUv = uv;
    vProgress = progress;
    vCellCoord = cellCoord;
    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment
#require(transformUV.glsl)
void main() {
    vec2 uv = vUv;
    
    vec2 gridUV = uv * uGridSize;
    vec2 cellUV = fract(gridUV);
    vec2 cellCoord = floor(gridUV);
    
    vec2 mainTexUV = vUv;
    mainTexUV = scaleUV(mainTexUV, uMainTextureGridSize);
    mainTexUV = translateUV(mainTexUV, -vCellCoord / uMainTextureGridSize);
    vec4 mainColor = texture2D(uMainTexture, mainTexUV);
    
    float brightness = (mainColor.r + mainColor.g + mainColor.b) / 3.0;
    brightness -= 1.0 - vProgress;
    if ( brightness < 0.01 ) discard;
    brightness = 1.0 - brightness;
    
    float symbolIndex = floor(mod(brightness * uSymbolCount, uSymbolCount));
    float symbolX = symbolIndex / uSymbolCount;
    vec2 symbolUV = vec2(symbolX + cellUV.x / uSymbolCount, cellUV.y);
    vec4 symbolColor = texture2D(uSymbolTexture, symbolUV);
    
    if (symbolColor.a > 0.1) {
        gl_FragColor = vec4(uSymbolColor * symbolColor.rgb, symbolColor.a);
    } else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}
{@}SpiralGraphParticles.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float uParticleSize;
uniform vec3 uParticleDeactiveatedColor;
uniform vec3 uParticleColor;
uniform float uProgress;
uniform vec2 uDistRange;
uniform float DPR;

#!VARYINGS
varying vec2 vUv;
varying vec3 vPosition;

#!SHADER: Vertex
void main() {
    vUv = uv;
    vec3 pos = position;
    vPosition = pos;
    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_PointSize = DPR * uParticleSize * 7.5;
    gl_Position = projectionMatrix * mvPosition;
}

#!SHADER: Fragment
#require(range.glsl)
void main() {
    // Create circular particles using point sprite coordinates
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(gl_PointCoord, center);
    float alpha = 1.0 - smoothstep(0.0, 0.5, dist);

    vec3 color = mix( uParticleDeactiveatedColor, uParticleColor, crange( vPosition.y - crange( uProgress, 0.0, 1.3, uDistRange.x, uDistRange.y ), 0.0, 0.01, 1.0, 0.0 ));
    
    // Discard fragments outside the circle
    if (dist > 0.5) {
        discard;
    }
    
    gl_FragColor = vec4(color, alpha);
}
{@}MediaQuad.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform vec2 uAspect;
uniform vec2 uOffset;
uniform vec2 uScale;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    gl_Position = vec4(position, 1.0);;
}

#!SHADER: Fragment
#require(transformUV.glsl)
#require(range.glsl)
void main() {
    vec2 uv = gl_FragCoord.xy / resolution;
    float mediaAspect = uAspect.x / uAspect.y;
    float quadAspect = resolution.x / resolution.y;
    float aspect = mediaAspect > quadAspect ? mediaAspect / quadAspect : quadAspect / mediaAspect;
    uv = scaleUV( uv, mediaAspect > quadAspect ? vec2(aspect, 1.0) : vec2(1.0, aspect));
    uv = scaleUV( uv, uScale );
    uv = translateUV( uv, uOffset );
    uv.x = clamp(uv.x, 0.0, 1.0);
    uv.y = clamp(uv.y, 0.0, 1.0);
    vec3 color = texture2D(tMap, uv).rgb;
    gl_FragColor = vec4( color, 1.0 );
}{@}SubterraneanHeaderBGShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS

#!VARYINGS

#!SHADER: Vertex

void main() {
    vec3 pos = position.xyz;
    pos.xy *= 2.0;
    gl_Position = vec4(pos, 1.0);
}

#!SHADER: Fragment

void main() {
    vec3 color = vec3(216.0, 216.0, 212.0) / 255.0;

    gl_FragColor = vec4(color, 1.0);
}{@}SubterraneanHeaderParticleShader.glsl{@}#!ATTRIBUTES
attribute vec3 random;

#!UNIFORMS
uniform float uProgress;
uniform sampler2D tPos;
uniform sampler2D tPointColor;

#!VARYINGS
varying vec3 vPos;
varying float vProgress;
varying float vAlpha;

#!SHADER: Vertex

mat2 rotate(float a) {
	float s = sin(a);
	float c = cos(a);
	return mat2(c, s, -s, c);
}

float quadraticInOut(float t) {
  float p = 2.0 * t * t;
  return t < 0.5 ? p : -p + (4.0 * t) - 1.0;
}

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}


void main() {

    vec4 decodedPos = texture2D(tPos, position.xy);
    vec3 pos = decodedPos.xyz;
    vPos = decodedPos.xyz;

    // align points in columns towards bottom
    float blend = smoothstep(-2.0, -5.0, decodedPos.y);
    // vec3 dotGridPos = pos;
    // dotGridPos.x = floor(dotGridPos.x * 20.0) / 20.0;
    // dotGridPos.y = floor(dotGridPos.y * 20.0) / 20.0;

    // animation timeline progress
    float progress = uProgress;

    // translate animation
    pos.y += progress * 15.0;
    pos.y += 0.5;
    // dotGridPos.y += progress * 15.0;
    // dotGridPos.y += 0.5;

    // rotate animation
    float angle = -0.75 * (1.0 - clamp(progress * 2.0, 0.0, 1.0));
    pos.zy = rotate(angle) * pos.zy;

    // flatten points to create dot matrix pattern
    float flatten = clamp(mix(1.0, 0.0, progress * 1.0), 0.0, 1.0);
    flatten = smoothstep(0.0, 1.0, flatten);
    // pos.z *= flatten;

    // scale
    float scale = 3.5;

    // scale up a bit towards bottom, to blend with plane better
    scale += blend * 1.0;

    // alpha that can be calculated per-particle instead of per-fragment
    vAlpha = 1.0;

    // fade bottom particles so top view doesn't look too busy
    float verticalFade = smoothstep(-2.0, -1.0, vPos.y);
    verticalFade = mix(verticalFade, 1.0, uProgress);
    vAlpha *= mix(verticalFade, 1.0, clamp(uProgress * 2.0, 0.0, 1.0));

    // noise animation
    float noise = texture2D(tPointColor, position.xy).r;
    vAlpha -= (sin(time * 3.0 + noise * 15.0) * 0.5 + 0.5) * 0.5;
    // vAlpha -= (sin(time * 8.0 + noise * 1000.0) * 0.5 + 0.5) * 0.5;
    vAlpha = max(0.3, vAlpha);

      // fade out at sides
    float radialFade = clamp(1.0 - length(vPos.xz) * 0.3, 0.0, 1.0);
    radialFade = 1.0 - pow(1.0 - radialFade, 2.0);
    radialFade = mix(radialFade, 1.0, uProgress);
    vAlpha *= radialFade;

    vAlpha *= 0.5;

    // displacement animation
    float displacement = 0.0;
    displacement += sin(noise * 6.0 + time);
    displacement = pow(displacement, 5.0)  * 0.03 * flatten;

    displacement += sin(vPos.x - time) * (1.0 - flatten) * 0.15;

    pos.y += displacement;

    gl_PointSize = scale * resolution.y * 0.001;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);

}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);

    float alpha = 1.0;

    // particle shape
    float circle = 1.0 - smoothstep(0.0, 0.5, length(uv - 0.5));
    alpha *= circle;

    // global alpha
    alpha *= vAlpha;

    vec3 color = vec3(0.0, 0.0, 0.0);

    gl_FragColor = vec4(vec3(color), alpha);
}{@}SubterraneanHeaderPlaneShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform float uProgress;
uniform sampler2D tNoise;
uniform sampler2D tGrain;

#!VARYINGS
varying vec4 vWorldPos;
varying vec2 vUv;
varying float vHeight;

#!SHADER: Vertex

void main() {
    vUv = uv;
    vHeight = 16.0;

    // animation progress 0...1
    float progress = uProgress;

    // scale vertically
    vec3 pos = position;
    pos.y *= vHeight;

    // animate vertical position
    pos.y -= 15.0;
    pos.y += progress * 15.0;
    pos.y += 6.0;

    vWorldPos = modelMatrix * vec4(position, 1.0);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment

float aastep(float threshold, float value) {
    float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
    return smoothstep(threshold-afwidth, threshold+afwidth, value);
}

void main() {
    vec2 uv = vWorldPos.xy * vec2(1.0, vHeight) * 2.0;
    vec2 uv2 = uv * vec2(-1.0, 1.0) + vec2(0.1, 0.4);
    vec2 uv3 = uv + vec2(-0.8, 0.5);

    float displacement1 = sin(time - uv.x * 0.5 + uv.y * 0.25);
    displacement1 += sin(time - uv.x * 3.14159 * 0.25);
    displacement1 *= 0.2 * (1.0 - vUv.y);
    uv.y += displacement1;

    // float displacement2 = sin(time - uv.x * 1.0) * 0.9;
    // displacement2 *= 0.05;
    uv2.y += displacement1 * 0.8;

    // float displacement3 = sin(uv.x * 0.472 + time - uv.y * 0.2 * 0.8);
    // displacement3 *= 0.05;
    uv3.y += displacement1 * 0.6;

    vec2 scrollDisplacement = vec2(0.0, uProgress * 0.2);
    
    float grain = texture2D(tGrain, uv * 0.095 + scrollDisplacement).r;
    float value = (1.0 - grain) + (vUv.y - 0.5) * 3.0;
    // value -= (sin(displacement1 * 9.0 + time * 1.5 + uv.y) * 0.5 + 0.5) * 0.35;
    value = smoothstep(0.85, 0.0, value);

    float grain2 = texture2D(tGrain, uv2 * 0.095 + scrollDisplacement * 0.75).r;
    float value2 = (1.0 - grain2) + (vUv.y - 0.5) * 3.0;
    value2 = smoothstep(1.0, 0.25, value2);

    float grain3 = texture2D(tGrain, uv3 * 0.095 + scrollDisplacement * 0.5).r;
    float value3 = (1.0 - grain3) + (vUv.y - 0.5) * 3.0;
    value3 = smoothstep(0.75, 0.0, value3);

    value += value2;
    value += value3;

    value /= 2.5;


    vec3 color = vec3(0.0);

    float alpha = value;

    if (alpha < 0.05) discard;

    gl_FragColor = vec4(color, alpha);
}{@}SubterraneanHeaderShader.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap1;
uniform sampler2D tMap2;
uniform float uVertOffset;
uniform float uVertClip;
uniform float uTransition;
uniform float uProgress;
uniform float uGradient;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
#require(SliceScreenQuadVertex.vs)
void main() {
    vec3 pos = position;
    vUv = uv;
    applySliceOffset(pos, vUv);

    gl_Position = vec4(pos, 1.0);
}

#!SHADER: Fragment

void main() {
    vec2 uv = vUv;
    gl_FragColor = texture2D(tMap1, uv);
}
{@}advectionShader.fs{@}varying vec2 vUv;
uniform sampler2D uVelocity;
uniform sampler2D uSource;
uniform vec2 texelSize;
uniform float dt;
uniform float dissipation;
void main () {
    vec2 coord = vUv - dt * texture2D(uVelocity, vUv).xy * texelSize;
    gl_FragColor = dissipation * texture2D(uSource, coord);
    gl_FragColor.a = 1.0;
}{@}clearShader.fs{@}varying vec2 vUv;
uniform sampler2D uTexture;
uniform float value;
void main () {
    gl_FragColor = value * texture2D(uTexture, vUv);
}{@}curlShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uVelocity;
void main () {
    float L = texture2D(uVelocity, vL).y;
    float R = texture2D(uVelocity, vR).y;
    float T = texture2D(uVelocity, vT).x;
    float B = texture2D(uVelocity, vB).x;
    float vorticity = R - L - T + B;
    gl_FragColor = vec4(0.5 * vorticity, 0.0, 0.0, 1.0);
}{@}displayShader.fs{@}varying vec2 vUv;
uniform sampler2D uTexture;
void main () {
    vec3 C = texture2D(uTexture, vUv).rgb;
    float a = max(C.r, max(C.g, C.b));
    gl_FragColor = vec4(C, a);
}{@}divergenceShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uVelocity;
void main () {
    float L = texture2D(uVelocity, vL).x;
    float R = texture2D(uVelocity, vR).x;
    float T = texture2D(uVelocity, vT).y;
    float B = texture2D(uVelocity, vB).y;
    vec2 C = texture2D(uVelocity, vUv).xy;
   if (vL.x < 0.0) { L = -C.x; }
   if (vR.x > 1.0) { R = -C.x; }
   if (vT.y > 1.0) { T = -C.y; }
   if (vB.y < 0.0) { B = -C.y; }
    float div = 0.5 * (R - L + T - B);
    gl_FragColor = vec4(div, 0.0, 0.0, 1.0);
}
{@}fluidBase.vs{@}varying vec2 vUv;
varying vec2 vL;
varying vec2 vR;
varying vec2 vT;
varying vec2 vB;
uniform vec2 texelSize;

void main () {
    vUv = uv;
    vL = vUv - vec2(texelSize.x, 0.0);
    vR = vUv + vec2(texelSize.x, 0.0);
    vT = vUv + vec2(0.0, texelSize.y);
    vB = vUv - vec2(0.0, texelSize.y);
    gl_Position = vec4(position, 1.0);
}{@}gradientSubtractShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uPressure;
uniform sampler2D uVelocity;
vec2 boundary (vec2 uv) {
    return uv;
    // uv = min(max(uv, 0.0), 1.0);
    // return uv;
}
void main () {
    float L = texture2D(uPressure, boundary(vL)).x;
    float R = texture2D(uPressure, boundary(vR)).x;
    float T = texture2D(uPressure, boundary(vT)).x;
    float B = texture2D(uPressure, boundary(vB)).x;
    vec2 velocity = texture2D(uVelocity, vUv).xy;
    velocity.xy -= vec2(R - L, T - B);
    gl_FragColor = vec4(velocity, 0.0, 1.0);
}{@}pressureShader.fs{@}varying highp vec2 vUv;
varying highp vec2 vL;
varying highp vec2 vR;
varying highp vec2 vT;
varying highp vec2 vB;
uniform sampler2D uPressure;
uniform sampler2D uDivergence;
vec2 boundary (vec2 uv) {
    return uv;
    // uncomment if you use wrap or repeat texture mode
    // uv = min(max(uv, 0.0), 1.0);
    // return uv;
}
void main () {
    float L = texture2D(uPressure, boundary(vL)).x;
    float R = texture2D(uPressure, boundary(vR)).x;
    float T = texture2D(uPressure, boundary(vT)).x;
    float B = texture2D(uPressure, boundary(vB)).x;
    float C = texture2D(uPressure, vUv).x;
    float divergence = texture2D(uDivergence, vUv).x;
    float pressure = (L + R + B + T - divergence) * 0.25;
    gl_FragColor = vec4(pressure, 0.0, 0.0, 1.0);
}{@}splatShader.fs{@}varying vec2 vUv;
uniform sampler2D uTarget;
uniform float aspectRatio;
uniform vec3 color;
uniform vec3 bgColor;
uniform vec2 point;
uniform vec2 prevPoint;
uniform float radius;
uniform float canRender;
uniform float uAdd;

float blendScreen(float base, float blend) {
    return 1.0-((1.0-base)*(1.0-blend));
}

vec3 blendScreen(vec3 base, vec3 blend) {
    return vec3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
}

float l(vec2 uv, vec2 point1, vec2 point2) {
    vec2 pa = uv - point1, ba = point2 - point1;
    pa.x *= aspectRatio;
    ba.x *= aspectRatio;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

float cubicOut(float t) {
    float f = t - 1.0;
    return f * f * f + 1.0;
}

void main () {
    vec3 splat = (1.0 - cubicOut(clamp(l(vUv, prevPoint.xy, point.xy) / radius, 0.0, 1.0))) * color;
    vec3 base = texture2D(uTarget, vUv).xyz;
    base *= canRender;

    vec3 outColor = mix(blendScreen(base, splat), base + splat, uAdd);
    gl_FragColor = vec4(outColor, 1.0);
}{@}vorticityShader.fs{@}varying vec2 vUv;
varying vec2 vL;
varying vec2 vR;
varying vec2 vT;
varying vec2 vB;
uniform sampler2D uVelocity;
uniform sampler2D uCurl;
uniform float curl;
uniform float dt;
void main () {
    float L = texture2D(uCurl, vL).x;
    float R = texture2D(uCurl, vR).x;
    float T = texture2D(uCurl, vT).x;
    float B = texture2D(uCurl, vB).x;
    float C = texture2D(uCurl, vUv).x;
    vec2 force = 0.5 * vec2(abs(T) - abs(B), abs(R) - abs(L));
    force /= length(force) + 0.0001;
    force *= curl * C;
    force.y *= -1.0;
//    force.y += 400.3;
    vec2 vel = texture2D(uVelocity, vUv).xy;
    gl_FragColor = vec4(vel + force * dt, 0.0, 1.0);
}{@}Line.glsl{@}#!ATTRIBUTES
attribute vec3 previous;
attribute vec3 next;
attribute float side;
attribute float width;
attribute float lineIndex;
attribute vec2 uv2;

#!UNIFORMS
uniform float uLineWidth;
uniform float uBaseWidth;
uniform float uOpacity;
uniform vec3 uColor;

#!VARYINGS
varying float vLineIndex;
varying vec2 vUv;
varying vec2 vUv2;
varying vec3 vColor;
varying float vOpacity;
varying float vWidth;
varying float vDist;
varying float vFeather;
varying float vLengthScale;


#!SHADER: Vertex

//params

vec2 fix(vec4 i, float aspect) {
    vec2 res = i.xy / i.w;
    res.x *= aspect;
    return res;
}

void main() {
#test RenderManager.type == RenderManager.VR
    float aspect = (resolution.x / 2.0) / resolution.y;
#endtest
#test RenderManager.type != RenderManager.VR
    float aspect = resolution.x / resolution.y;
#endtest

    vUv = uv;
    vUv2 = uv2;
    vLineIndex = lineIndex;
    vColor = uColor;
    vOpacity = uOpacity;
    vFeather = 0.1;

    vec3 pos = position;
    vec3 prevPos = previous;
    vec3 nextPos = next;
    float lineWidth = 1.0;
    //main

    //startMatrix
    mat4 m = projectionMatrix * modelViewMatrix;
    vec4 finalPosition = m * vec4(pos, 1.0);
    vec4 pPos = m * vec4(prevPos, 1.0);
    vec4 nPos = m * vec4(nextPos, 1.0);
    //endMatrix

    vec2 currentP = fix(finalPosition, aspect);
    vec2 prevP = fix(pPos, aspect);
    vec2 nextP = fix(nPos, aspect);

    float w = uBaseWidth * uLineWidth * width * lineWidth;
    vWidth = w;

    vec4 temp1 = vec4(0.0, 0.0, pos.z, 1.0);
    temp1 = m * temp1;
    vec4 temp2 = vec4(1.0, 0.0, pos.z, 1.0);
    temp2 = m * temp2;
    vLengthScale = abs(temp2.x - temp1.x);

    vec2 dirNC = currentP - prevP;
    vec2 dirPC = nextP - currentP;
    if (length(dirNC) >= 0.0001) dirNC = normalize(dirNC);
    if (length(dirPC) >= 0.0001) dirPC = normalize(dirPC);
    vec2 dir = normalize(dirNC + dirPC);

    //direction
    vec2 normal = vec2(-dir.y, dir.x);
    normal.x /= aspect;
    normal *= 0.5 * w;

    vDist = finalPosition.z / 10.0;

    finalPosition.xy += normal * side;
    gl_Position = finalPosition;
}

#!SHADER: Fragment

//fsparams

void main() {
    float d = (1.0 / (5.0 * vWidth + 1.0)) * vFeather * (vDist * 5.0 + 0.5);
    vec2 uvButt = vec2(0.0, vUv.y);
    float buttLength = 0.5 * vWidth;
    uvButt.x = min(0.5, vUv2.x * vLengthScale / buttLength) + (0.5 - min(0.5, (vUv2.y - vUv2.x) * vLengthScale / buttLength));
    float round = length(uvButt - 0.5);
    float alpha = 1.0 - smoothstep(0.45, 0.5, round);

    /*
        If you're having antialiasing problems try:
        Remove line 93 to 98 and replace with
        `
            float signedDist = tri(vUv.y) - 0.5;
            float alpha = clamp(signedDist/fwidth(signedDist) + 0.5, 0.0, 1.0);

            if (w <= 0.3) {
                discard;
                return;
            }

            where tri function is

            float tri(float v) {
                return mix(v, 1.0 - v, step(0.5, v)) * 2.0;
            }
        `

        Then, make sure your line has transparency and remove the last line
        if (gl_FragColor.a < 0.1) discard;
    */

    vec3 color = vColor;

    gl_FragColor.rgb = color;
    gl_FragColor.a = alpha;
    gl_FragColor.a *= vOpacity;

    //fsmain

    if (gl_FragColor.a < 0.1) discard;
}
{@}motionvector.fs{@}uniform float uMotionStrength;
uniform float uPlayhead;
uniform float uFrames;
uniform float uMotionConfidenceThreshold; // New: controls confidence drop-off
uniform sampler2DArray tColor;
uniform sampler2DArray tMotionVectors;

float _mvFrameIndex;
float _mvNextFrameIndex;
vec2 _mvCurrentUV;
vec2 _mvNextUV;
float _mvBlend;

vec4 getMVColor(vec2 uv) {
    // Compute the current frame and blend factor
    float totalFrames = uFrames;
    float currentFrame = fract(uPlayhead) * (totalFrames - 1.0);
    float frameIndex = floor(currentFrame);
    float nextFrameIndex = mod(frameIndex + 1.0, totalFrames);
    float blend = fract(currentFrame);
    float smoothBlend = smoothstep(0.0, 1.0, blend);

    // Sample motion vectors from both frames
    vec2 currentMotion = texture(tMotionVectors, vec3(uv, frameIndex)).rg;
    vec2 nextMotion = texture(tMotionVectors, vec3(uv, nextFrameIndex)).rg;

    // Estimate local variance for current and next motion vectors
    vec2 currentMotionDx = dFdx(currentMotion);
    vec2 currentMotionDy = dFdy(currentMotion);
    float currentVariance = length(currentMotionDx) + length(currentMotionDy);

    vec2 nextMotionDx = dFdx(nextMotion);
    vec2 nextMotionDy = dFdy(nextMotion);
    float nextVariance = length(nextMotionDx) + length(nextMotionDy);

    // Compute per-frame confidence factors (1.0 = high confidence; lower = less reliable)
    float confidenceCurrent = clamp(1.0 - currentVariance * uMotionConfidenceThreshold, 0.0, 1.0);
    float confidenceNext   = clamp(1.0 - nextVariance   * uMotionConfidenceThreshold, 0.0, 1.0);
    // Blend the two confidences based on the smooth blend factor
    float confidenceBlend = mix(confidenceCurrent, confidenceNext, smoothBlend);

    // Convert the motion vectors from [0,1] to [-1,1] and adjust with motion strength
    currentMotion = (currentMotion * 2.0 - 1.0) * (uMotionStrength * 0.01);
    nextMotion = (nextMotion * 2.0 - 1.0) * (uMotionStrength * 0.01);

    // Adjust UV displacement using the per-frame confidence factors
    vec2 currentUV = uv - currentMotion * smoothBlend * confidenceCurrent;
    vec2 nextUV    = uv + nextMotion * (1.0 - smoothBlend) * confidenceNext;

    // Optionally, if confidence is very low, blend back toward the original UV coordinates
    vec2 blendedUV = mix(uv, (currentUV + nextUV) * 0.5, confidenceBlend);

    // Clamp coordinates to avoid sampling outside
    currentUV = clamp(currentUV, 0.0, 1.0);
    nextUV    = clamp(nextUV, 0.0, 1.0);
    blendedUV = clamp(blendedUV, 0.0, 1.0);

    // Save values for the normal lookup later
    _mvCurrentUV = currentUV;
    _mvNextUV = nextUV;
    _mvFrameIndex = frameIndex;
    _mvNextFrameIndex = nextFrameIndex;
    _mvBlend = smoothBlend;

    // Sample colors from the two frames using the displaced UVs
    vec4 currentColorDisplaced = texture(tColor, vec3(currentUV, frameIndex));
    vec4 nextColorDisplaced = texture(tColor, vec3(nextUV, nextFrameIndex));
    
    // Blend the two color samples
    vec4 blendedColor = mix(currentColorDisplaced, nextColorDisplaced, smoothBlend);
    // Fall back toward the original UV if confidence is low
    vec4 finalColor = mix(texture(tColor, vec3(uv, frameIndex)), blendedColor, confidenceBlend);

    return finalColor;
}

vec3 getMVNormal(sampler2DArray tNormal, vec2 uv) {
    // Use the previously computed displaced UVs and blend factor for normals
    vec3 currentNormalDisplaced = texture(tNormal, vec3(_mvCurrentUV, _mvFrameIndex)).rgb;
    vec3 nextNormalDisplaced = texture(tNormal, vec3(_mvNextUV, _mvNextFrameIndex)).rgb;
    return mix(currentNormalDisplaced, nextNormalDisplaced, _mvBlend);
}{@}ProtonAntimatter.fs{@}uniform sampler2D tOrigin;
uniform sampler2D tAttribs;
uniform float uMaxCount;
//uniforms

#require(range.glsl)
//requires

void main() {
    vec2 uv = vUv;
    #test !window.Metal
    uv = gl_FragCoord.xy / fSize;
    #endtest

    vec3 origin = texture2D(tOrigin, uv).xyz;
    vec4 inputData = texture2D(tInput, uv);
    vec3 pos = inputData.xyz;
    vec4 random = texture2D(tAttribs, uv);
    float data = inputData.w;

    if (vUv.x + vUv.y * fSize > uMaxCount) {
        gl_FragColor = vec4(9999.0);
        return;
    }

    //code

    gl_FragColor = vec4(pos, data);
}{@}SceneLayout.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tMap;
uniform float uAlpha;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex
void main() {
    vec3 pos = position;
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}

#!SHADER: Fragment
void main() {
    gl_FragColor = texture2D(tMap, vUv);
    gl_FragColor.a *= uAlpha;
    gl_FragColor.rgb /= gl_FragColor.a;
}{@}UnrealBloom.fs{@}uniform sampler2D tUnrealBloom;

vec3 getUnrealBloom(vec2 uv) {
    return texture2D(tUnrealBloom, uv).rgb;
}{@}UnrealBloomComposite.glsl{@}#!ATTRIBUTES

#!UNIFORMS

uniform sampler2D blurTexture1;
uniform float bloomStrength;
uniform float bloomRadius;
uniform vec3 bloomTintColor;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment.fs

float lerpBloomFactor(const in float factor) {
    float mirrorFactor = 1.2 - factor;
    return mix(factor, mirrorFactor, bloomRadius);
}

void main() {
    gl_FragColor = bloomStrength * (lerpBloomFactor(1.0) * vec4(bloomTintColor, 1.0) * texture2D(blurTexture1, vUv));
}{@}UnrealBloomGaussian.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D colorTexture;
uniform vec2 texSize;
uniform vec2 direction;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment.fs

float gaussianPdf(in float x, in float sigma) {
    return 0.39894 * exp(-0.5 * x * x / (sigma * sigma)) / sigma;
}

void main() {
    vec2 invSize = 1.0 / texSize;
    float fSigma = float(SIGMA);
    float weightSum = gaussianPdf(0.0, fSigma);
    vec3 diffuseSum = texture2D( colorTexture, vUv).rgb * weightSum;
    for(int i = 1; i < KERNEL_RADIUS; i ++) {
        float x = float(i);
        float w = gaussianPdf(x, fSigma);
        vec2 uvOffset = direction * invSize * x;
        vec3 sample1 = texture2D( colorTexture, vUv + uvOffset).rgb;
        vec3 sample2 = texture2D( colorTexture, vUv - uvOffset).rgb;
        diffuseSum += (sample1 + sample2) * w;
        weightSum += 2.0 * w;
    }
    gl_FragColor = vec4(diffuseSum/weightSum, 1.0);
}{@}UnrealBloomLuminosity.glsl{@}#!ATTRIBUTES

#!UNIFORMS
uniform sampler2D tDiffuse;
uniform vec3 defaultColor;
uniform float defaultOpacity;
uniform float luminosityThreshold;
uniform float smoothWidth;

#!VARYINGS
varying vec2 vUv;

#!SHADER: Vertex.vs
void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}

#!SHADER: Fragment.fs

#require(luma.fs)

void main() {
    vec4 texel = texture2D(tDiffuse, vUv);
    float v = luma(texel.xyz);
    vec4 outputColor = vec4(defaultColor.rgb, defaultOpacity);
    float alpha = smoothstep(luminosityThreshold, luminosityThreshold + smoothWidth, v);
    gl_FragColor = mix(outputColor, texel, alpha);
}{@}UnrealBloomPass.fs{@}#require(UnrealBloom.fs)

void main() {
    vec4 color = texture2D(tDiffuse, vUv);
    color.rgb += getUnrealBloom(vUv);
    gl_FragColor = color;
}{@}luma.fs{@}float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}

float luma(vec4 color) {
  return dot(color.rgb, vec3(0.299, 0.587, 0.114));
}{@}lanczosUpscale.fs{@}// lanczosUpscale.fs

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 vUv;
uniform sampler2D tDiffuse;
uniform vec2 uTexSize;
uniform float uSharpenStrength;
uniform float uLanczosA;           // new: window radius, default 3.0
uniform float uUpsampleBlend;      // new: 0 = pure bilinear, 1 = full Lanczos

// your sinc, lanczos, fetchNearest, upLanczos, and unsharpâ€‘mask logic:
float sinc(float x){
    if (x == 0.0) return 1.0;
    return sin(3.141592653589793 * x) / (3.141592653589793 * x);
}
float lanczos(float x){
  x = abs(x);
  if(x < uLanczosA){
    return sinc(x) * sinc(x / uLanczosA);
  }
  return 0.0;
}
vec3 fetchNearest(sampler2D tex, vec2 uv){
    vec2 pixel = uv * uTexSize;
    vec2 coord = (floor(pixel) + 0.5) / uTexSize;
    return texture2D(tex, coord).rgb;
}
vec3 upLanczos(sampler2D tex, vec2 uv){
    vec2 pixel = uv * uTexSize;
    vec2 base  = floor(pixel);
    vec2 f     = pixel - base;
    vec3 sum = vec3(0.0);
    float wsum = 0.0;
    for (int j = -3; j <= 3; j++){
        for (int i = -3; i <= 3; i++){
            float wx = lanczos(float(i) - f.x);
            float wy = lanczos(f.y - float(j));
            float w  = wx * wy;
            vec2 off = (base + vec2(float(i), float(j)) + 0.5) / uTexSize;
            sum  += fetchNearest(tex, off) * w;
            wsum += w;
        }
    }
    return sum / wsum;
}

void main(){
    vec3 linearUp = texture2D(tDiffuse, vUv).rgb;
    vec3 lanczUp = upLanczos(tDiffuse, vUv);

    vec3 up = mix(linearUp, lanczUp, uUpsampleBlend);

    // 3) denoise + unsharp mask
    float k[5] = float[5](0.0625,0.25,0.375,0.25,0.0625);
    vec2 ts = 1.0 / uTexSize;
    vec3 blur = vec3(0.0);
    for(int y=-2;y<=2;y++){
    for(int x=-2;x<=2;x++){
        blur += fetchNearest(tDiffuse, vUv + vec2(x,y)*ts) * k[x+2]*k[y+2];
    }
    }
    vec3 sharp = up + uSharpenStrength * (up - blur);

    gl_FragColor = vec4(sharp, 1.0);
}{@}lanczosUpscale.vs{@}out vec2 vUv;

void main() {
    vUv = uv;
    gl_Position = vec4(position, 1.0);
}