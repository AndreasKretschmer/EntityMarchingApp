codeunit 77000 "EM Management"
{
    TableNo = "EM Compare Datasets";

    trigger OnRun()
    begin
        CompareDatasets(Rec);
    end;

    procedure CompareDatasets(EMCompareDatasets: Record "EM Compare Datasets")
    var
        EMCompareDatasetsFieldMapp: Record "EM Compare DS Field Mapping";
        EMBlockingManagement: Codeunit "EM Blocking Management";
        EMComparisonManagement: Codeunit "EM Comparison Management";
        EMClassificationManagement: Codeunit "EM Classification Management";
        BlockingDictDS1: Dictionary of [Text, List of [RecordId]];
        BlockingDictDS2: Dictionary of [Text, List of [RecordId]];
        SimilarityDict: Dictionary of [Text, List of [Decimal]];
    begin
        EMCompareDatasets.FilterFieldMapping(EMCompareDatasetsFieldMapp);
        if EMCompareDatasets.IsEmpty() then
            exit;

        EMBlockingManagement.StartBlocking(EMCompareDatasets, BlockingDictDS1, BlockingDictDS2);
        SimilarityDict := EMComparisonManagement.CompareBlocks(BlockingDictDS1, BlockingDictDS2, EMCompareDatasets);
        EMClassificationManagement.ClassifyRecordPairs(EMCompareDatasets, SimilarityDict);
    end;
}
