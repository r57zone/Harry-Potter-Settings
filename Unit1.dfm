object Form1: TForm1
  Left = 210
  Top = 123
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Harry Potter Settings'
  ClientHeight = 301
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SelectGameLbl: TLabel
    Left = 10
    Top = 15
    Width = 67
    Height = 13
    Caption = #1042#1099#1073#1086#1088' '#1080#1075#1088#1099': '
  end
  object GameCB: TComboBox
    Left = 79
    Top = 12
    Width = 162
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = GameCBChange
  end
  object GameGB: TGroupBox
    Left = 8
    Top = 40
    Width = 321
    Height = 97
    Caption = #1048#1075#1088#1072
    TabOrder = 1
    object WindowModeCB: TCheckBox
      Left = 8
      Top = 24
      Width = 97
      Height = 17
      Caption = #1047#1072#1087#1091#1089#1082' '#1074' '#1086#1082#1085#1077
      TabOrder = 0
    end
    object DebugMenuCB: TCheckBox
      Left = 8
      Top = 72
      Width = 97
      Height = 17
      Caption = #1056#1077#1078#1080#1084' '#1086#1090#1083#1072#1076#1082#1080
      TabOrder = 2
    end
    object HardwareAccelerationCB: TCheckBox
      Left = 8
      Top = 48
      Width = 145
      Height = 17
      Caption = #1040#1087#1087#1072#1088#1072#1090#1085#1086#1077' '#1091#1089#1082#1086#1088#1077#1085#1080#1077
      TabOrder = 1
    end
  end
  object VideoGB: TGroupBox
    Left = 8
    Top = 144
    Width = 321
    Height = 118
    Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
    TabOrder = 2
    object ResolutionLbl: TLabel
      Left = 8
      Top = 25
      Width = 201
      Height = 13
      Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1074' '#1087#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1086#1084' '#1088#1077#1078#1080#1084#1077':'
    end
    object FOVLbl: TLabel
      Left = 8
      Top = 91
      Width = 67
      Height = 13
      Caption = #1059#1075#1086#1083' '#1086#1073#1079#1086#1088#1072':'
    end
    object ResolutionWndLbl: TLabel
      Left = 8
      Top = 59
      Width = 102
      Height = 13
      Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1074' '#1086#1082#1085#1077':'
    end
    object ResolutionsCB: TComboBox
      Left = 216
      Top = 23
      Width = 97
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = '640x480'
      Items.Strings = (
        '640x480'
        '800x600'
        '1024x768'
        '1280x720'
        '1280x800'
        '1280x1024'
        '1366x768'
        '1440x900'
        '1600x900'
        '1680x1050'
        '1920x1080'
        '1920x1200'
        '2560x1440')
    end
    object FOVCB: TComboBox
      Left = 216
      Top = 88
      Width = 97
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = '90 (4:3)'
      Items.Strings = (
        '90 (4:3)'
        '106.27 (16:9)'
        '100.39 (16:10)')
    end
    object ResolutionsWndCB: TComboBox
      Left = 216
      Top = 56
      Width = 97
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = '640x480'
      Items.Strings = (
        '640x480'
        '800x600'
        '1024x768'
        '1280x720'
        '1280x800'
        '1280x1024'
        '1366x768'
        '1440x900'
        '1600x900'
        '1680x1050'
        '1920x1080'
        '1920x1200'
        '2560x1440')
    end
  end
  object ApplyBtn: TButton
    Left = 8
    Top = 268
    Width = 75
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 3
    OnClick = ApplyBtnClick
  end
  object CloseBtn: TButton
    Left = 88
    Top = 268
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 4
    OnClick = CloseBtnClick
  end
  object AboutBtn: TButton
    Left = 301
    Top = 268
    Width = 27
    Height = 25
    Caption = '?'
    TabOrder = 5
    OnClick = AboutBtnClick
  end
  object XPManifest: TXPManifest
    Left = 288
    Top = 8
  end
end
