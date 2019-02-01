--------------A Option--------------

--generic instantiations of packages
generic
-- Pass Enumeration type as a generic parameter
   type enumNode is private; --node name
   
-- Pass I/O routines as generic parameters
   with procedure Put(x: enumNode);
 
-- Input and output file names
   ipName, opName: String;
   
package Translator is
   function fileSize return Integer;
   function "or"(Left, Right: Integer) return Integer;
   procedure Connect(x:in enumNode; y:in enumNode; xLabel:in String; yLabel:in String);
end Translator;
