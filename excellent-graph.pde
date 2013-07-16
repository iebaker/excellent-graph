/*
 *  ExcellentGraph, by Izaak Baker. An explicit/implicit function grapher
 */

import java.util.concurrent.Callable;
float X = 0;
float Y = 0;
float R = 0;
Screen screen;

//FUNCTION is a class which holds a single function which
//can be evaluated
class Function {
  Callable<Float> m_func;
  
  Function(Callable<Float> f) {
    m_func = f;
  } 
  
  Float evaluate(float x, float y) {
    X = x;
    Y = y;
    
    try {
      return m_func.call(); 
    } catch(Exception e) {
      e.printStackTrace(); 
      return 0.0;
    }
  }
}

//PLOT is a class which contains two functions to be plotted
//against each other
class Plot {
  Function m_LHS;
  Function m_RHS;
  color m_color;
  
  Plot(Function L, Function R, color c) {
    m_LHS = L;
    m_RHS = R; 
    m_color = c;
  }
  
  void display(float xmi, float xma, float ymi, float yma) {
    int prev = 0;     // prev = 0 if LHS >= RHS, 1 otherwise
    int curr = 0;
    
    loadPixels();
    for(float x = 0; x < width; x++) {
      for(float y = 0; y < height; y++) {
        
        int loc = (int)(x + y * width);

        for(int i = 0; i < 3; i++) {
          int xModulator = i % 2 == 1 ? 1 : 0;
          int yModulator = i > 1 ? 1 : 0;
          
          float xVal = ((x + xModulator) * (xma - xmi)/width) + xmi;
          float yVal = ((height - (y + yModulator)) * (yma - ymi)/height) + ymi;
          
          curr = (m_LHS.evaluate(xVal, yVal) >= m_RHS.evaluate(xVal, yVal)) ? 1 : 0;
          if(i != 0) {
            if(prev != curr) {
              pixels[loc] = m_color; 
              break;
            }
          }
          
          prev = curr;
        }
        
      } 
    }
    updatePixels();
  }
}

class Screen {
  float m_xMin;
  float m_xMax;
  float m_yMin;
  float m_yMax;
  float m_xRange;
  float m_yRange;
  ArrayList<Plot> m_plots = new ArrayList<Plot>();
  
  Screen(float xmi, float xma, float ymi, float yma) {
    m_xMin = xmi;
    m_xMax = xma;
    m_yMin = ymi;
    m_yMax = yma;
    m_xRange = xma - xmi;
    m_yRange = yma - ymi;
  }
  
  void addPlot(Plot p) {
    m_plots.add(p);
  }
  
  void display() {
    this.drawLines();
    this.drawPlots();
  }
  
  void drawLines() {
    float xVal = 0 - (m_xMin * width) / m_xRange;
    float yVal = height + (m_yMin * height) / m_yRange;
    stroke(200);
    line(0, yVal, width, yVal);
    line(xVal, 0, xVal, height);
  }
  
  void drawPlots() {
    for(Plot p : m_plots) {
      p.display(m_xMin, m_xMax, m_yMin, m_yMax); 
    }
  }
}

/******************
 * SETUP AND DRAW *
 ******************/
 
void setup() {
  background(255);
  size(600, 600);
  Callable<Float> _LHS1 = new Callable() {
    public Float call() {
      return (Float)( Y );
    } 
  };
  
  Callable<Float> _RHS1 = new Callable() {
    public Float call() {
      return (Float)( 5 * exp(X) * sin(exp(-X)) + X/2 );
    } 
  };
  
  Callable<Float> _LHS2 = new Callable() {
    public Float call() {
      return (Float)( ( pow(X+R,2) + pow(Y,2) - 8) * (pow(X-R,2) + pow(Y,2) - 8) );
    }
  };
  
  Callable<Float> _RHS2 = new Callable() {
    public Float call() {
      return (Float)( -1.0 );
    }
  };
  
  Plot p1 = new Plot(new Function(_LHS1), new Function(_RHS1), color(255, 0, 0));
  Plot p2 = new Plot(new Function(_LHS2), new Function(_RHS2), color(0, 0, 255));
  screen = new Screen(-10, 10, -10, 10);
  screen.addPlot(p1);
  screen.display();
}


