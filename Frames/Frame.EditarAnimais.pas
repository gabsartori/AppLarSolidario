unit Frame.EditarAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFrameEditarAnimais = class(TFrame)
    cFotoAnimal: TCircle;
    lblTipo: TLabel;
    lblGenero: TLabel;
    lblNome: TLabel;
    lblCor: TLabel;
    lblIdade: TLabel;
    lblEndereco: TLabel;
    lblCastrado: TLabel;
    lblSituacao: TLabel;
    lblInformacoes: TLabel;
    btnDesativar: TRoundRect;
    RoundRect1: TRoundRect;
    Label1: TLabel;
    lblDesativar: TLabel;
    lblCodAnimal: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
