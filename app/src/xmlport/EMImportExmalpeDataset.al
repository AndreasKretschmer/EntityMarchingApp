xmlport 77000 "EM Import Exmalpe Dataset"
{
    Caption = 'Import Exmalpe Dataset';
    FieldDelimiter = '<,>';
    Format = VariableText;
    Direction = Import;
    FieldSeparator = '<None>';
    UseRequestPage = false;
    RecordSeparator = '<LF>';
    TableSeparator = '<None>';

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(EMExampleDataset1; Integer)
            {
                AutoSave = false;
                AutoReplace = false;
                AutoUpdate = false;
                textelement(Line)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    EMExampleDataset1: Record "EM Example Dataset 1";
                    Params: List Of [Text];
                    ListValue: Text;
                begin
                    If FirstLine then begin
                        FirstLine := false;
                        currXMLport.Skip();
                    end;

                    Params := Line.Split(','); //propertie seperator does not seperates the values as expected -> Workaround

                    EMExampleDataset1.Init();
                    Params.Get(1, ListValue);
                    EMExampleDataset1.Code := ListValue;
                    Params.Get(2, ListValue);
                    EMExampleDataset1."First Name" := ListValue;
                    Params.Get(3, ListValue);
                    EMExampleDataset1."Middle Name" := ListValue;
                    Params.Get(4, ListValue);
                    EMExampleDataset1."Last Name" := ListValue;
                    Params.Get(5, ListValue);
                    EMExampleDataset1.Gender := ListValue;
                    Params.Get(7, ListValue);
                    EMExampleDataset1."Birth Date" := ListValue;
                    Params.Get(6, ListValue);
                    Evaluate(EMExampleDataset1.Age, ListValue);
                    Params.Get(8, ListValue);
                    EMExampleDataset1.Address := ListValue;
                    Params.Get(9, ListValue);
                    EMExampleDataset1."Address 2" := ListValue;
                    Params.Get(10, ListValue);
                    EMExampleDataset1.County := ListValue;
                    Params.Get(11, ListValue);
                    EMExampleDataset1."Post Code" := ListValue;
                    Params.Get(12, ListValue);
                    EMExampleDataset1."Phone No." := ListValue;
                    Params.Get(13, ListValue);
                    EMExampleDataset1."E-Mail" := ListValue;
                    EMExampleDataset1.Insert();
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    var
        EMExampleDataset1: Record "EM Example Dataset 1";
    begin
        EMExampleDataset1.Reset();
        EMExampleDataset1.DeleteAll();

        FirstLine := true;
    end;

    var
        FirstLine: Boolean;
}
