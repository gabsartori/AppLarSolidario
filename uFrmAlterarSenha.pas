unit uFrmAlterarSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Edit, FMX.VirtualKeyboard,
  FMX.Platform;

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
    btnAlterarSenha: TRoundRect;
    Label9: TLabel;
    Layout8: TLayout;
    btnCancelar: TRoundRect;
    Label4: TLabel;
    procedure edtSenhaAtualExit(Sender: TObject);
    procedure edtSenhaNovaExit(Sender: TObject);
    procedure btnAlterarSenhaClick(Sender: TObject);
    procedure LimparCampos(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtConfirmarSenhaExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure imgSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAlterarSenha: TfrmAlterarSenha;

implementation

{$R *.fmx}

uses uFrmLogin, uDtmServidor, uCriarCadastro, Notificacao, uPaginaConfiguracoes;

procedure TfrmAlterarSenha.btnCancelarClick(Sender: TObject);
begin
   LimparCampos(Sender);
   frmAlterarSenha.Close;
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmAlterarSenha.btnAlterarSenhaClick(Sender: TObject);
begin
   if (edtSenhaNova.Text = edtConfirmarSenha.Text) then
   begin
      try
         dtmServidor.qryUpdate.Active := False;
         dtmServidor.qryUpdate.SQL.Clear;
         dtmServidor.qryUpdate.SQL.Text := ' UPDATE pessoas                   '+
                                           ' SET senha_pessoa = :senha_pessoa '+
                                           ' WHERE cod_pessoa = :cod_pessoa   ';

         dtmServidor.qryUpdate.Params.ParamByName('senha_pessoa').AsString := edtConfirmarSenha.Text;
         dtmServidor.qryUpdate.Params.ParamByName('cod_pessoa').AsString := frmLogin.sUsuarioLogado;

         dtmServidor.qryUpdate.ExecSQL;

         try
             if dtmServidor.fdConexao.InTransaction then
             begin
                dtmServidor.fdConexao.Commit;
             end;
         except
            TLoading.ToastMessage(frmAlterarSenha,
                                 'N�o foi poss�vel realizar as altera��es!',
                                  $FFFA3F3F,
                                  TAlignLayout.Top);
            Exit;
         end;

      finally
         TLoading.ToastMessage(frmAlterarSenha,
                              'Senha alterada com sucesso!',
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
   dtmServidor.qryGeral.SQL.Text := ' SELECT senha_pessoa                        '+
                                    ' FROM pessoas                               '+
                                    ' WHERE cod_pessoa = '+frmLogin.sUsuarioLogado;
   dtmServidor.qryGeral.Active := True;

   if (edtSenhaAtual.Text <> dtmServidor.qryGeral.FieldByName('senha_pessoa').AsString) then
   begin
      ShowMessage('A senha informada � diferente da senha atual!');
      Exit;
   end;
end;

procedure TfrmAlterarSenha.edtSenhaNovaExit(Sender: TObject);
begin
   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Clear;
   dtmServidor.qryGeral.SQL.Text := ' SELECT senha_pessoa                        '+
                                    ' FROM pessoas                               '+
                                    ' WHERE cod_pessoa = '+frmLogin.sUsuarioLogado;
   dtmServidor.qryGeral.Active := True;

   if (edtSenhaNova.Text = dtmServidor.qryGeral.FieldByName('senha_pessoa').AsString) then
   begin
      ShowMessage('A senha informada � igual a senha atual!');
      Exit;
   end;
end;

procedure TfrmAlterarSenha.FormShow(Sender: TObject);
begin
   LimparCampos(Sender);
end;

procedure TfrmAlterarSenha.imgSairClick(Sender: TObject);
begin
   frmAlterarSenha.Close;
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmAlterarSenha.LimparCampos(Sender: TObject);
begin
   edtSenhaAtual.Text := '';
   edtSenhaNova.Text := '';
   edtConfirmarSenha.Text := '';
end;

end.
