codeunit 77020 "EM Initiaize Setup Data"
{
    Subtype = Install;

    trigger OnRun()
    begin
        ResetAllSetupTables();
        CreateSoundexBlockingValues();
        ImportExampleData();
        CreateSampleSetup();
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
        if EMSoundexBlockingValues.Get(Character) then
            exit;

        EMSoundexBlockingValues.Init();
        EMSoundexBlockingValues.Character := Character;
        EMSoundexBlockingValues.Value := Value;
        EMSoundexBlockingValues.Insert(true);
    end;

    local procedure ImportExampleData()
    var
        ImportDS1: XmlPort "EM Import Exmalpe Dataset";
        ImportDS2: XmlPort "EM Import Exmalpe Dataset 2";
    begin
        If not GuiAllowed then
            exit;

        ImportDS1.Run();
        Commit();
        ImportDS2.Run();
    end;

    local procedure CreateSampleSetup()
    var
        EMCompareDatasets: Record "EM Compare Datasets";
    begin
        EMCompareDatasets.Init();
        EMCompareDatasets."Entry No." := 1;
        EMCompareDatasets."Dataset 1 Table No." := 77005;
        EMCompareDatasets."Dataset 2 Table No." := 77006;
        EMCompareDatasets."Blocking Method" := Enum::"EM Blocking Method"::Soundex;
        EMCompareDatasets."Classification Method" := Enum::"EM Classification Method"::Similarity;
        EMCompareDatasets."Classification Threshold" := 0.8;
        EMCompareDatasets.Insert(true);

        InsertSampleCompareDSFieldMapping(EMCompareDatasets, 2);
        InsertSampleCompareDSFieldMapping(EMCompareDatasets, 4);
    end;

    local procedure InsertSampleCompareDSFieldMapping(EMCompareDatasets: Record "EM Compare Datasets"; FieldNo: Integer)
    var
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
    begin
        EMCompareDSFieldMapping.Init();
        EMCompareDSFieldMapping."Compare Dataset Entry No." := EMCompareDatasets."Entry No.";
        EMCompareDSFieldMapping."Dataset 1 Table No." := EMCompareDatasets."Dataset 1 Table No.";
        EMCompareDSFieldMapping."Dataset 2 Table No." := EMCompareDatasets."Dataset 2 Table No.";
        EMCompareDSFieldMapping."Dataset 1 Field No." := FieldNo;
        EMCompareDSFieldMapping."Dataset 2 Field No." := FieldNo;
        EMCompareDSFieldMapping."Distance Method" := Enum::"EM Distance Methods"::Jaccard;
        EMCompareDSFieldMapping.Insert(true)
    end;

    local procedure ResetAllSetupTables()
    var
        EMCompareDatasets: Record "EM Compare Datasets";
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
        EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
        EMSoundexBlockingValues: Record "EM Soundex Blocking Values";
    begin
        EMCompareDatasets.Reset();
        EMCompareDatasets.DeleteAll();

        EMCompareDSFieldMapping.Reset();
        EMCompareDSFieldMapping.DeleteAll();

        EMCompareDSBlockingBuff.Reset();
        EMCompareDSBlockingBuff.DeleteAll();

        EMSoundexBlockingValues.Reset();
        EMSoundexBlockingValues.DeleteAll();
    end;
}
