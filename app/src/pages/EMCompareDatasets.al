page 77001 "EM Compare Datasets"
{
    ApplicationArea = All;
    Caption = 'Compare Datasets';
    PageType = List;
    SourceTable = "EM Compare Datasets";
    UsageCategory = Tasks;
    PromotedActionCategories = 'New,Process,Report,Import,Navigation';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Dataset 1 Table No."; Rec."Dataset 1 Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset 1 Table No. field.';
                }
                field("DataSet 1 Table Name"; Rec."DataSet 1 Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DataSet 1 Table Name field.';
                }
                field("Dataset 2 Table No."; Rec."Dataset 2 Table No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset 2 Table No. field.';
                }
                field("Dataset 2 Table Name"; Rec."Dataset 2 Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dataset 2 Table Name field.';
                }
                field("Blocking Method"; Rec."Blocking Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocking Method field.';
                }
                field("Classification Method"; Rec."Classification Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Classification Method field.';
                }
                field("Classification Threshold"; Rec."Classification Threshold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Classification Threshold field.';
                }
            }
            part(FieldMapping; "EM Compare DS Field Mappings")
            {
                ApplicationArea = all;
                SubPageLink = "Compare Dataset Entry No." = field("Entry No."), "Dataset 1 Table No." = field("Dataset 1 Table No."), "Dataset 2 Table No." = field("Dataset 2 Table No.");
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Blocking Buffer")
            {
                ApplicationArea = All;
                Caption = 'Blocking Buffer';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Image = BulletList;

                trigger OnAction()
                var
                    EMCompareDSBlockingBuff: Record "EM Compare DS Blocking Buff.";
                    EMCompareDSBlockingBuffer: Page "EM Compare DS Blocking Buffer";
                begin
                    EMCompareDSBlockingBuff.Reset();
                    EMCompareDSBlockingBuff.SetRange("Blocking Method", Rec."Blocking Method");
                    EMCompareDSBlockingBuff.SetFilter("Dataset Table No.", '%1|%2', Rec."Dataset 1 Table No.", Rec."Dataset 2 Table No.");

                    Clear(EMCompareDSBlockingBuffer);
                    EMCompareDSBlockingBuffer.SetTableView(EMCompareDSBlockingBuff);
                    EMCompareDSBlockingBuffer.Run();
                end;
            }

            action("Field Mappings")
            {
                ApplicationArea = All;
                Caption = 'Field Mappings';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Image = BulletList;
                RunObject = page "EM Compare DS Field Mappings";
                RunPageLink = "Compare Dataset Entry No." = field("Entry No."), "Dataset 1 Table No." = field("Dataset 1 Table No."), "Dataset 2 Table No." = field("Dataset 2 Table No.");
                RunPageMode = Edit;
            }

            action("SLK Field Setup")
            {
                ApplicationArea = All;
                Caption = 'SLK Field Setup';
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Image = BulletList;
                RunObject = page "EM SLK Field Setup Card";
                RunPageMode = Create;
            }

            action("Example Dataset 1")
            {
                ApplicationArea = All;
                Caption = 'Example Dataset 1';
                Image = ExpandAll;
                RunObject = page "EM Example Dataset 1";
                RunPageMode = View;
            }
            action("Example Dataset 2")
            {
                ApplicationArea = All;
                Caption = 'Example Dataset 2';
                Image = ExpandAll;
                RunObject = page "EM Example Dataset 2";
                RunPageMode = View;
            }
        }


        area(Processing)
        {
            action(Process)
            {
                ApplicationArea = All;
                Caption = 'Process';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Process;

                trigger OnAction()
                var
                    EMManagement: Codeunit "EM Management";
                begin
                    EMManagement.Run(Rec);
                end;
            }
            action("Calculate Weights")
            {
                ApplicationArea = All;
                Caption = 'Calculate Similarity Weights';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Calculate;

                trigger OnAction()
                var
                    EMClassificationManagement: Codeunit "EM Classification Management";
                begin
                    EMClassificationManagement.CalculateWeightSimVec(Rec);
                end;
            }

            group(Import)
            {
                Image = Import;

                action("Import Example Dataset 1")
                {
                    ApplicationArea = All;
                    Caption = 'Import Example Dataset 1';
                    Promoted = true;
                    PromotedCategory = Category4;
                    Image = Import;

                    trigger OnAction()
                    var
                        ImportExampleDataset1: XmlPort "EM Import Exmalpe Dataset";
                    begin
                        ImportExampleDataset1.Run();
                    end;
                }

                action("Import Example Dataset 2")
                {
                    ApplicationArea = All;
                    Caption = 'Import Example Dataset 2';
                    Promoted = true;
                    PromotedCategory = Category4;
                    Image = Import;

                    trigger OnAction()
                    var
                        ImportExampleDataset2: XmlPort "EM Import Exmalpe Dataset 2";
                    begin
                        ImportExampleDataset2.Run();
                    end;
                }
            }
        }
    }
}
