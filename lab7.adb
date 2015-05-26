-------------------------------------------------------------------------------
--                                                                           --
--                   Parallel and Distributed Computing                      --
--                   Laboratory work #7. Ada. Rendezvous                     --
--                                                                           --
--  File: pro2_lab7.adb                                                      --
--  Task: A = max(Z)*E + alpha * B(MO * MK)                                  --
--                                                                           --
--  Author: Kuzmenko Volodymyr, group IO-21                                  --
--  Date: 28.04.2015                                                         --
--                                                                           --
-------------------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_text_iO, Ada.Synchronous_Task_Control, Data;
use Ada.Text_IO, Ada.Integer_text_iO, Ada.Synchronous_Task_Control;

procedure lab7 is

   Value : Integer := 1;
   N : Natural := 21;
   P : Natural := 7;
   H : Natural := N/P;

   package DataN is new Data(N, H);
   use DataN;

   procedure StartTasks is
-------------------------------------------------------------------------------
--                             СПЕЦИФІКАЦІЯ ЗАДАЧ                            --
-------------------------------------------------------------------------------

--                                 Задача T1                                 --
      task T1 is
         entry DataH(
            E : in VectorH;
            Z : in VectorH;
            MO : in MatrixH);
         entry MaxZ (maxZ : in Integer);
         entry ResultH(A : out VectorH);
      end T1;

--                                 Задача T2                                 --
      task T2 is
         entry DataMKBalfa(MK : in MatrixN; B : in VectorN; alfa : in Integer);
         entry Data2H(
            E : in Vector2H;
            Z : in Vector2H;
            MO : in Matrix2H);
         entry MaxZ1 (maxZ1 : in Integer);
         entry MaxZ (maxZ : in Integer);
         entry Result2H(A : out Vector2H);
      end T2;

--                                 Задача T3                                 --
      task T3 is
         entry DataMKBalfa(MK : in MatrixN; B : in VectorN; alfa : in Integer);
         entry Data3H(
            E : in Vector3H;
            Z : in Vector3H;
            MO : in Matrix3H);
         entry MaxZ2 (maxZ1 : in Integer);
         entry MaxZ (maxZ : in Integer);
         entry Result3H(A : out Vector3H);
      end T3;



--                                 Задача T4                                 --
      task T4 is
         entry DataMKBalfa(MK : in MatrixN; B : in VectorN; alfa : in Integer);
         entry DataMOE6H(
            E : in Vector6H;
            MO : in Matrix6H);
         entry MaxZ3 (maxZi : in Integer);
         entry MaxZ5 (maxZi : in Integer);
         entry MaxZ6 (maxZi : in Integer);
         entry MaxZ7 (maxZi : in Integer);

      end T4;

--                                 Задача T5                                 --
      task T5 is
         entry DataZ(Z : in VectorH);
         entry DataMKBalfaEHMOH(
            alfa : in Integer;
            E : in VectorH;
            B: in VectorN;
            MO: in MatrixH;
            MK : in MatrixN);
         entry MaxZ (maxZ : in Integer);
          entry ResultH(A : out VectorH);
      end T5;

--                                 Задача T6                                 --
      task T6 is
         entry DataZ(Z : in VectorH);
         entry DataMKBalfaEHMOH(
            alfa : in Integer;
            E : in VectorH;
            B: in VectorN;
            MO: in MatrixH;
            MK : in MatrixN);
         entry MaxZ (maxZ : in Integer);
         entry ResultH(A : out VectorH);
      end T6;

--                                 Задача T7                                 --
      task T7 is
         entry DataZ(Z : in VectorH);
         entry DataMKBalfa(
            alfa : in Integer;
            B: in VectorN;
            MK : in MatrixN);
         entry MaxZ (maxZ : in Integer);
         entry ResultH(A : out VectorH);
      end T7;

-------------------------------------------------------------------------------
--                                 ТІЛА ЗАДАЧ                                --
-------------------------------------------------------------------------------

