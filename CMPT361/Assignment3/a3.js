import { Framebuffer } from './framebuffer.js';
import { Rasterizer } from './rasterizer.js';
// DO NOT CHANGE ANYTHING ABOVE HERE

////////////////////////////////////////////////////////////////////////////////
// TODO: Implement functions drawLine(v1, v2) and drawTriangle(v1, v2, v3) below.
////////////////////////////////////////////////////////////////////////////////

// take two vertices defining line and rasterize to framebuffer
Rasterizer.prototype.drawLine = function(v1, v2) {
  console.log(v1,v2)
  const [x1, y1, [r1, g1, b1]] = v1;
  const [x2, y2, [r2, g2, b2]] = v2;
  // TODO/HINT: use this.setPixel(x, y, color) in this function to draw line
  this.setPixel(Math.floor(x1), Math.floor(y1), [r1, g1, b1]);
  this.setPixel(Math.floor(x2), Math.floor(y2), [r2, g2, b2]);
  
  const xDiff = x2-x1;
  const yDiff = y2-y1;
  const unit = Math.abs(yDiff) >= Math.abs(xDiff) ? Math.abs(yDiff) : Math.abs(xDiff);
  let y = y1;
  let x = x1;
  
  for (let i = 0 ; i < unit ; i++) {
    x += xDiff/unit;
    y += yDiff/unit;
    var t = getDistance(x,y,x1,y1)/getDistance(x1,y1,x2,y2);
    if(0 <= t <= 1){
      var [r,g,b] = [(1-t)*r1+t*r2, (1-t)*g1+t*g2, (1-t)*b1+t*b2];
      this.setPixel(Math.floor(x), Math.floor(y), [r,g,b])
    }
  }
}

// take 3 vertices defining a solid triangle and rasterize to framebuffer
Rasterizer.prototype.drawTriangle = function(v1, v2, v3) {
  const [x1, y1, [r1, g1, b1]] = v1;
  const [x2, y2, [r2, g2, b2]] = v2;
  const [x3, y3, [r3, g3, b3]] = v3;
  // TODO/HINT: use this.setPixel(x, y, color) in this function to draw triangle
  this.setPixel(Math.floor(x1), Math.floor(y1), [r1, g1, b1]);
  this.setPixel(Math.floor(x2), Math.floor(y2), [r2, g2, b2]);
  this.setPixel(Math.floor(x3), Math.floor(y3), [r3, g3, b3]);
  for (let y = Math.min(y1,y2,y3); y <= Math.max(y1,y2,y3); y++){
    for (let x = Math.min(x1,x2,x3); x <= Math.max(x2,x3,x1);x++){
      if(pointIsInsideTriangle(v1,v2,v3,[x,y])){
        this.setPixel(Math.floor(x), Math.floor(y), barycentricCoordinates(v1,v2,v3,[x,y]) )
      }
    }
  }
}


function getDistance(px1, py1,px2, py2){
  let x = px2-px1;
  let y = py2-py1;
  return Math.sqrt(x*x + y*y)
}


function barycentricCoordinates(v1,v2,v3,p){
  const [x1, y1, [r1, g1, b1]] = v1;
  const [x2, y2, [r2, g2, b2]] = v2;
  const [x3, y3, [r3, g3, b3]] = v3;
  const [x,y] = p;
  const areaOfTriangle = triangleArea(v1,v2,[x3,y3]);
  var u = triangleArea(v2,v3,[x,y])/areaOfTriangle;
  var v = triangleArea(v3,v1,[x,y])/areaOfTriangle;
  var w = triangleArea(v1,v2,[x,y])/areaOfTriangle;  
  return [u*r1 + v*r2 + w*r3, u*g1 + v*g2 + w*g3, u*b1 + v*b2 + w*b3]
 }


 function triangleArea(v1,v2,p1){
  const [x1, y1, [r1,g1,b1]] = v1;
  const [x2, y2, [r2,g2,b2]] = v2;
  const [px1, py1] = p1;
  return Math.abs((x2-x1)*(py1-y1) - (y2-y1)*(px1-x1))/2
}


function pointIsInsideTriangle(v1,v2,v3,p){
  const [x1, y1, [r1, g1, b1]] = v1;
  const [x2, y2, [r2, g2, b2]] = v2;
  const [x3, y3, [r3, g3, b3]] = v3;
  const [px1, py1] = p;
  if (checkConversion(v1,v2,[px1,py1]) && checkConversion(v2,v3,[px1,py1]) && checkConversion(v3,v1,[px1,py1]))
  {
    //true for now
    return true
  }
  else 
  return false 
}


function checkConversion(v1,v2,p){
  const [x1, y1, [r1, g1, b1]] = v1;
  const [x2, y2, [r2, g2, b2]] = v2;
  const [px1,py1] = p;
  const result = (y2-y1)*px1 + (x1-x2)*py1+ x2*y1-x1*y2
  return result >= 0
}

////////////////////////////////////////////////////////////////////////////////
// EXTRA CREDIT: change DEF_INPUT to create something interesting!
////////////////////////////////////////////////////////////////////////////////
const DEF_INPUT = [
  "v,10,10,1.0,0.0,0.0;",
  "v,52,52,0.0,1.0,0.0;",
  "v,52,10,0.0,0.0,1.0;",
  "v,10,52,1.0,1.0,1.0;",
  "t,0,1,2;",
  "t,0,3,1;",
  "v,10,10,1.0,1.0,1.0;",
  "v,10,52,0.0,0.0,0.0;",
  "v,52,52,1.0,1.0,1.0;",
  "v,52,10,0.0,0.0,0.0;",
  "l,4,5;",
  "l,5,6;",
  "l,6,7;",
  "l,7,4;",
].join("\n");


// DO NOT CHANGE ANYTHING BELOW HERE
export { Rasterizer, Framebuffer, DEF_INPUT };
