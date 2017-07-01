object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Search Text in Files'
  ClientHeight = 340
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    705
    340)
  PixelsPerInch = 96
  TextHeight = 13
  object lText: TLabel
    Left = 192
    Top = 51
    Width = 46
    Height = 13
    Caption = 'Find files:'
  end
  object lJob: TLabel
    Left = 8
    Top = 221
    Width = 21
    Height = 13
    Caption = 'Job:'
  end
  object btnFindString: TButton
    Left = 16
    Top = 93
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = btnFindStringClick
  end
  object ledFolderPath: TLabeledEdit
    Left = 16
    Top = 24
    Width = 633
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 68
    EditLabel.Height = 13
    EditLabel.Caption = 'Search folder:'
    TabOrder = 1
    Text = 'c:\1'
  end
  object ledFindStr: TLabeledEdit
    Left = 16
    Top = 66
    Width = 121
    Height = 21
    EditLabel.Width = 60
    EditLabel.Height = 13
    EditLabel.Caption = 'Search text:'
    TabOrder = 2
    Text = #1047#1085#1072#1081#1076#1080' '#1084#1077#1085#1077
  end
  object btnOpenDlg: TBitBtn
    Left = 657
    Top = 22
    Width = 34
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = btnOpenDlgClick
  end
  object BitBtn2: TBitBtn
    Left = 16
    Top = 124
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 4
    Visible = False
    OnClick = BitBtn2Click
  end
  object btnStop: TButton
    Left = 97
    Top = 93
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 5
    OnClick = btnStopClick
  end
  object lbFileList: TListBox
    Left = 192
    Top = 66
    Width = 499
    Height = 160
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 6
  end
  object memTest: TMemo
    Left = 0
    Top = 240
    Width = 705
    Height = 100
    Align = alBottom
    Lines.Strings = (
      
        #1053#1091#1078#1085#1086' '#1085#1072#1087#1080#1089#1072#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1091' '#1087#1086#1080#1089#1082#1072' '#1092#1072#1081#1083#1086#1074', '#1089#1086#1076#1077#1088#1078#1072#1097#1080#1093' '#1079#1072#1076#1072#1085#1085#1091#1102' '#1089#1090#1088#1086 +
        #1082#1091'. '#1058'.'#1077'.'
      
        #1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1074#1099#1073#1080#1088#1072#1077#1090' '#1085#1072#1095#1072#1083#1100#1085#1099#1081' '#1082#1072#1090#1072#1083#1086#1075', '#1079#1072#1076#1072#1105#1090' '#1089#1090#1088#1086#1082#1091' '#1087#1086#1080#1089#1082#1072', '#1087 +
        #1086#1089#1083#1077' '#1095#1077#1075#1086' '#1087#1088#1086#1075#1088#1072#1084#1084#1072' '#1076#1086#1083#1078#1085#1072' '#1086#1073#1086#1081#1090#1080' '#1092#1072#1081#1083#1099' '#1074' '
      
        #1074#1099#1073#1088#1072#1085#1085#1086#1084' '#1082#1072#1090#1072#1083#1086#1075#1077' '#1080' '#1074#1089#1077#1093' '#1077#1075#1086' '#1087#1086#1076#1082#1072#1090#1072#1083#1086#1075#1072#1093' '#1080' '#1074#1099#1076#1072#1090#1100' '#1080#1084#1077#1085#1072' '#1090#1077#1093' '#1092#1072 +
        #1081#1083#1086#1074', '#1074' '#1082#1086#1090#1086#1088#1099#1093' '#1074#1089#1090#1088#1077#1095#1072#1077#1090#1089#1103' '#1079#1072#1076#1072#1085#1085#1072#1103' '
      
        #1089#1090#1088#1086#1082#1072'. '#1060#1072#1081#1083#1099' '#1084#1086#1075#1091#1090' '#1073#1099#1090#1100' '#1073#1080#1085#1072#1088#1085#1099#1084#1080', '#1089#1090#1088#1086#1082#1072' '#1074#1085#1091#1090#1088#1080' '#1092#1072#1081#1083#1072' '#1084#1086#1078#1077#1090' '#1083#1077 +
        #1078#1072#1090#1100' '#1074' ASCII, '#1074' UTF-8 '#1080#1083#1080' '#1074' UTF-16.')
    ReadOnly = True
    TabOrder = 7
  end
end