--                                 Задача T1                                 --

      task body T1 is
         A1 : VectorH;
         Z1 : VectorH;
         E1: VectorH;
         B1 : VectorN;
         MO1 : MatrixH;
         MK1 : MatrixN;
         alfa1: Integer;
         maxZ1: Integer := -99999;
      begin
         Put_Line("T1 started");
         --1.	Введення MK, B, α
         Input(MK1,1);
         Input(B1,1);
         alfa1 := 1;
--2.	Передати MK, B, α задачі Т2
         T2.DataMKBalfa(MK1, B1, alfa1);
--3.	Прийняти ZH,EH, MOH від задачі Т2
         accept DataH (E : in VectorH; Z : in VectorH; MO : in MatrixH) do
            E1:=E;
            Z1:= Z;
            MO1:=MO;
         end DataH;
--4.	Обчислити maxZ1 = max(ZH)
         FindMaxZ(Z1, maxZ1);
--5.	Передати maxZ1 задачі Т2
         T2.MaxZ1(maxZ1);
--6.	Прийняти maxZ від задачі Т2
         accept MaxZ (maxZ : in Integer) do
            maxZ1:=maxZ;
         end MaxZ;
--7.	Обчислити AH = maxZ∙EH + α∙B(MOH∙MK)
         Calculation(alfa1, maxZ1, B1, E1, MO1, MK1,  A1);
--8.	Передати AH задачі Т2
         accept ResultH (A : out VectorH)do
            A:= A1;
         end ResultH;


         Put_Line("T1 finished");

      end T1;

--                                 Задача T2                                 --

      task body T2 is
         A2 : Vector2H;
         Z2 : Vector2H;
         E2: Vector2H;
         B2 : VectorN;
         MO2 : Matrix2H;
         MK2 : MatrixN;
         alfa2: Integer;
         maxZ2: Integer := -999999;
         buf: Integer;
      begin
         Put_Line("T2 started");
--1.	Прийняти MK, B, α від задачі Т1
         accept DataMKBalfa (MK : in MatrixN; B : in VectorN; alfa : in Integer) do
            MK2:= MK;
            B2:= B;
            alfa2:= alfa;
         end DataMKBalfa;
--2.	Передати MK, B, α задачі Т3
          T3.DataMKBalfa(MK2, B2, alfa2);
--3.	Прийняти Z2H,E2H, MO2H від задачі Т3
         accept Data2H (E : in Vector2H; Z : in Vector2H; MO : in Matrix2H) do
            E2:=E;
            Z2:= Z;
            MO2:=MO;
         end Data2H;
--4.	Передати ZH,EH, MOH задачі Т1
         T1.DataH(E2(1..H), Z2(1..H) ,MO2(1..H));
--5.	Обчислити maxZ2 = max(ZH)
         accept MaxZ1 (maxZ1 : in Integer) do
            buf:= maxZ1;
         end MaxZ1;
--6.	Прийняти maxZ1 від задачі Т1
         FindMaxZ(Z2(H+1..2*H), maxZ2);
--7.	Обчислити maxZ2 = max (maxZ2,maxZ1)
         maxZ2 :=Max(buf, maxZ2);
--8.	Передати maxZ2 задачі Т3
         T3.MaxZ2(maxZ2);
--9.	Прийняти maxZ від задачі Т2
         accept MaxZ (maxZ : in Integer) do
            maxZ2:=maxZ;
         end MaxZ;
--10.	Педедати maxZ задачі Т1
         T1.MaxZ(maxZ2);
--11.	Обчислити AH = maxZ∙EH + α∙B(MOH∙MK)
         Calculation(alfa2, maxZ2, B2, E2(H+1..2*H), MO2(H+1..2*H), MK2,  A2(H+1..2*H));
--12.	Прийняти AH від задачі Т1
         T1.ResultH(A2(1..H));
--13.	Передати A2H задачі Т2
         accept Result2H(A : out Vector2H) do
            A := A2;
         end Result2H;
         Put_Line("T2 finished");
      end T2;

