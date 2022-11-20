codeunit 77003 "EM Classification Management"
{
    procedure ClassifyRecordPairs(EMCompareDatasets: Record "EM Compare Datasets"; SimilarityDict: Dictionary of [Text, List of [Decimal]])
    begin
        ResetClassificationResults(EMCompareDatasets."Entry No.");
        case EMCompareDatasets."Classification Method" of
            EMCompareDatasets."Classification Method"::Exact:
                ExactClassification(SimilarityDict, EMCompareDatasets."Entry No.");
            EMCompareDatasets."Classification Method"::MinSim:
                MinSimilarityClassification(SimilarityDict, EMCompareDatasets."Classification Threshold", EMCompareDatasets."Entry No.");
            EMCompareDatasets."Classification Method"::Similarity:
                SimilarityClassification(SimilarityDict, EMCompareDatasets."Classification Threshold", EMCompareDatasets."Entry No.");
            EMCompareDatasets."Classification Method"::WeightedSim:
                WeightedSimilarityClassification(SimilarityDict, EMCompareDatasets."Classification Threshold", GetWeightSimVec(EMCompareDatasets), EMCompareDatasets."Entry No.");
        end;
    end;

    local procedure ResetClassificationResults(EntryNo: Integer)
    var
        EMClassificationResult: Record "EM Classification Result";
    begin
        EMClassificationResult.Reset();
        EMClassificationResult.SetRange("Entry No.", EntryNo);
        if not EMClassificationResult.IsEmpty then
            EMClassificationResult.DeleteAll();
    end;

    local procedure ExactClassification(SimilarityDict: Dictionary of [Text, List of [Decimal]]; EntryNo: Integer)
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
                SimilaritySum := 0;
                foreach Sim in SimilarityVecList do
                    SimilaritySum += Sim;

                LogClassificationResult(EntryNo, RecordIdPair, (SimilaritySum = SimilarityVecList.Count), SimilaritySum, 1, Enum::"EM Classification Method"::Exact);
            end;
    end;

    local procedure MinSimilarityClassification(SimilarityDict: Dictionary of [Text, List of [Decimal]]; Threshold: Decimal; EntryNo: Integer)
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

                LogClassificationResult(EntryNo, RecordIdPair, Match, Sim, Threshold, Enum::"EM Classification Method"::MinSim);
            end;
        end;
    end;

    local procedure SimilarityClassification(SimilarityDict: Dictionary of [Text, List of [Decimal]]; Threshold: Decimal; EntryNo: Integer)
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
                SimilaritySum := 0;
                foreach Sim in SimilarityVecList do
                    SimilaritySum += Sim;

                LogClassificationResult(EntryNo, RecordIdPair, (SimilaritySum / SimilarityVecList.Count) >= Threshold, (SimilaritySum / SimilarityVecList.Count), Threshold, Enum::"EM Classification Method"::Similarity);
            end;
    end;

    local procedure WeightedSimilarityClassification(SimilarityDict: Dictionary of [Text, List of [Decimal]]; Threshold: Decimal; WeightSimVec: List of [Decimal]; EntryNo: Integer)
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
                SimilaritySum := 0;
                for i := 0 to SimilarityVecList.Count do begin
                    WeightSimVec.Get(i, Weight);
                    SimilarityVecList.Get(i, Sim);
                    SimilaritySum += (sim * Weight);
                end;

                LogClassificationResult(EntryNo, RecordIdPair, (SimilaritySum / WeightVecSum) >= Threshold, SimilaritySum / WeightVecSum, Threshold, Enum::"EM Classification Method"::WeightedSim);
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
                    GetUniqueValuesForTableAndField(EMCompareDatasets."Dataset 2 Table No.", EMCompareDSFieldMapping."Dataset 2 Field No.")), 2);
                EMCompareDSFieldMapping.Modify();
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

    local procedure LogClassificationResult(EntryNo: Integer; RecordIdDS1: RecordId; RecordIDDS2: RecordId; IsMatch: Boolean; Sim: Decimal; Threshold: Decimal; ClassificationMethod: Enum "EM Classification Method")
    var
        EMClassificationResult: Record "EM Classification Result";
    begin
        EMClassificationResult.Init();
        EMClassificationResult."Compare Dataset Entry No." := EntryNo;
        EMClassificationResult."RecordID Dataset 1" := RecordIdDS1;
        EMClassificationResult."RecordID Dataset 2" := RecordIdDS2;
        EMClassificationResult.Match := IsMatch;
        EMClassificationResult."Calculated Similarity" := Sim;
        EMClassificationResult.Threshold := Threshold;
        EMClassificationResult."Classification Method" := ClassificationMethod;
        EMClassificationResult.Insert(true);
    end;

    local procedure LogClassificationResult(EntryNo: Integer; RecordIdPairText: Text; IsMatch: Boolean; Sim: Decimal; Threshold: Decimal; ClassificationMethod: Enum "EM Classification Method")
    var
        RecordIDList: List of [Text];
        RecordIDText: Text;
        RecordIdDS1: RecordId;
        RecordIdDS2: RecordId;
    begin
        RecordIDList := RecordIdPairText.Split(';');
        RecordIDList.Get(1, RecordIDText);
        Evaluate(RecordIdDS1, RecordIDText);
        RecordIDList.Get(2, RecordIDText);
        Evaluate(RecordIdDS2, RecordIDText);
        LogClassificationResult(EntryNo, RecordIdDS1, RecordIdDS2, IsMatch, Sim, Threshold, ClassificationMethod);
    end;
}
