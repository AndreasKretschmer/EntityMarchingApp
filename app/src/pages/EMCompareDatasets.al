page 77001 "EM Compare Datasets"
{
    ApplicationArea = All;
    Caption = 'Compare Datasets';
    PageType = List;
    SourceTable = "EM Compare Datasets";
    UsageCategory = Tasks;

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
                field("Distance Method"; Rec."Distance Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Distance Method field.';
                }
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
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = BulletList;
                RunObject = page "EM Compare DS Blocking Buffer";
                RunPageLink = "Compare Dataset Entry No." = field("Entry No.");
            }

            action("Field Mappings")
            {
                ApplicationArea = All;
                Caption = 'Field Mappings';
                Promoted = true;
                PromotedCategory = Process;
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
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = BulletList;
                RunObject = page "EM SLK Field Setup Card";
                RunPageLink = "Compare DS Entry No." = field("Entry No."), "Table No. DS 1" = field("Dataset 1 Table No."), "Table No. DS 2" = field("Dataset 2 Table No.");
                RunPageMode = Create;
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
        }
    }
}
