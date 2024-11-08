unit Frame.EditarLaresTemporarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects;

type
  TFrameEditarLaresTemporarios = class(TFrame)
    lblNome: TLabel;
    lblEndereco: TLabel;
    lblTelefone: TLabel;
    lblTipoAnimal: TLabel;
    lblQtdAnimais: TLabel;
    lblTelas: TLabel;
    RoundRect1: TRoundRect;
    RoundRect2: TRoundRect;
    Label1: TLabel;
    lblDesativar: TLabel;
    lblSituacao: TLabel;
    Rectangle1: TRectangle;
    lblCodLar: TLabel;
    lblInformacoes: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