--                                 Задача T3                                 --

      task body T3 is
        A3 : Vector3H;
        Z3 : Vector3H;
        E3: Vector3H;
        B3 : VectorN;
        MO3 : Matrix3H;
        MK3 : MatrixN;
        alfa3: Integer;
        maxZ3: Integer := -999999;
         buf: Integer;

      begin
          Put_Line("T3 started");
--1.	Прийняти MK, B, α від задачі Т2
         accept DataMKBalfa (MK : in MatrixN; B : in VectorN; alfa : in Integer) do
            MK3:= MK;
            B3:= B;
            alfa3:= alfa;
         end DataMKBalfa;
--2.	Передати MK, B, α задачі Т4
          T4.DataMKBalfa(MK3, B3, alfa3);
--3.	Прийняти Z3H,E3H, MO3H від задачі Т4
         accept Data3H (E : in Vector3H; Z : in Vector3H; MO : in Matrix3H) do
            E3:=E;
            Z3:= Z;
            MO3:=MO;
         end Data3H;
--4.	Передати Z2H,E2H, MO2H задачі Т2
         T2.Data2H(E3(1..2*H), Z3(1..2*H) ,MO3(1..2*H));
--5.	Обчислити maxZ3 = max(ZH)
         FindMaxZ(Z3(2*H+1..3*H), maxZ3);
--6.	Прийняти maxZ2 від задачі Т2
         accept MaxZ2 (maxZ1 : in Integer) do
            buf:= maxZ1;
         end MaxZ2;
--7.	Обчислити maxZ3 = max (maxZ3,maxZ2)
         maxZ3:=Max(buf, maxZ3);
--8.	Передати maxZ3 задачі Т4
         T4.MaxZ3(maxZ3);
--9.	Прийняти maxZ від задачі Т4
         accept MaxZ (maxZ : in Integer) do
            maxZ3:=maxZ;
         end MaxZ;
--10.	Передати maxZ задачі Т2
        T2.MaxZ(maxZ3);
--11.	Обчислити AH = maxZ∙EH + α∙B(MOH∙MK)
         Calculation(alfa3, maxZ3, B3, E3(2*H+1..3*H), MO3(2*H+1..3*H), MK3,  A3(2*H+1..3*H));
--12.	Прийняти A2H від задачі Т2
         T2.Result2H(A3(1..2*H));
--13.	Передати A3H задачі Т2
         accept Result3H(A : out Vector3H) do
            A := A3;
         end Result3H;
         Put_Line("T3 finished");
      end T3;

--                                 Задача T4                                 --

      task body T4 is
        A4 : VectorN;
        Z4 : VectorN;
        E4: Vector6H;
        B4 : VectorN;
        MO4 : Matrix6H;
        MK4 : MatrixN;
        alfa4: Integer;
        maxZ4: Integer := -999999;
        maxValueZ3: Integer;
        maxValueZ5: Integer;
        maxValueZ6: Integer;
         maxValueZ7: Integer;
         sum : Integer:=0;
         Sum1: Integer:=0;


      begin
          Put_Line("T4 started");
--1.	Ввести Z
         Input(Z4,1);
--2.	Передати ZH задачам Т5, Т6, T7
         T5.DataZ(Z4(4*H+1..5*H));
         T6.DataZ(Z4(5*H+1..6*H));
         T7.DataZ(Z4(6*H+1..7*H));
--3.	Прийняти α, B, MK від задачі Т3
         accept DataMKBalfa (MK : in MatrixN; B : in VectorN; alfa : in Integer) do
            MK4:= MK;
            B4:= B;
            alfa4:= alfa;
         end DataMKBalfa;
--4.	Прийняти E6H, MO6H від задачі Т7
         accept DataMOE6H(E : in Vector6H; MO : in Matrix6H) do
            MO4:= MO;
            E4:= E;
         end DataMOE6H;
--5.	Передати Z3H, MO3H, E3H задачі Т3
         T3.Data3H(E4(1..3*H), Z4(1..3*H) ,MO4(1..3*H));
