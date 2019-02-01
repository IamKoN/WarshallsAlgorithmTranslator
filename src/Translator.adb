--------------A Option--------------

with Ada.Strings; use Ada.Strings;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

--generic body
package body Translator is
   subtype strLabel is String(1..3);

-- Converts string to enumeration type
   function stringConvEnum is new Unchecked_Conversion(String, enumNode);

-- Input text file can specify allocation of space
   function fileSize return Integer is
      Input: File_Type;
      retFileSize: Integer;
      lineNum: Integer:= 0;
   begin
      Open(Input, In_File, ipName);
      while lineNum /= 1 loop
         declare
            Line: String:= Get_Line(Input);
         begin
            lineNum:= 1;
            retFileSize:= Integer'Value(Line);
         end;
      end loop;
      Close(Input);
      return retFileSize;
   end fileSize;

-- Overlaod of or logical operator
   function "or"(Left, Right: Integer) return Integer is
      type unsignedInt is mod 2**Integer'Size;
   begin
      return Integer(unsignedInt(Left) or unsignedInt(Right));
   end "or";

-- Declare and Initialize Translator variables
   Input, Output: File_Type;
   xNode, yNode: Integer;
   control, N: Integer:= 1;
   fileSize2: Integer:= fileSize;
   realNode: Boolean:= False;
   xName, yName: strLabel:= (others => ' ');

-- Array subscripts (labels for rows & cols) are enumeration type
   arrNode: array (1 .. fileSize2) of enumNode;
   arrLabel: array (1 .. fileSize2) of strLabel:= (others => "   ");
   Matrix: array (1 .. fileSize2, 1 .. fileSize2) of Integer:= (others => (others => 0));

-- Create connections between nodes, initialize node array and label array
   procedure Connect (x: in enumNode; y: in enumNode; xLabel: in String; yLabel : in String) is
   begin
-- Initialize 'x' coordinates and x labels
      for I in 1..N loop
         if realNode = False then
            if I = N then
               xNode := N;
               arrNode(N) := x;
               arrLabel(N) := xLabel;
               N := N + 1;
            elsif arrNode(I) = x then
               realNode := True;
               xNode := I;
            end if;
         end if;
      end loop;
      realNode := False;
-- Initialize 'y' coordinates and y labels
      for I in 1 .. N loop
         if realNode = False then
            if I = N then
               yNode := N;
               arrNode(N) := y;
               arrLabel(N) := yLabel;
               N := N + 1;
            elsif arrNode(I) = y then
               realNode := True;
               yNode := I;
            end if;
         end if;
      end loop;
      realNode := False;
-- Initialize matrix nodes (x,y coordinate sets)
      if xNode = yNode then
         --No node
         Matrix(xNode, yNode) := 0;
      else
         --Node is present
         Matrix(xNode, yNode) := 1;
      end if;
   end;

begin
-- Open Input text file to read
   Open (Input, In_File, ipName);

-- Initialize x and y labels and connect nodes
   while not End_Of_File(Input) loop
      declare
         Line : String := Get_Line (Input);
      begin
         if control = 1 then
            fileSize2:= Integer'Value(Line);
            control:= 2;
         elsif control = 2 then
            xName:= Line;
            control:= 3;
         else
            yName:= Line;
            Connect(stringConvEnum(xName), stringConvEnum(yName), xName, yName);
            control:= 2;
         end if;
      end;
   end loop;
   Close (Input);

   Create (Output, Out_File, opName);
-- Print line and indention before first x label
   New_Line; Put("       ");
   New_Line(Output); Put(Output,"      ");

-- Warshall's algorithm to apply transitive closure
   for I in 1..fileSize2 loop
   -- Print x labels
      Put(arrLabel(I)); Put("   ");
      Put(Output, arrLabel(I)); Put(Output,"   ");
      for J in 1..fileSize2 loop
         if Matrix(J,I) > 0 then
            for K in 1..fileSize2 loop
               Matrix(J,K) := Matrix(J,K) or Matrix(I,K);
            end loop;
         end if;
      end loop;
   end loop;

-- Print matrix to Output file and screen
   for I in 1..fileSize2 loop
   -- Print y labels
      New_Line; Put(arrLabel(I)); Put("    ");
      New_Line(Output); Put(Output, arrLabel(I)); Put(Output,"   ");
      for J in 1..fileSize2 loop
         if Matrix(I,J) > 0 then
            Put("1     "); Put(Output, "1     ");
         else
            Put("0     "); Put(Output, "0     ");
         end if;
      end loop;
   end loop;
   New_Line; New_Line(Output);
   Close(Output);

-- Close files if there is a major error
exception
   when End_Error =>
      if Is_Open(Input) then
         Close (Input);
      end if;
      if Is_Open(Output) then
         Close (Output);
      end if;
end Translator;
