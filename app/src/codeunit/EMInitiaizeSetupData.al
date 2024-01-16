codeunit 77020 "EM Initiaize Setup Data"
{
    Subtype = Install;

    trigger OnRun()
    begin
        ResetAllSetupTables();
        CreateSoundexBlockingValuesEN();
        CreateSoundexBlockingValuesDE();
        ImportExampleData();
        CreateSampleSetup();
    end;

    local procedure CreateSoundexBlockingValuesEN()
    begin
        InsertSoundexBlockingValue('b', '1', 'EN');
        InsertSoundexBlockingValue('f', '1', 'EN');
        InsertSoundexBlockingValue('p', '1', 'EN');
        InsertSoundexBlockingValue('v', '1', 'EN');
        InsertSoundexBlockingValue('c', '2', 'EN');
        InsertSoundexBlockingValue('g', '2', 'EN');
        InsertSoundexBlockingValue('j', '2', 'EN');
        InsertSoundexBlockingValue('k', '2', 'EN');
        InsertSoundexBlockingValue('q', '2', 'EN');
        InsertSoundexBlockingValue('s', '2', 'EN');
        InsertSoundexBlockingValue('x', '2', 'EN');
        InsertSoundexBlockingValue('z', '2', 'EN');
        InsertSoundexBlockingValue('d', '3', 'EN');
        InsertSoundexBlockingValue('t', '3', 'EN');
        InsertSoundexBlockingValue('l', '4', 'EN');
        InsertSoundexBlockingValue('m', '5', 'EN');
        InsertSoundexBlockingValue('n', '5', 'EN');
        InsertSoundexBlockingValue('r', '6', 'EN');
    end;

    local procedure CreateSoundexBlockingValuesDE()
    begin
        InsertSoundexBlockingValue('b', '1', '');
        InsertSoundexBlockingValue('f', '1', '');
        InsertSoundexBlockingValue('p', '1', '');
        InsertSoundexBlockingValue('v', '1', '');
        InsertSoundexBlockingValue('w', '1', '');
        InsertSoundexBlockingValue('v', '1', '');
        InsertSoundexBlockingValue('c', '2', '');
        InsertSoundexBlockingValue('g', '2', '');
        InsertSoundexBlockingValue('x', '2', '');
        InsertSoundexBlockingValue('k', '2', '');
        InsertSoundexBlockingValue('q', '2', '');
        InsertSoundexBlockingValue('s', '2', '');
        InsertSoundexBlockingValue('ß', '2', '');
        InsertSoundexBlockingValue('z', '2', '');
        InsertSoundexBlockingValue('z', '2', '');
        InsertSoundexBlockingValue('d', '3', '');
        InsertSoundexBlockingValue('t', '3', '');
        InsertSoundexBlockingValue('l', '4', '');
        InsertSoundexBlockingValue('m', '5', '');
        InsertSoundexBlockingValue('n', '5', '');
        InsertSoundexBlockingValue('r', '6', '');
        InsertSoundexBlockingValue('$', '7', ''); //$ represents the ch
    end;

    local procedure InsertSoundexBlockingValue(Character: Text[1]; Value: Text[1]; LanguageCode: Code[20])
    var
        EMSoundexBlockingValues: Record "EM Soundex Blocking Values";
    begin
        if EMSoundexBlockingValues.Get(Character) then
            exit;

        EMSoundexBlockingValues.Init();
        EMSoundexBlockingValues.Character := Character;
        EMSoundexBlockingValues.Value := Value;
        EMSoundexBlockingValues."Language Code" := LanguageCode;
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
        EMCompareDatasets."Dataset 1 Table No." := Database::"EM Example Dataset 1";
        EMCompareDatasets."Dataset 2 Table No." := Database::"EM Example Dataset 2";
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