--6.	Передати α, B, MK, MOH, EH задачам Т5, Т6
         T5.DataMKBalfaEHMOH(alfa4, E4(4*H+1..5*H),B4, MO4(4*H+1..5*H), MK4);
         T6.DataMKBalfaEHMOH(alfa4, E4(5*H+1..6*H),B4, MO4(5*H+1..6*H), MK4);
--7.	Передати α, B, MK задачі Т7
         T7.DataMKBalfa(alfa4, B4, MK4);
--8.	Обчислити maxZ4 = max(ZH)
         FindMaxZ(Z4(3*H+1..4*H), maxZ4);
--9.	Прийняти maxZ5 від задачі Т5
         accept MaxZ5 (maxZi : in Integer) do
            maxValueZ5:= maxZi;
         end MaxZ5;
--10.	Обчислити maxZ4 = max (maxZ4,maxZ5)
         maxZ4:=Max(maxValueZ5, maxZ4);
--11.	Прийняти maxZ6 від задачі Т6
         accept MaxZ6 (maxZi : in Integer) do
            maxValueZ6:= maxZi;
         end MaxZ6;
--12.	Обчислити maxZ4 = max (maxZ4,maxZ6)
         maxZ4:=Max(maxValueZ6, maxZ4);
--13.	Прийняти maxZ7 від задачі Т7
         accept MaxZ7 (maxZi : in Integer) do
            maxValueZ7:= maxZi;
         end MaxZ7;
--14.	Обчислити maxZ4 = max (maxZ4,maxZ7)
         maxZ4:=Max(maxValueZ7, maxZ4);
--15.	Прийняти maxZ3 від задачі Т3
         accept MaxZ3 (maxZi : in Integer) do
            maxValueZ3:= maxZi;
         end MaxZ3;
--16.	Обчислити maxZ = max (maxZ4,maxZ3)
         maxZ4:=Max(maxValueZ3, maxZ4);
--17.	Передати maxZ задачам T3,T5,T6,T7
         T3.MaxZ(maxZ4);
         T5.MaxZ(maxZ4);
         T6.MaxZ(maxZ4);
         T7.MaxZ(maxZ4);
--18.	Обчислити AH = maxZ∙EH + α∙B(MOH∙MK)
         Calculation(alfa4, maxZ4, B4, E4(3*H+1..4*H), MO4(3*H+1..4*H), MK4,  A4(3*H+1..4*H));
--19.	Прийняти AH від задач Т5, Т6, Т7
         T5.ResultH(A4(4*H+1..5*H));
         T6.ResultH(A4(5*H+1..6*H));
         T7.ResultH(A4(6*H+1..7*H));
--20.	Прийняти А3H від задачі Т3
         T3.Result3H(A4(1..3*H));
--21.	Вивести А
         Output(A4);
         Put_Line("T4 finished");
      end T4;

--                                 Задача T5                                 --

      task body T5 is
         A5 : VectorH;
         Z5 : VectorH;
         E5: VectorH;
         B5 : VectorN;
         MO5 : MatrixH;
         MK5 : MatrixN;
         alfa5: Integer;
         maxZ5: Integer := -999999;

      begin
         Put_Line("T5 started");
--1.	Прийняти ZH від задачі Т4
         accept DataZ (Z : in VectorH) do
            Z5:=Z;
         end DataZ;
--2.	Прийняти α, B, MK, MOH, EH від задачі Т4
         accept DataMKBalfaEHMOH(alfa : in Integer; E : in VectorH; B: in VectorN;
                                 MO: in MatrixH; MK : in MatrixN) do
            alfa5:= alfa;
            E5:=E;
            B5:=B;
            MO5:=MO;
            MK5:=MK;
         end DataMKBalfaEHMOH;
--3.	Обчислити maxZ5 = max (ZH)
         FindMaxZ(Z5, maxZ5);
--4.	Передати maxZ5  задачі Т4
         T4.MaxZ5(maxZ5);
