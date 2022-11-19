codeunit 77002 "EM Comparison Management"
{
    procedure CompareBlocks(BlockingDictDS1: Dictionary of [Text, List of [RecordId]]; BlockingDictDS2: Dictionary of [Text, List of [RecordId]]; EMCompareDatasets: Record "EM Compare Datasets") SimilarityDict: Dictionary of [Text, List of [Decimal]];
    var
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
        BlockKey: Text;
        RecordIdListDS1: List of [RecordId];
        RecordIdListDS2: List of [RecordId];
        RecordIDDS1: RecordId;
        RecordIDDS2: RecordId;
    begin
        EMCompareDatasets.FilterFieldMappingSimilarity(EMCompareDSFieldMapping);
        foreach BlockKey in BlockingDictDS1.Keys do
            if BlockingDictDS2.ContainsKey(BlockKey) then begin
                BlockingDictDS1.Get(BlockKey, RecordIdListDS1);
                BlockingDictDS2.Get(BlockKey, RecordIdListDS2);
                foreach RecordIDDS1 in RecordIdListDS1 do
                    foreach RecordIDDS2 in RecordIdListDS2 do
                        SimilarityDict.Add(Format(RecordIDDS1) + Format(RecordIDDS2), CompareRecords(RecordIDDS1, RecordIDDS2, EMCompareDSFieldMapping));
            end;
    end;

    local procedure CompareRecords(RecordIDDS1: RecordId; RecordIDDS2: RecordId; var EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping") SimmiliarityList: List of [Decimal]
    var
        DS1RecordRef: RecordRef;
        DS2RecordRef: RecordRef;
        ValueDS1: Text;
        ValueDS2: Text;
    begin
        Clear(SimmiliarityList);
        if (not DS1RecordRef.Get(RecordIDDS1)) and (not DS2RecordRef.Get(RecordIDDS2)) then
            exit;

        if EMCompareDSFieldMapping.FindSet() then
            repeat
                ValueDS1 := Format(DS1RecordRef.Field(EMCompareDSFieldMapping."Dataset 1 Field No.").Value);
                ValueDS2 := Format(DS2RecordRef.Field(EMCompareDSFieldMapping."Dataset 2 Field No.").Value);

                SimmiliarityList.Add(GetSimilarityForDistanceMethod(EMCompareDSFieldMapping."Distance Method", ValueDS1, ValueDS2));
            until EMCompareDSFieldMapping.Next() = 0;
    end;

    local procedure GetSimilarityForDistanceMethod(EMDistanceMethods: Enum "EM Distance Methods"; ValueDS1: Text; ValueDS2: Text): Decimal
    begin
        case EMDistanceMethods of
            EMDistanceMethods::Bag:
                exit(GetBagSimilarity(ValueDS1, ValueDS2));
            EMDistanceMethods::Dice:
                exit(GetDiceSimilarity(ValueDS1, ValueDS2));
            EMDistanceMethods::Edit:
                exit(GetEditSimilarity(ValueDS1, ValueDS2)); //TODO
            EMDistanceMethods::Exact:
                exit(GetExactSimilarity(ValueDS1, ValueDS2));
            EMDistanceMethods::Jaccard:
                exit(GetJaccardSimilarity(ValueDS1, ValueDS2));
            EMDistanceMethods::JaroWinkler:
                ; //TODO
        end;
    end;

    local procedure GetExactSimilarity(ValueDS1: Text; ValueDS2: Text): Decimal
    begin
        if CheckIfValuesHaveNoValue(ValueDS1, ValueDS2) then
            exit(0);

        if ValueDS1 <> ValueDS2 then
            exit(0)
        else
            exit(1);
    end;

    local procedure GetJaccardSimilarity(ValueDS1: Text; ValueDS2: Text): Decimal
    var
        EMSetManagement: Codeunit "EM Set Management";
        nGramList1: List of [Text];
        nGramList2: List of [Text];
        i: Integer;
        u: Integer;
    begin
        if CheckIfValuesHaveNoValue(ValueDS1, ValueDS2) then
            exit(0);

        if ValueDS1 = ValueDS2 then
            exit(1);

        nGramList1 := CreateNgrams(ValueDS1, 3);
        nGramList2 := CreateNgrams(ValueDS1, 3);

        i := EMSetManagement.GetLenOfIntersectionOfLists(nGramList1, nGramList2);
        u := EMSetManagement.GetLenOfUnionOfLists(nGramList1, nGramList2);

        exit(i / u);
    end;

    local procedure GetDiceSimilarity(ValueDS1: Text; ValueDS2: Text): Decimal
    var
        EMSetManagement: Codeunit "EM Set Management";
        nGramList1: List of [Text];
        nGramList2: List of [Text];
        i: Integer;
        u: Integer;
    begin
        if CheckIfValuesHaveNoValue(ValueDS1, ValueDS2) then
            exit(0);

        if ValueDS1 = ValueDS2 then
            exit(1);

        nGramList1 := CreateNgrams(ValueDS1, 3);
        nGramList2 := CreateNgrams(ValueDS1, 3);

        i := EMSetManagement.GetLenOfIntersectionOfLists(nGramList1, nGramList2);

        exit(2 * i / (nGramList1.Count + nGramList2.Count));
    end;

    local procedure GetBagSimilarity(ValueDS1: Text; ValueDS2: Text): Decimal
    var
        n: Integer;
        b: Integer;
        List1: List of [Text];
        List2: List of [Text];
        CharText: Text;
    begin
        if CheckIfValuesHaveNoValue(ValueDS1, ValueDS2) then
            exit(0);

        if ValueDS1 = ValueDS2 then
            exit(1);

        if StrLen(ValueDS1) >= StrLen(ValueDS2) then
            n := StrLen(ValueDS1)
        else
            n := StrLen(ValueDS2);

        List1 := ValueDS1.Split();
        List2 := ValueDS2.Split();

        foreach CharText in List1 do
            if List2.Contains(CharText) then
                List2.Remove(CharText);

        foreach CharText in List2 do
            if List1.Contains(CharText) then
                List1.Remove(CharText);

        if List1.Count >= List2.Count then
            b := List1.Count
        else
            b := List2.Count;

        exit((1 - b) / n)
    end;

    local procedure GetEditSimilarity(ValueDS1: Text; ValueDS2: Text): Decimal
    var
        n: Integer;
        m: Integer;
        List1: List of [Text];
        List2: List of [Text];
        CharText: Text;
    begin
        if CheckIfValuesHaveNoValue(ValueDS1, ValueDS2) then
            exit(0);

        if ValueDS1 = ValueDS2 then
            exit(1);

        n := StrLen(ValueDS1);
        m := StrLen(ValueDS2);

    end;

    local procedure CreateNgrams(Value: Text; n: Integer) nGramList: List of [Text];
    var
        i: Integer;
    begin
        Value := Value.PadLeft(n - 1, '#');
        Value := Value.PadRight(n - 1, '#');

        for i := 0 to (StrLen(Value) - (n - 1)) do begin
            nGramList.Add(Value.Substring(i, n));
        end;
    end;

    local procedure CheckIfValuesHaveNoValue(ValueDS1: Text; ValueDS2: Text): Boolean
    begin
        exit((StrLen(ValueDS1) = 0) or (StrLen(ValueDS2) = 0))
    end;
}
