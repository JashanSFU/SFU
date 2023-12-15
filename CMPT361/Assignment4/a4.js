import { Mat4 } from './math.js';
import { Parser } from './parser.js';
import { Scene } from './scene.js';
import { Renderer } from './renderer.js';
import { TriangleMesh } from './trianglemesh.js';
// DO NOT CHANGE ANYTHING ABOVE HERE

////////////////////////////////////////////////////////////////////////////////
// TODO: Implement createCube, createSphere, computeTransformation, and shaders
////////////////////////////////////////////////////////////////////////////////

// Example two triangle quad
const quad = {
  positions: [-1, -1, -1, 1, -1, -1, 1, 1, -1, -1, -1, -1, 1,  1, -1, -1,  1, -1],
  normals: [0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1],
  uvCoords: [0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1]
}

TriangleMesh.prototype.createCube = function() {
  // TODO: populate unit cube vertex positions, normals, and uv coordinates
  // this.positions = quad.positions;
  // this.normals = quad.normals;
  // this.uvCoords = quad.uvCoords;
  
  // this.positions.push(-1,-1,+1); // 0
  // this.positions.push(+1,-1,+1); // 1
  // this.positions.push(+1,+1,+1); // 2
  // this.positions.push(-1,+1,+1); // 3
  // this.positions.push(-1,+1,-1); // 4
  // this.positions.push(+1,+1,-1); // 5
  // this.positions.push(+1,-1,-1); // 6
  // this.positions.push(-1,-1,-1); // 7
  
  this.positions.push(-1,-1,+1); // 0
  this.positions.push(+1,-1,+1); // 1
  this.positions.push(-1,+1,+1); // 3

  // this.normals.push(0,0,+1);
  this.uvCoords.push(0,2/3,1/2,2/3,0,1);
  
  this.positions.push(+1,-1,+1); // 1
  this.positions.push(+1,+1,+1); // 2
  this.positions.push(-1,+1,+1); // 3

  // this.normals.push(0,0,+1);
  this.uvCoords.push(1/2,2/3,1/2,1,0,1);
  
  this.positions.push(+1,+1,+1); // 2
  this.positions.push(-1,+1,+1); // 3
  this.positions.push(-1,+1,-1); // 4

  // this.normals.push(0,+1,0);
  this.uvCoords.push(1/2,0,0,0,0,1/3);
  
  this.positions.push(+1,+1,+1); // 2
  this.positions.push(-1,+1,-1); // 4
  this.positions.push(+1,+1,-1); // 5

  // this.normals.push(0,+1,0);
  this.uvCoords.push(1/2,0,0,1/3,1/2,1/3);  
  
  this.positions.push(-1,+1,-1); // 4
  this.positions.push(+1,+1,-1); // 5
  this.positions.push(+1,-1,-1); // 6

  // this.normals.push(0,0,-1);
  this.uvCoords.push(1/2,1/3,1,1/3,1,0);
  
  this.positions.push(-1,+1,-1); // 4
  this.positions.push(+1,-1,-1); // 6
  this.positions.push(-1,-1,-1); // 7

  // this.normals.push(0,0,-1);
  this.uvCoords.push(1/2,1/3,1,0,1/2,0);
  
  this.positions.push(+1,-1,-1); // 6
  this.positions.push(-1,-1,-1); // 7
  this.positions.push(+1,-1,+1); // 1

  // this.normals.push(0,-1,0);
  this.uvCoords.push(1,1,1/2,1,1,2/3);
  
  this.positions.push(-1,-1,+1); // 0
  this.positions.push(+1,-1,+1); // 1
  this.positions.push(-1,-1,-1); // 7

  // this.normals.push(0,-1,0);
  this.uvCoords.push(1/2,2/3,1,2/3,1/2,1);
  
  this.positions.push(+1,-1,+1); // 1
  this.positions.push(+1,+1,+1); // 2
  this.positions.push(+1,+1,-1); // 5

  // this.normals.push(+1,0,0);
  this.uvCoords.push(0,1/3,0,2/3,1/2,2/3);
  
  this.positions.push(+1,-1,+1); // 1
  this.positions.push(+1,+1,-1); // 5
  this.positions.push(+1,-1,-1); // 6

  // this.normals.push(+1,0,0);
  this.uvCoords.push(0,1/3,1/2,2/3,1/2,1/3);
  
  this.positions.push(-1,-1,+1); // 0
  this.positions.push(-1,+1,+1); // 3
  this.positions.push(-1,+1,-1); // 4

  // this.normals.push(-1,0,0);
  this.uvCoords.push(1,1/3,1,2/3,1/2,2/3);
  
  this.positions.push(-1,-1,+1); // 0
  this.positions.push(-1,+1,-1); // 4
  this.positions.push(-1,-1,-1); // 7

  // this.normals.push(-1,0,0);
  this.uvCoords.push(1,1/3,1/2,2/3,1/2,1/3);
  
  for(let i = 0 ; i < this.positions.length; i+=9)
  {
    let Ax = this.positions[i];
    let Ay = this.positions[i+1];
    let Az = this.positions[i+2];
    let Bx = this.positions[i+3];
    let By = this.positions[i+4];
    let Bz = this.positions[i+5];
    let Cx = this.positions[i+6];
    let Cy = this.positions[i+7];
    let Cz = this.positions[i+8];
    let vectorOne = [Ax-Bx,Ay-By,Az-Bz];
    let vectorTwo = [Cx-Bx,Cy-By,Cz-Bz];
    let resultCross = [vectorOne[1]*vectorTwo[2] - vectorOne[2]*vectorTwo[1],vectorTwo[2]*vectorOne[0]-vectorOne[0]*vectorTwo[2],vectorOne[0]*vectorTwo[1]-vectorOne[1]*vectorTwo[0]];
    let sum = Math.abs(resultCross[0])+ Math.abs(resultCross[1]) + Math.abs(resultCross[2]);
    resultCross = [resultCross[0]/sum , resultCross[1]/sum, resultCross[2]/sum];
    this.normals.push(resultCross[0], resultCross[1],resultCross[2]);
  }
}

