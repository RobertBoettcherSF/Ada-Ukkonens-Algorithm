with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

-- Package: Ukkonen
-- Description: Implementation of Ukkonen's Algorithm for Suffix Tree Construction.
-- Note on Variants: Ukkonen's algorithm is an *online* string algorithm, meaning 
-- it processes string dynamically character by character (Dynamic/Online variant). 
-- Preemptive/Non-preemptive variants apply to CPU schedulers, not string algorithms. 
-- However, we implement both the Online (incremental) variant and provide 
-- structural boundaries for Static validation (via Contains_Substring).
package Ukkonen is
   type Suffix_Tree is private;

   -- Custom Exceptions
   Invalid_Input : exception;

   -- Core API
   -- Initializes and constructs a full suffix tree from a string (Static usage pattern)
   function Build_Suffix_Tree (Text : String) return Suffix_Tree;
   
   -- Helper variant: Verifies if a substring exists in O(m) time
   function Contains_Substring (Tree : Suffix_Tree; Substr : String) return Boolean;

private
   use Ada.Strings.Unbounded;

   -- Node indexing and unbounded limits
   type Node_Index is new Integer;
   Null_Node : constant Node_Index := 0;
   Infinity  : constant Integer := Integer'Last;

   -- Array for O(1) character lookups, representing ASCII edges
   type Children_Array is array (Character'Val (0) .. Character'Val (127)) of Node_Index;

   -- Node Structure for Suffix Tree
   type Node is record
      Start_Index : Integer := 1;
      End_Index   : Integer := Infinity;
      Suffix_Link : Node_Index := Null_Node;
      Children    : Children_Array := (others => Null_Node);
   end record;

   -- Vector to handle dynamically sized trees (Online variant capability)
   package Node_Vectors is new Ada.Containers.Vectors (
      Index_Type   => Node_Index,
      Element_Type => Node
   );

   -- Main state structure for Ukkonen's online construction
   type Suffix_Tree is record
      Text          : Unbounded_String;
      Nodes         : Node_Vectors.Vector;
      Root          : Node_Index := Null_Node;
      Active_Node   : Node_Index := Null_Node;
      Active_Edge   : Integer := 0;
      Active_Length : Integer := 0;
      Remainder     : Integer := 0;
      Current_Phase : Integer := 0;
   end record;

end Ukkonen;
