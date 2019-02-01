--------------A Option--------------

with Ada.Text_Io;
with Translator;
procedure runTranslator is

-- Instantiate string IO routine and execute for A String Data
   subtype strLabel is String (1..3);
   procedure putString(x: strLabel) is
   begin      Ada.Text_Io.Put(x);   end;
   package aStringData is new Translator(strLabel, putString, "aString2.txt", "aStringOut.txt"); use aStringData;
   
-- Instantiate int IO routine and execute for A Interger Data
   package IntIO is new Ada.Text_Io.Integer_Io(Integer); use IntIO;
   procedure putInt (x: Integer) is
   begin      IntIO.Put(x);   end;
   package aIntData is new Translator(Integer, putInt, "aInteger.txt", "aIntegerOut.txt"); use aIntData;
   
-- Instantiate character IO routine and execute for B and C Options
   subtype charLabel is String (1..1);
   procedure putChar(x: charLabel) is
   begin      Ada.Text_Io.Put(x);   end;
   package bCharData is new Translator(charLabel, putChar, "bChar.txt", "bCharOut.txt"); use bCharData;
   package cCharData is new Translator(charLabel, putChar, "cChar.txt", "cCharOut.txt"); use cCharData;

begin
   null;
end runTranslator;
