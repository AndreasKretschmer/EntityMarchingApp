codeunit 77003 "EM Classification Management"
{
    procedure ClassifyRecordPairs(EMCompareDatasets: Record "EM Compare Datasets"; SimilarityDict: Dictionary of [Text, List of [Decimal]])
    begin
        case EMCompareDatasets."Classification Method" of
            EMCompareDatasets."Classification Method"::Exact:
                ExactClassification(SimilarityDict);
            EMCompareDatasets."Classification Method"::MinSim:
                MinSimilarityClassification(SimilarityDict, 0.8);
            EMCompareDatasets."Classification Method"::Similarity:
                SimilarityClassification(SimilarityDict, 0.8);
            EMCompareDatasets."Classification Method"::WeightedSim:
                WeightedSimilarityClassification(SimilarityDict, 0.8, GetWeightSimVec(EMCompareDatasets));
        end;
    end;

    local procedure ExactClassification(SimilarityDict: Dictionary of [Text, List of [Decimal]])
    var
        RecordIdPairList: List of [Text];
        SimilarityVecList: List of [Decimal];
        RecordIdPair: Text;
        SimilaritySum: Decimal;
        Sim: Decimal;
    begin
        RecordIdPairList := SimilarityDict.Keys;
        foreach RecordIdPair in RecordIdPairList do
            if SimilarityDict.Get(RecordIdPair, SimilarityVecList) then begin
                foreach Sim in SimilarityVecList do
                    SimilaritySum += Sim;

                if SimilaritySum = SimilarityVecList.Count then
                    exit; //TODO 
            end;
    end;

    local procedure MinSimilarityClassification(SimilarityDict: Dictionary of [Text, List of [Decimal]]; Threshold: Decimal)
    var
        RecordIdPairList: List of [Text];
        SimilarityVecList: List of [Decimal];
        RecordIdPair: Text;
        Sim: Decimal;
        Match: Boolean;
    begin
        RecordIdPairList := SimilarityDict.Keys;
        foreach RecordIdPair in RecordIdPairList do begin
            Match := true;
            if SimilarityDict.Get(RecordIdPair, SimilarityVecList) then begin
                foreach Sim in SimilarityVecList do
                    if Sim >= Threshold then
                        Match := (Sim >= Threshold) and Match;

                if Match then
                    exit; //TODO mark as match
            end;
        end;
    end;

    local procedure SimilarityClassification(SimilarityDict: Dictionary of [Text, List of [Decimal]]; Threshold: Decimal)
    var
        RecordIdPairList: List of [Text];
        SimilarityVecList: List of [Decimal];
        RecordIdPair: Text;
        SimilaritySum: Decimal;
        Sim: Decimal;
    begin
        RecordIdPairList := SimilarityDict.Keys;
        foreach RecordIdPair in RecordIdPairList do
            if SimilarityDict.Get(RecordIdPair, SimilarityVecList) then begin
                foreach Sim in SimilarityVecList do
                    SimilaritySum += Sim;

                if (SimilaritySum / SimilarityVecList.Count) >= Threshold then
                    exit; //TODO mark as match
            end;
    end;

    local procedure WeightedSimilarityClassification(SimilarityDict: Dictionary of [Text, List of [Decimal]]; Threshold: Decimal; WeightSimVec: List of [Decimal])
    var
        RecordIdPairList: List of [Text];
        SimilarityVecList: List of [Decimal];
        RecordIdPair: Text;
        SimilaritySum: Decimal;
        WeightVecSum: Decimal;
        Weight: Decimal;
        Sim: Decimal;
        i: Integer;
    begin
        RecordIdPairList := SimilarityDict.Keys;
        foreach Weight in WeightSimVec do
            WeightVecSum += Weight;

        foreach RecordIdPair in RecordIdPairList do
            if SimilarityDict.Get(RecordIdPair, SimilarityVecList) then begin
                for i := 0 to SimilarityVecList.Count do
                    WeightSimVec.Get(i, Weight);
                SimilarityVecList.Get(i, Sim);
                SimilaritySum += (sim * Weight);

                if (SimilaritySum / WeightVecSum) >= Threshold then
                    exit; //TODO mark as match
            end;
    end;

    local procedure GetWeightSimVec(EMCompareDatasets: Record "EM Compare Datasets") WeightSimVec: List of [Decimal]
    var
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
    begin
        EMCompareDatasets.FilterFieldMappingSimilarity(EMCompareDSFieldMapping);
        if EMCompareDSFieldMapping.FindSet() then
            repeat
                WeightSimVec.Add(EMCompareDSFieldMapping."Weighted Similarity");
            until EMCompareDSFieldMapping.Next() = 0;
    end;

    procedure CalculateWeightSimVec(EMCompareDatasets: Record "EM Compare Datasets")
    var
        EMCompareDSFieldMapping: Record "EM Compare DS Field Mapping";
        EMSetManagement: Codeunit "EM Set Management";
        Math: Codeunit Math;
        SourceRecordRef: RecordRef;
    begin
        EMCompareDatasets.FilterFieldMappingSimilarity(EMCompareDSFieldMapping);
        if EMCompareDSFieldMapping.FindSet() then
            repeat
                EMCompareDSFieldMapping."Weighted Similarity" := Math.Log(EMSetManagement.GetLenOfUnionOfLists(
                    GetUniqueValuesForTableAndField(EMCompareDatasets."Dataset 1 Table No.", EMCompareDSFieldMapping."Dataset 1 Field No."),
                    GetUniqueValuesForTableAndField(EMCompareDatasets."Dataset 2 Table No.", EMCompareDSFieldMapping."Dataset 2 Field No.")));
            until EMCompareDSFieldMapping.Next() = 0;
    end;

    local procedure GetUniqueValuesForTableAndField(TableNo: Integer; FieldNo: Integer) UniqueValueList: List of [Text]
    var
        SourceRecordRef: RecordRef;
        FieldValue: Text;
    begin
        SourceRecordRef.Open(TableNo);
        if SourceRecordRef.FindSet() then
            repeat
                FieldValue := Format(SourceRecordRef.Field(FieldNo).Value);
                if not UniqueValueList.Contains(FieldValue) then
                    UniqueValueList.Add(FieldValue);
            until SourceRecordRef.Next() = 0;
    end;
}
