unit uFrmLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.DialogService, FMX.VirtualKeyboard, FMX.Platform;

type
  TfrmLogin = class(TForm)
    layoutLogin: TLayout;
    layoutCircle: TLayout;
    Circle2: TCircle;
    layoutNovo: TLayout;
    btnCriarConta: TRoundRect;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Layout1: TLayout;
    btnAcessar: TRoundRect;
    Label9: TLabel;
    edtUsuario: TEdit;
    Label8: TLabel;
    Layout2: TLayout;
    ImageControl1: TImageControl;
    Layout3: TLayout;
    Layout4: TLayout;
    RoundRect1: TRoundRect;
    Layout5: TLayout;
    RoundRect2: TRoundRect;
    edtSenha: TEdit;
    Label4: TLabel;
    lytOpaco: TLayout;
    Rectangle3: TRectangle;
    lytConfirmaAtivacao: TLayout;
    Panel1: TPanel;
    btnSim: TRoundRect;
    Label5: TLabel;
    btnNao: TRoundRect;
    Label10: TLabel;
    lblConfirmacao: TLabel;
    procedure btnCriarContaClick(Sender: TObject);
    procedure btnAcessarClick(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSimClick(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sUsuarioLogado, sNomeUsuarioLogado, sCodPessoa: String;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses uCriarCadastro, uPaginaInicial, uDtmServidor, Notificacao;

procedure TfrmLogin.btnAcessarClick(Sender: TObject);
var
  VirtualKeyboard: IFMXVirtualKeyboardService;
begin
   if (edtUsuario.Text = '') then
   begin
      ShowMessage('Informe o e-mail');
      Exit;
   end;

   if (edtSenha.Text = '') then
   begin
      ShowMessage('Infome a senha');
      Exit;
   end;

   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Text := '';
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM pessoas              '+
                                    ' WHERE email_pessoa = :email_pessoa '+
                                    ' AND ind_ativo = 0                  ';

   dtmServidor.qryGeral.Params.ParamByName('email_pessoa').AsString := edtUsuario.Text;
   dtmServidor.qryGeral.Active := true;

   sCodPessoa := dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString;

   if (dtmServidor.qryGeral.RecordCount > 0) then
   begin
      if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
      begin
         VirtualKeyboard.HideVirtualKeyboard;
      end;

      lytOpaco.Visible := True;
      lytConfirmaAtivacao.Visible := True;
   end
   else
   begin
      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Text := '';
      dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM pessoas '+
                                       ' WHERE email_pessoa = :email_pessoa '+
                                       ' AND senha_pessoa = :senha_pessoa   '+
                                       ' AND ind_ativo = 1    ';

      dtmServidor.qryGeral.Params.ParamByName('email_pessoa').AsString := edtUsuario.Text;
      dtmServidor.qryGeral.Params.ParamByName('senha_pessoa').AsString := edtSenha.Text;
      dtmServidor.qryGeral.Active := true;

      if (dtmServidor.qryGeral.RecordCount > 0) then
      begin
         sUsuarioLogado := dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString;
         sNomeUsuarioLogado := dtmServidor.qryGeral.FieldByName('nome_pessoa').AsString;
         edtUsuario.Text := '';
         edtSenha.Text := '';
         frmPaginaInicial.Show;
      end
      else
      begin
         TLoading.ToastMessage(frmLogin,
                               'Credenciais incorretas! Digite novamente.',
                                $FFFA3F3F,
                                TAlignLayout.Top);
      end;
   end;
end;

procedure TfrmLogin.btnCriarContaClick(Sender: TObject);
begin
   edtUsuario.Text := '';
   edtSenha.Text := '';
   frmCriarCadastro.Show;
end;

procedure TfrmLogin.btnNaoClick(Sender: TObject);
begin
   lytOpaco.Visible := False;
   lytConfirmaAtivacao.Visible := False;
end;

procedure TfrmLogin.btnSimClick(Sender: TObject);
begin
   try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE pessoas '+
                                        ' SET ind_ativo = 1 '+
                                        ' WHERE cod_pessoa = :cod_pessoa ';

      dtmServidor.qryUpdate.Params.ParamByName('cod_pessoa').AsString := sCodPessoa;

      dtmServidor.qryUpdate.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmCriarCadastro,
                            'Não foi possível realizar a operação!',
                             $FFFA3F3F,
                             TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmCriarCadastro,
                           'Conta reativada com sucesso',
                           $FF22AF70,
                           TAlignLayout.Top);

      lytOpaco.Visible := False;
      lytConfirmaAtivacao.Visible := False;
      frmLogin.Show;
   end;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   dtmServidor.fdConexao.Connected := False;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
   edtUsuario.Text := '';
   edtSenha.Text := '';
   sUsuarioLogado := '';
   sNomeUsuarioLogado := '';
   lytOpaco.Visible := False;
   lytConfirmaAtivacao.Visible := False;
end;

procedure TfrmLogin.Label1Click(Sender: TObject);
begin
   btnCriarContaClick(Sender);
end;

procedure TfrmLogin.Label9Click(Sender: TObject);
begin
   btnAcessarClick(Sender);
end;

end.
