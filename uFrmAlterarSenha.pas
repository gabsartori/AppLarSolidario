unit uFrmAlterarSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Edit;

type
  TfrmAlterarSenha = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    imgSair: TImage;
    Image1: TImage;
    Image3: TImage;
    Layout2: TLayout;
    lblMenu: TLabel;
    VertScrollBox1: TVertScrollBox;
    Layout3: TLayout;
    Label1: TLabel;
    edtConfirmarSenha: TEdit;
    Label2: TLabel;
    edtSenhaNova: TEdit;
    Label3: TLabel;
    edtSenhaAtual: TEdit;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    btnCriarConta: TRoundRect;
    Label9: TLabel;
    procedure edtSenhaAtualExit(Sender: TObject);
    procedure edtSenhaNovaExit(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure LimparCampos(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtConfirmarSenhaExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAlterarSenha: TfrmAlterarSenha;

implementation

{$R *.fmx}

uses uFrmLogin, uDtmServidor, uCriarCadastro, Notificacao;

procedure TfrmAlterarSenha.btnCriarContaClick(Sender: TObject);
begin
   if (edtSenhaNova.Text = edtConfirmarSenha.Text) then
   begin
      try
         dtmServidor.qryUpdate.Active := False;
         dtmServidor.qryUpdate.SQL.Clear;
         dtmServidor.qryUpdate.SQL.Text := ' UPDATE PESSOAS '+
                                           ' SET SENHA_PESSOA = :SENHA_PESSOA '+
                                           ' WHERE COD_PESSOA = :COD_PESSOA ';

         dtmServidor.qryUpdate.Params.ParamByName('SENHA_PESSOA').AsString := edtConfirmarSenha.Text;
         dtmServidor.qryUpdate.Params.ParamByName('COD_PESSOA').AsString := frmLogin.sUsuarioLogado;

         dtmServidor.qryInsert.ExecSQL;

         try
             if dtmServidor.fdConexao.InTransaction then
             begin
                dtmServidor.fdConexao.Commit;
             end;
         except
            TLoading.ToastMessage(frmCriarCadastro,
                               'N�o foi poss�vel realizar as altera��es!',
                                $FFFA3F3F,
                                TAlignLayout.Top);
            Exit;
         end;

      finally
         TLoading.ToastMessage(frmCriarCadastro,
                          'Senha alterada com sucesso',
                           $FF22AF70,
                           TAlignLayout.Top);

         LimparCampos(Sender);
         frmAlterarSenha.Close;
      end;
   end
   else
   begin
      ShowMessage('As senhas n�o conferem');
      Exit;
   end;
end;

procedure TfrmAlterarSenha.edtConfirmarSenhaExit(Sender: TObject);
begin
   if (edtSenhaNova.Text <> edtConfirmarSenha.Text) then
   begin
      ShowMessage('As senhas n�o conferem');
      Exit;
   end;
end;

procedure TfrmAlterarSenha.edtSenhaAtualExit(Sender: TObject);
begin
   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Clear;
   dtmServidor.qryGeral.SQL.Text := ' SELECT SENHA_PESSOA '+
                                    ' FROM PESSOAS        '+
                                    ' WHERE COD_PESSOA = '+frmLogin.sUsuarioLogado;
   dtmServidor.qryGeral.Active := True;

   if (edtSenhaAtual.Text <> dtmServidor.qryGeral.FieldByName('SENHA_PESSOA').AsString) then
   begin
      ShowMessage('A senha informada � diferente da senha atual!');
      Exit;
   end;
end;

procedure TfrmAlterarSenha.edtSenhaNovaExit(Sender: TObject);
begin
   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Clear;
   dtmServidor.qryGeral.SQL.Text := ' SELECT SENHA_PESSOA '+
                                    ' FROM PESSOAS        '+
                                    ' WHERE COD_PESSOA = '+frmLogin.sUsuarioLogado;
   dtmServidor.qryGeral.Active := True;

   if (edtSenhaNova.Text = dtmServidor.qryGeral.FieldByName('SENHA_PESSOA').AsString) then
   begin
      ShowMessage('A senha informada � igual a senha atual!');
      Exit;
   end;
end;

procedure TfrmAlterarSenha.FormShow(Sender: TObject);
begin
   LimparCampos(Sender);
end;

procedure TfrmAlterarSenha.LimparCampos(Sender: TObject);
begin
   edtSenhaAtual.Text := '';
   edtSenhaNova.Text := '';
   edtConfirmarSenha.Text := '';
end;

end.
