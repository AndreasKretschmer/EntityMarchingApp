codeunit 77020 "EM Initiaize Setup Data"
{
    Subtype = Install;

    trigger OnRun()
    begin
        CreateSoundexBlockingValues();
    end;

    local procedure CreateSoundexBlockingValues()
    begin
        InsertSoundexBlockingValue('b', '1');
        InsertSoundexBlockingValue('f', '1');
        InsertSoundexBlockingValue('p', '1');
        InsertSoundexBlockingValue('v', '1');
        InsertSoundexBlockingValue('c', '2');
        InsertSoundexBlockingValue('g', '2');
        InsertSoundexBlockingValue('j', '2');
        InsertSoundexBlockingValue('k', '2');
        InsertSoundexBlockingValue('q', '2');
        InsertSoundexBlockingValue('s', '2');
        InsertSoundexBlockingValue('x', '2');
        InsertSoundexBlockingValue('z', '2');
        InsertSoundexBlockingValue('d', '3');
        InsertSoundexBlockingValue('t', '3');
        InsertSoundexBlockingValue('l', '4');
        InsertSoundexBlockingValue('m', '5');
        InsertSoundexBlockingValue('n', '5');
        InsertSoundexBlockingValue('r', '6');
    end;

    local procedure InsertSoundexBlockingValue(Character: Text[1]; Value: Text[1])
    var
        EMSoundexBlockingValues: Record "EM Soundex Blocking Values";
    begin
        EMSoundexBlockingValues.Init();
        EMSoundexBlockingValues.Character := Character;
        EMSoundexBlockingValues.Value := Value;
        EMSoundexBlockingValues.Insert(true);
    end;
}