--5.	Прийняти maxZ від задачі Т4
         accept MaxZ (maxZ : in Integer) do
            maxZ5:= maxZ;
         end MaxZ;
--6.	Обчислити AH = maxZ∙EH + α∙B(MOH∙MK)
         Calculation(alfa5, maxZ5, B5, E5, MO5, MK5,  A5);
--7.	Передати АH задачі Т4
         accept ResultH (A : out VectorH) do
            A:= A5;
         end ResultH;


         Put_Line("T5 finished");
      end T5;

--                                 Задача T6                                 --

      task body T6 is
         A6 : VectorH;
         Z6 : VectorH;
         E6: VectorH;
         B6 : VectorN;
         MO6 : MatrixH;
         MK6 : MatrixN;
         alfa6: Integer;
         maxZ6: Integer := -999999;

      begin
         Put_Line("T6 started");
--1.	Прийняти ZH від задачі Т4
         accept DataZ (Z : in VectorH) do
            Z6:=Z;
         end DataZ;
--2.	Прийняти α, B, MK, MOH, EH від задачі Т4
         accept DataMKBalfaEHMOH(alfa : in Integer; E : in VectorH; B: in VectorN;
                                 MO: in MatrixH; MK : in MatrixN) do
            alfa6:= alfa;
            E6:=E;
            B6:=B;
            MO6:=MO;
            MK6:=MK;
         end DataMKBalfaEHMOH;
--3.	Обчислити maxZ6 = max (ZH)
         FindMaxZ(Z6, maxZ6);
--4.	Передати maxZ6  задачі Т4
         T4.MaxZ6(maxZ6);
--5.	Прийняти maxZ від задачі Т4
         accept MaxZ (maxZ : in Integer) do
            maxZ6:= maxZ;
         end MaxZ;
--6.	Обчислити AH = maxZ∙EH + α∙B(MOH∙MK)
         Calculation(alfa6, maxZ6, B6, E6, MO6, MK6,  A6);
--7.	Передати АH задачі Т4
         accept ResultH (A : out VectorH) do
            A:= A6;
         end ResultH;


         Put_Line("T6 finished");
      end T6;

--                                 Задача T7                                 --

      task body T7 is
         A7 : VectorH;
         Z7 : VectorH;
         E7: VectorN;
         B7 : VectorN;
         MO7 : MatrixN;
         MK7 : MatrixN;
         alfa7: Integer;
         maxZ7: Integer := -999999;

      begin
         Put_Line("T7 started");
--1.	Ввести MO, E
         Input(MO7,1);
         Input(E7,1);
--2.	Прийняти ZH від задачі Т4
         accept DataZ (Z : in VectorH) do
            Z7:=Z;
         end DataZ;
--3.	Передати MO6H, E6H задачі Т4
         T4.DataMOE6H(E7(1..6*H), MO7(1..6*H));
--4.	Прийняти α, B, MK від задачі Т4
         accept DataMKBalfa(alfa : in Integer; B: in VectorN; MK : in MatrixN) do
            alfa7:= alfa;
            B7:=B;
            MK7:=MK;
         end DataMKBalfa;
--5.	Обчислити maxZ7 = max (ZH)
         FindMaxZ(Z7, maxZ7);
--6.	Передати maxZ7  задачі Т4
         T4.MaxZ7(maxZ7);
--7.	Прийняти maxZ від задачі Т4
         accept MaxZ (maxZ : in Integer) do
            maxZ7:= maxZ;
         end MaxZ;
--8.	Обчислити AH = maxZ∙EH + α∙B(MOH∙MK)
         Calculation(alfa7, maxZ7, B7, E7(6*H+1..7*H), MO7(6*H+1..7*H), MK7,  A7);
--9.	Передати АH задачі Т4
         accept ResultH (A : out VectorH) do
            A:= A7;
         end ResultH;
--
         Put_Line("T7 finished");
      end T7;

   begin
      null;
   end StartTasks;
begin
    Put_Line ("Lab7 started");
   StartTasks;
   Put_Line ("Lab7 finished");
end lab7;
