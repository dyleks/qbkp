object Settings: TSettings
  Left = 0
  Top = 0
  Caption = 'Quick-backup - settings'
  ClientHeight = 473
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 144
    Top = 360
    Width = 113
    Height = 25
    Caption = 'Close Application'
    TabOrder = 0
    OnClick = Button1Click
  end
end
