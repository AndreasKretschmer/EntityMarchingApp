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
        ProgressDialog: Codeunit "Progress Dialog";
        BlockingDictDS1: Dictionary of [Text, List of [RecordId]];
        BlockingDictDS2: Dictionary of [Text, List of [RecordId]];
        SimilarityDict: Dictionary of [Text, List of [Decimal]];
        dia: Dialog;
    begin
        dia.Open('Start Entity Matching: #1');
        EMCompareDatasets.FilterFieldMapping(EMCompareDatasetsFieldMapp);
        if EMCompareDatasets.IsEmpty() then
            exit;
        dia.Update(1, 'Blocking');
        EMBlockingManagement.StartBlocking(EMCompareDatasets, BlockingDictDS1, BlockingDictDS2);
        dia.Update(1, 'Comparing');
        SimilarityDict := EMComparisonManagement.CompareBlocks(BlockingDictDS1, BlockingDictDS2, EMCompareDatasets);
        dia.Update(1, 'Classification');
        EMClassificationManagement.ClassifyRecordPairs(EMCompareDatasets, SimilarityDict);
        dia.Close();
    end;
}
