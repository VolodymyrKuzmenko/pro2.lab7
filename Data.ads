-------------------------------------------------------------------------------
--                                                                           --
--                   Parallel and Distributed Computing                      --
--                   Laboratory work #7. Ada. Rendezvous                     --
--                                                                           --
--  File: data.ads                                                           --
--  Task: A = max(Z)*E + alpha * B(MO * MK)                                  --
--                                                                           --
--  Author: Kuzmenko Volodymyr, group IO-21                                  --
--  Date: 28.04.2015                                                         --
--                                                                           --
-------------------------------------------------------------------------------


with Ada.Text_IO;
use Ada.Text_IO;

generic
   
   N, H : in Natural;
   
package Data is 

   type    Vector    is array(Integer range <>) of Integer;
   Subtype VectorN  is Vector(1..N);
   Subtype Vector6h is Vector(1..6 * H);
   Subtype Vector3h is Vector(1..3 * H);
   Subtype Vector2H is Vector(1..2 * H);
   Subtype VectorH  is Vector(1..H);

   type    Matrix   is array(Integer range <>) of VectorN;
   Subtype MatrixN  is Matrix(1..N);
   Subtype Matrix6h is Matrix(1..6 * H);
   Subtype Matrix3h is Matrix(1..3 * H);
   Subtype Matrix2H is Matrix(1..2 * H);
   Subtype MatrixH  is Matrix(1..H);


   procedure Input ( V     : out Vector;
                     Value : in Integer);
   
   procedure Input ( MA    : out Matrix;
                     Value : in Integer);
   
   procedure Output (V : in Vector);

   procedure Output (MA : in Matrix);

   procedure FindMaxZ (V : in VectorH; maxZi : out Integer);
   
   function Max (A, B: Integer) return Integer;
   
   procedure Calculation(  alfa : in Integer;
      maxZ : in Integer;
      B : in VectorN;
      E : in VectorH;
      MO : in MatrixH;
      MK : in MatrixN;
      A : out VectorH);
                           

end Data;
