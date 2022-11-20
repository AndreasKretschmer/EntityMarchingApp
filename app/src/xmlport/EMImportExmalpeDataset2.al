xmlport 77001 "EM Import Exmalpe Dataset 2"
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
            tableelement(EMExampleDataset2; Integer)
            {
                AutoSave = false;
                AutoReplace = false;
                AutoUpdate = false;
                textelement(Line)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    EMExampleDataset2: Record "EM Example Dataset 2";
                    Params: List Of [Text];
                    ListValue: Text;
                begin
                    If FirstLine then begin
                        FirstLine := false;
                        currXMLport.Skip();
                    end;

                    Params := Line.Split(','); //propertie seperator does not seperates the values as expected -> Workaround

                    EMExampleDataset2.Init();
                    Params.Get(1, ListValue);
                    EMExampleDataset2.Code := ListValue;
                    Params.Get(2, ListValue);
                    EMExampleDataset2."First Name" := ListValue;
                    Params.Get(3, ListValue);
                    EMExampleDataset2."Middle Name" := ListValue;
                    Params.Get(4, ListValue);
                    EMExampleDataset2."Last Name" := ListValue;
                    Params.Get(5, ListValue);
                    EMExampleDataset2.Gender := ListValue;
                    Params.Get(7, ListValue);
                    EMExampleDataset2."Birth Date" := ListValue;
                    Params.Get(6, ListValue);
                    Evaluate(EMExampleDataset2.Age, ListValue);
                    Params.Get(8, ListValue);
                    EMExampleDataset2.Address := ListValue;
                    Params.Get(9, ListValue);
                    EMExampleDataset2."Address 2" := ListValue;
                    Params.Get(10, ListValue);
                    EMExampleDataset2.County := ListValue;
                    Params.Get(11, ListValue);
                    EMExampleDataset2."Post Code" := ListValue;
                    Params.Get(12, ListValue);
                    EMExampleDataset2."Phone No." := ListValue;
                    Params.Get(13, ListValue);
                    EMExampleDataset2."E-Mail" := ListValue;
                    EMExampleDataset2.Insert();
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    var
        EMExampleDataset2: Record "EM Example Dataset 2";
    begin
        EMExampleDataset2.Reset();
        EMExampleDataset2.DeleteAll();

        FirstLine := true;
    end;

    var
        FirstLine: Boolean;
}
