unit Frame.EditarAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.DialogService;

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
    btnEditar: TRoundRect;
    Label1: TLabel;
    lblDesativar: TLabel;
    lblCodAnimal: TLabel;
    procedure btnEditarClick(Sender: TObject);
    procedure btnDesativarClick(Sender: TObject);
    procedure ConfirmarInativacao;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uFrmEdicaoAnimais, uFrmEditarAnimais, Notificacao, uFrmEdicaoLares,
  uDtmServidor;

procedure TFrameEditarAnimais.btnDesativarClick(Sender: TObject);
begin
   ConfirmarInativacao;
end;

procedure TFrameEditarAnimais.btnEditarClick(Sender: TObject);
begin
   if lblCodAnimal.Text <> '' then
   begin
      frmEditarAnimais.BuscaCodigoAnimal(StrToInt(lblCodAnimal.text));
   end;

   frmEditarAnimais.Show;
end;

procedure TFrameEditarAnimais.ConfirmarInativacao;
begin
   TDialogService.MessageDialog(
       'Deseja realmente desativar este pet?',
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
               dtmServidor.qryUpdate.SQL.Text := ' UPDATE ANIMAIS '+
                                                 ' SET IND_ATIVO = 0 '+
                                                 ' WHERE COD_ANIMAL = :COD_ANIMAL ';

               dtmServidor.qryUpdate.Params.ParamByName('COD_ANIMAL').AsString := lblCodAnimal.Text;

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
                                    'Pet inativado com sucesso',
                                     $FF22AF70,
                                     TAlignLayout.Top);

               frmEdicaoAnimais.Show;
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

end.
