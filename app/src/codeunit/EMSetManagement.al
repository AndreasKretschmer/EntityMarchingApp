codeunit 77004 "EM Set Management"
{
    procedure GetLenOfUnionOfLists(List1: List of [Text]; List2: List of [Text]) u: Integer
    var
        nGram: Text;
    begin
        u := List1.Count();
        foreach nGram in List2 do
            if not List1.Contains(nGram) then
                u += 1;
    end;

    procedure GetLenOfIntersectionOfLists(List1: List of [Text]; List2: List of [Text]) u: Integer
    var
        nGram: Text;
    begin
        foreach nGram in List1 do
            if List2.Contains(nGram) then
                u += 1;
    end;
}
