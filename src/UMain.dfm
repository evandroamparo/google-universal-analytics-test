object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'FrmMain'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BtnForm1: TButton
    Left = 104
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Form1'
    Enabled = False
    TabOrder = 0
    OnClick = BtnForm1Click
  end
  object BtnForm2: TButton
    Left = 240
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Form2'
    Enabled = False
    TabOrder = 1
    OnClick = BtnForm2Click
  end
end
