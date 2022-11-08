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
            group(FieldMappingsPart)
            {
                part(FieldMappings; "EM Compare DS Field Mappings")
                {
                    Caption = 'Field Mappings';
                    // SubPageLink = "Compare Dataset Entry No." = field("Entry No."), "Dataset 1 Table No." = field("Dataset 1 Table No."), "Dataset 2 Table No." = field("Dataset 2 Table No.");
                    SubPageLink = "Compare Dataset Entry No." = field("Entry No.");
                    UpdatePropagation = Both;
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
