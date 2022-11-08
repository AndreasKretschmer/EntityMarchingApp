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
    begin
        EMCompareDatasets.FilterFieldMapping(EMCompareDatasetsFieldMapp);
        if EMCompareDatasets.IsEmpty() then
            exit;

        EMBlockingManagement.StartBlocking(EMCompareDatasets);
    end;
}