// resources from ReadMe: http://www.songho.ca/opengl/gl_sphere.html
TriangleMesh.prototype.createSphere = function(numStacks, numSectors) {
  // TODO: populate unit sphere vertex positions, normals, uv coordinates, and indices
  // this.positions = quad.positions.slice(0, 9).map(p => p * 0.5);
  // this.normals = quad.normals.slice(0, 9);
  // this.uvCoords = quad.uvCoords.slice(0, 6);
  // this.indices = [0, 1, 2];
  
  let radius = 1;
  let sectorCount = numSectors;
  let stackCount = numStacks;
  let x, y, z, xy;                              // vertex position
  let nx, ny, nz, lengthInv = 1.0 / radius;    // vertex normal
  let s, t;                                     // vertex texCoord

  let sectorStep = 2 * Math.PI / sectorCount;
  let stackStep = Math.PI / stackCount;
  let sectorAngle, stackAngle;
  
  for(let i = 0; i <= stackCount; ++i)
  {
      stackAngle = Math.PI / 2 - i * stackStep;        // starting from pi/2 to -pi/2
      xy = radius * Math.cos(stackAngle);             // r * cos(u)
      z = radius * Math.sin(stackAngle);              // r * sin(u)

      for(let j = 0; j <= sectorCount; ++j)
      {
          sectorAngle = - j * sectorStep;           // starting from 0 to 2pi

          x = xy * Math.cos(sectorAngle);             // r * cos(u) * cos(v)
          y = xy * Math.sin(sectorAngle);             // r * cos(u) * sin(v)
          this.positions.push(x,y,z);

          nx = x * lengthInv;
          ny = y * lengthInv;
          nz = z * lengthInv;
          this.normals.push(nx,ny,nz);

          s = j / sectorCount;
          t = i / stackCount;
          this.uvCoords.push(s,t);
      }
    }
    
    let k1, k2;
    for(let i = 0; i < stackCount; ++i)
    {
        k1 = i * (sectorCount + 1);     // beginning of current stack
        k2 = k1 + sectorCount + 1;      // beginning of next stack

        for(let j = 0; j < sectorCount; ++j, ++k1, ++k2)
        {
            if(i != 0)
            {
              this.indices.push(k1);
              this.indices.push(k2);
              this.indices.push(k1 + 1);
            }

            if(i != (stackCount-1))
            {
                this.indices.push(k1 + 1);
                this.indices.push(k2);
                this.indices.push(k2 + 1);
            }

        }
    }
}

Scene.prototype.computeTransformation = function(transformSequence) {
  // TODO: go through transform sequence and compose into overallTransform
  let overallTransform = Mat4.create();  // identity matrix
  for (let i = 0 ; i < transformSequence.length; i++){
    let transformation = Mat4.create();
    if(transformSequence[i][0] == 'T'){
        transformation = [1,0,0,transformSequence[i][1],0,1,0,transformSequence[i][2],0,0,1,transformSequence[i][3],0,0,0,1]
    } else if (transformSequence[i][0] == 'Rx'){ 
        let radian = Math.PI * (transformSequence[i][1]/180);
        transformation = [1,0,0,0,0, Math.cos(radian), - Math.sin(radian),0, 0, Math.sin(radian), Math.cos(radian),0, 0,0,0,1]
    } else if (transformSequence[i][0] == 'Ry'){
        let radian = Math.PI * (transformSequence[i][1]/180);
        transformation = [Math.cos(radian),0,Math.sin(radian),0, 0,1,0,0, -Math.sin(radian),0,Math.cos(radian),0, 0,0,0,1]
    } else if (transformSequence[i][0] == 'Rz'){
        let radian = Math.PI * (transformSequence[i][1]/180);
        transformation = [Math.cos(radian), - Math.sin(radian), 0 , 0, Math.sin(radian), Math.cos(radian), 0 , 0, 0, 0, 1 , 0, 0,0,0,1]
    } else if (transformSequence[i][0] == 'S'){
        transformation = [transformSequence[i][1],0,0,0,0,transformSequence[i][2],0,0,0,0,transformSequence[i][3],0,0,0,0,1]
    }
    transformation = Mat4.transpose(transformation,transformation)
    overallTransform = Mat4.multiply(overallTransform,transformation,overallTransform);
  }
  return overallTransform;
}

