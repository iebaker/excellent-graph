excellent-graph
===============

A Processing implicit/explicit function grapher.

The algorithm is a modified version of the one described 
here:

http://batesvilleinschools.com/physics/CalcNet/grapher/how_it_works.htm

It is based upon the truth value of (LHS > RHS), a boolean where
LHS is the left hand side of the equation and RHS is the right hand side.  A pixel is included in
the graph if that value is different between any two corners of the 
pixel.
