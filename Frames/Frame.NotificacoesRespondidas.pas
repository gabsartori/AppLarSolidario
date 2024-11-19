unit Frame.NotificacoesRespondidas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFrameNotificacoesRespondidas = class(TFrame)
    lblNotificacao: TLabel;
    btnOk: TRoundRect;
    Label1: TLabel;
    lblCodSolicitacao: TLabel;
    Rectangle4: TRectangle;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uFrmNotificacoes;

procedure TFrameNotificacoesRespondidas.btnOkClick(Sender: TObject);
begin
   if lblCodSolicitacao.Text <> '' then
   begin
      frmNotificacoes.AtualizaSolicitacao(lblCodSolicitacao.text);
   end;

   frmNotificacoes.Show;
end;

end.