Renderer.prototype.VERTEX_SHADER = `
precision mediump float;
attribute vec3 position, normal;
attribute vec2 uvCoord;
uniform vec3 lightPosition;
uniform mat4 projectionMatrix, viewMatrix, modelMatrix;
uniform mat3 normalMatrix;
varying vec2 vTexCoord;

// TODO: implement vertex shader logic below

varying vec3 N;
varying vec3 L;
varying vec3 H;
void main() {
  vec4 pos = viewMatrix * modelMatrix * vec4(position , 1.0);
  gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position, 1.0);
  N = normalize(normalMatrix * normal);
  L = normalize(lightPosition - vec3(modelMatrix * vec4(position, 1.0)));
  H = normalize(L + vec3(normalize(-vec3(modelMatrix * vec4(position, 1.0)))));
  vTexCoord = uvCoord;
}
`;

Renderer.prototype.FRAGMENT_SHADER = `
precision mediump float;
uniform vec3 ka, kd, ks, lightIntensity;
uniform float shininess;
uniform sampler2D uTexture;
uniform bool hasTexture;
varying vec2 vTexCoord;

// TODO: implement fragment shader logic below

varying vec3 N;
varying vec3 L;
varying vec3 H;
const vec3 lightColor = vec3(1.0, 1.0, 1.0);

void main() {  
  // ambient part 
  vec3 col_ambient = vec3(ka * lightIntensity); 
 
  // lambertian diffuse
  float n_dot_l = dot(N,L);
  float clamp_n_dot_l = max(0.0, n_dot_l);
  vec3 col_diffuse = (kd) * clamp_n_dot_l * lightIntensity;
  
  // blinn-phong
  vec3 col_specular = vec3((ks) * pow(max(dot(N,H), 0.0), shininess)) * lightIntensity ; 

  vec4 textureColor = hasTexture ? texture2D(uTexture, vTexCoord) : vec4(1.0, 1.0, 1.0, 1.0);
  vec4 col = vec4(col_diffuse + col_specular + col_ambient,1.0) * textureColor;
  gl_FragColor = col;
}
`;

////////////////////////////////////////////////////////////////////////////////
// EXTRA CREDIT: change DEF_INPUT to create something interesting!
////////////////////////////////////////////////////////////////////////////////
const DEF_INPUT = [
  "c,myCamera,perspective,5,5,5,0,0,0,0,1,0;",
  "l,myLight,point,0,5,0,2,2,2;",
  "p,unitCube,cube;",
  "p,unitSphere,sphere,20,20;",
  "m,redDiceMat,0.3,0,0,0.7,0,0,1,1,1,15,dice.jpg;",
  "m,grnDiceMat,0,0.3,0,0,0.7,0,1,1,1,15,dice.jpg;",
  "m,bluDiceMat,0,0,0.3,0,0,0.7,1,1,1,15,dice.jpg;",
  "m,globeMat,0.3,0.3,0.3,0.7,0.7,0.7,1,1,1,5,globe.jpg;",
  "o,rd,unitCube,redDiceMat;",
  "o,gd,unitCube,grnDiceMat;",
  "o,bd,unitCube,bluDiceMat;",
  "o,gl,unitSphere,globeMat;",
  "X,rd,Rz,75;X,rd,Rx,90;X,rd,S,0.5,0.5,0.5;X,rd,T,-1,0,2;",
  "X,gd,Ry,45;X,gd,S,0.5,0.5,0.5;X,gd,T,2,0,2;",
  "X,bd,S,0.5,0.5,0.5;X,bd,Rx,90;X,bd,T,2,0,-1;",
  "X,gl,S,1.5,1.5,1.5;X,gl,Rx,90;X,gl,Ry,-150;X,gl,T,0,1.5,0;",
].join("\n");

// DO NOT CHANGE ANYTHING BELOW HERE
export { Parser, Scene, Renderer, DEF_INPUT };
