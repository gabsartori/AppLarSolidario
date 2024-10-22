unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit;

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
    procedure btnCriarContaClick(Sender: TObject);
    procedure btnAcessarClick(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sUsuarioLogado, sNomeUsuarioLogado: String;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses uCriarCadastro, uPaginaInicial, uDtmServidor, Notificacao;

procedure TfrmLogin.btnAcessarClick(Sender: TObject);
begin
   if (edtUsuario.Text = '') then
   begin
      TLoading.ToastMessage(frmLogin,
                            'Informe o e-mail',
                             $FFFA3F3F,
                             TAlignLayout.Top);
      Exit;
   end;

   if (edtSenha.Text = '') then
   begin
      TLoading.ToastMessage(frmLogin,
                            'Informe a senha',
                             $FFFA3F3F,
                             TAlignLayout.Top);
      Exit;
   end;

   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Text := '';
   dtmServidor.qryGeral.SQL.Text := ' select * from pessoa '+
                                    ' where email = :email '+
                                    ' and senha = :senha   ';

   dtmServidor.qryGeral.Params.ParamByName('email').AsString := edtUsuario.Text;
   dtmServidor.qryGeral.Params.ParamByName('senha').AsString := edtSenha.Text;
   dtmServidor.qryGeral.Active := true;

   if (dtmServidor.qryGeral.RecordCount > 0) then
   begin
      sUsuarioLogado := dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString;
      sNomeUsuarioLogado := dtmServidor.qryGeral.FieldByName('nome').AsString;
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

procedure TfrmLogin.btnCriarContaClick(Sender: TObject);
begin
   frmCriarCadastro.Show;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
   edtUsuario.Text := '';
   edtSenha.Text := '';
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
