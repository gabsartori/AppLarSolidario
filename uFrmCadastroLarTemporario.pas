unit uFrmCadastroLarTemporario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ExtCtrls,
  FMX.ListBox;

type
  TfrmCadastroLarTemporario = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    imgVoltar: TImage;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    Layout3: TLayout;
    edtNome: TEdit;
    Label8: TLabel;
    Label1: TLabel;
    btnCriarConta: TRoundRect;
    Label9: TLabel;
    Label3: TLabel;
    edtTelefone: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtCep: TEdit;
    edtRua: TEdit;
    edtSenha: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label6: TLabel;
    Label10: TLabel;
    Layout4: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastroLarTemporario: TfrmCadastroLarTemporario;

implementation

{$R *.fmx}

end.
