unit Frame.EditarLaresTemporarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.DialogService;

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
    procedure RoundRect2Click(Sender: TObject);
    procedure ConfirmarInativacao;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uFrmEditarLarTemporario, uDtmServidor, uFrmEdicaoLares, Notificacao;

procedure TFrameEditarLaresTemporarios.ConfirmarInativacao;
begin
   TDialogService.MessageDialog(
       'Deseja realmente desativar este lar?',
       TMsgDlgType.mtConfirmation,
       [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
       TMsgDlgBtn.mbNo, // Bot�o padr�o
       0,
       procedure(const AResult: TModalResult)
       begin
         if AResult = mrYes then
         begin
           try
               dtmServidor.qryUpdate.Active := False;
               dtmServidor.qryUpdate.SQL.Clear;
               dtmServidor.qryUpdate.SQL.Text := ' UPDATE Lar_Temporario '+
                                                 ' SET IND_ATIVO = 0 '+
                                                 ' WHERE COD_LAR = :COD_LAR ';

               dtmServidor.qryUpdate.Params.ParamByName('COD_LAR').AsString := lblCodLar.Text;

               dtmServidor.qryInsert.ExecSQL;

               try
                   if dtmServidor.fdConexao.InTransaction then
                   begin
                      dtmServidor.fdConexao.Commit;
                   end;
               except
                  TLoading.ToastMessage(frmEdicaoLares,
                                       'N�o foi poss�vel realizar a opera��o!',
                                        $FFFA3F3F,
                                        TAlignLayout.Top);
                  Exit;
               end;

           finally
               TLoading.ToastMessage(frmEdicaoLares,
                                    'Lar inativado com sucesso',
                                     $FF22AF70,
                                     TAlignLayout.Top);

               frmEdicaoLares.Show;
           end;
         end
         else
         begin
            // C�digo caso o usu�rio cancele a exclus�o
            ShowMessage('A��o cancelada!');
         end;
       end
   );
end;

procedure TFrameEditarLaresTemporarios.RoundRect2Click(Sender: TObject);
begin
   if lblCodLar.Text <> '' then
   begin
      frmEditarLarTemporario.BuscaCodigoLar(StrToInt(lblCodLar.text));
   end;

   frmEditarLarTemporario.Show;
end;

end.
