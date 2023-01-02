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
                        if (RecordIDDS1 <> RecordIDDS2) and (RecordIDDS1.TableNo <> RecordIDDS2.TableNo) then
                            SimilarityDict.Add(Format(RecordIDDS1) + ';' + Format(RecordIDDS2), CompareRecords(RecordIDDS1, RecordIDDS2, EMCompareDSFieldMapping));
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
        if (not DS1RecordRef.Get(RecordIDDS1)) or (not DS2RecordRef.Get(RecordIDDS2)) then
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
                exit(GetEditSimilarity(ValueDS1, ValueDS2));
            EMDistanceMethods::Exact:
                exit(GetExactSimilarity(ValueDS1, ValueDS2));
            EMDistanceMethods::Jaccard:
                exit(GetJaccardSimilarity(ValueDS1, ValueDS2));
            EMDistanceMethods::JaroWinkler:
                exit(GetJaroWinklerDistance(ValueDS1, ValueDS2));
        end;
    end;

    procedure GetJaroWinklerDistance(string1: Text; string2: Text): Decimal
    VAR
        Math: Codeunit Math;
        len1, len2 : Integer;
        halflen: Integer;
        i: Integer;
        j: Integer;
        matchingcharacters: Integer;
        transpositions: Integer;
        prefixweight: Decimal;
        distance: Decimal;
    begin
        len1 := StrLen(string1);
        len2 := StrLen(string2);

        if (len1 = 0) or (len2 = 0) then
            exit(0);
        if (string1 = string2) then
            exit(1);

        halflen := Round((Math.Max(len1, len2) / 2) - 1, 0);
        matchingcharacters := 0;
        transpositions := 0;
        for i := 1 to len1 do
            for j := Math.Max(1, i - halflen) to Math.Min(len2, i + halflen) do
                if (string1[i] = string2[j]) then begin
                    matchingcharacters := matchingcharacters + 1;
                    exit;
                end;
        if (matchingcharacters = 0) then
            exit(0);
        i := 1;
        j := 1;
        while (i <= len1) and (j <= len2) do begin
            if (string1[i] = string2[j]) then begin
                i := i + 1;
                j := j + 1;
            end else
                if (string1[i] = string2[j + 1]) and (string1[i + 1] = string2[j]) then begin
                    transpositions := transpositions + 1;
                    i := i + 2;
                    j := j + 2;
                end else begin
                    i := i + 1;
                    j := j + 1;
                end;
        end;
        transpositions := transpositions / 2;
        distance := ((matchingcharacters / len1) + (matchingcharacters / len2) + ((matchingcharacters - transpositions) / matchingcharacters)) / 3;
        prefixweight := 0;
        i := 1;
        while (i <= 4) and (i <= Math.Min(len1, len2)) and (string1[i] = string2[i]) do
            i := i + 1;
        prefixweight := i * 0.1;
        exit(distance + prefixweight * (1 - distance));
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
        nGramList2 := CreateNgrams(ValueDS2, 3);

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
        nGramList2 := CreateNgrams(ValueDS2, 3);

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
        Math: Codeunit Math;
        m: Integer;
        n: Integer;
        d: List of [Integer];
        i: Integer;
        j: Integer;
        cost: Integer;
        temp: Integer;
        Value1: Integer;
        Value2: Integer;
    begin
        // Initialize the matrix
        m := StrLen(ValueDS1);
        n := StrLen(ValueDS2);
        if (n = 0) and (m = 0) then
            exit(0);

        if ValueDS1 = ValueDS2 then
            exit(1);

        Clear(d);
        d.AddRange(0, n);
        for i := 1 to m do begin
            d.Get(0, temp);
            d.Insert(0, i);
            for j := 1 to n do begin
                if ValueDS1[i - 1] = ValueDS2[j - 1] then begin
                    cost := 0;
                end
                else begin
                    cost := 1;
                end;
                d.Get(j, Value1);
                d.Get(j - 1, Value2);
                d.Insert(j, Math.Min(Math.Min(Value1 + 1, Value2 + 1), temp + cost));
                d.Get(j, temp);
            end;
        end;
        d.Get(n, cost);
        cost := 1 - (cost / Math.Max(n, m));
        // Return the edit distance
        exit(cost);
    end;

    local procedure CreateNgrams(Value: Text; n: Integer) nGramList: List of [Text];
    var
        i: Integer;
    begin
        Value := Value.PadLeft(n - 1 + StrLen(Value), '#');
        Value := Value.PadRight(n - 1 + StrLen(Value), '#');

        for i := 1 to (StrLen(Value) - (n - 1)) do begin
            nGramList.Add(Value.Substring(i, n));
        end;
    end;

    local procedure CheckIfValuesHaveNoValue(ValueDS1: Text; ValueDS2: Text): Boolean
    begin
        exit((StrLen(ValueDS1) = 0) or (StrLen(ValueDS2) = 0))
    end;
}
