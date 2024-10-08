unit uCriarCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.ExtCtrls, FMX.Edit, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers, FMX.Helpers.Android;

type
  TfrmCriarCadastro = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    edtNome: TEdit;
    Label8: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    btnCriarConta: TRoundRect;
    Label9: TLabel;
    edtDtaNascimento: TEdit;
    Label3: TLabel;
    edtTelefone: TEdit;
    Label4: TLabel;
    edtBairro: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtCidade: TEdit;
    edtCep: TEdit;
    edtRua: TEdit;
    edtEstado: TEdit;
    edtEmail: TEdit;
    RESTRequest1: TRESTRequest;
    RESTClient1: TRESTClient;
    RESTResponse1: TRESTResponse;
    edtSenha: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    imgVoltar: TImage;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Layout10: TLayout;
    Layout11: TLayout;
    Layout12: TLayout;
    Layout13: TLayout;
    Label7: TLabel;
    Esa: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure imgVoltarClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure imgBuscarCepClick(Sender: TObject);
    procedure AbrirWhatsApp(sTelefone: string);
    procedure Label9Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCepExit(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edtDtaNascimentoEnter(Sender: TObject);
    procedure edtTelefoneEnter(Sender: TObject);
    procedure edtCepEnter(Sender: TObject);
    procedure edtRuaEnter(Sender: TObject);
    procedure edtNumeroEnter(Sender: TObject);
    procedure edtBairroEnter(Sender: TObject);
    procedure edtCidadeEnter(Sender: TObject);
    procedure edtEstadoEnter(Sender: TObject);
    procedure edtEmailEnter(Sender: TObject);
    procedure edtSenhaEnter(Sender: TObject);
  private
    { Private declarations }
    foco: TControl;
  public
    { Public declarations }
  end;

  const
    _URL_CONSULTAR_CEP = 'https://brasilapi.com.br/api/cep/v1/%s';

var
  frmCriarCadastro: TfrmCriarCadastro;

implementation

{$R *.fmx}

uses uLogin, uPaginaInicial, JSON, System.Net.HttpClient, uDtmServidor,
  Notificacao;

procedure Ajustar_Scroll();
var
   x: Integer;
begin
   with frmCriarCadastro do
   begin
      VertScrollBox1.Margins.Bottom := 250;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                TControl(foco).Position.Y - 150);
   end;
end;

procedure TfrmCriarCadastro.AbrirWhatsApp(sTelefone: string);
var
  sURL: string;
begin
  // Formatar o n�mero de telefone para o formato internacional correto
  sTelefone := sTelefone.Replace(' ', '').Replace('(', '').Replace(')', '').Replace('-', '');
  sURL := 'https://wa.me/' + sTelefone;
  // Abrir a URL usando o intent do Android
  TAndroidHelper.Context.startActivity(
    TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,
    StrToJURI(sURL)));
end;

procedure TfrmCriarCadastro.btnCriarContaClick(Sender: TObject);
begin
   try
      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := ' insert into pessoa (nome,              '+
                                       '                     telefone,          '+
                                       '                     dta_nascimento,    '+
                                       '                     cep,               '+
                                       '                     rua,               '+
                                       '                     bairro,            '+
                                       '                     cidade,            '+
                                       '                     estado,            '+
                                       '                     email,             '+
                                       '                     senha,             '+
                                       '                     ind_ativo)         '+
                                       '             values (:nome,             '+
                                       '                     :telefone,         '+
                                       '                     :dta_nascimento,   '+
                                       '                     :cep,              '+
                                       '                     :rua,              '+
                                       '                     :bairro,           '+
                                       '                     :cidade,           '+
                                       '                     :estado,           '+
                                       '                     :email,            '+
                                       '                     :senha,            '+
                                       '                     :ind_ativo);       ';
      dtmServidor.qryGeral.ParamByName('nome').AsString := edtNome.Text;
      dtmServidor.qryGeral.ParamByName('telefone').AsString := edtTelefone.Text;
      dtmServidor.qryGeral.ParamByName('dta_nascimento').AsString := edtDtaNascimento.Text;
      dtmServidor.qryGeral.ParamByName('cep').AsString := edtCep.Text;
      dtmServidor.qryGeral.ParamByName('rua').AsString := edtRua.Text;
      dtmServidor.qryGeral.ParamByName('bairro').AsString := edtBairro.Text;
      dtmServidor.qryGeral.ParamByName('cidade').AsString := edtCidade.Text;
      dtmServidor.qryGeral.ParamByName('estado').AsString := edtEstado.Text;
      dtmServidor.qryGeral.ParamByName('email').AsString := edtEmail.Text;
      dtmServidor.qryGeral.ParamByName('senha').AsString := edtSenha.Text;
      dtmServidor.qryGeral.ParamByName('ind_ativo').AsString := '1';

      dtmServidor.qryGeral.ExecSQL;

      if dtmServidor.fdConexao.InTransaction then
      begin
         dtmServidor.fdConexao.Commit;
      end;
   finally
      TLoading.ToastMessage(frmCriarCadastro,
                            'Cadastrado com sucesso',
                             $FF22AF70,
                             TAlignLayout.Bottom);
      frmLogin.Show;
   end;

//   try
//      AbrirWhatsApp('5554991690101'); // Substitua pelo n�mero desejado
//   except
//      on E: Exception do
//      begin
//        ShowMessage('N�o foi poss�vel abrir o WhatsApp!'+#13+
//                    'Erro: '+E.Message);
//        Close;
//      end;
//   end;
end;

procedure TfrmCriarCadastro.edtBairroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtCepEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtCepExit(Sender: TObject);
var
  LCEP: String;
  LJSONObj: TJSONObject;
begin
   if (edtCep.Text <> '') then
   begin
      try
         LCEP := trim(edtCep.Text);

         RESTClient1.BaseURL := format(_URL_CONSULTAR_CEP,[LCEP]);
         RESTClient1.SecureProtocols := [THTTPSecureProtocol.TLS12];

         RESTRequest1.Method := rmGET;
         RESTRequest1.Execute;

         LJSONObj := RESTRequest1.Response.JSONValue AS TJSONObject;

         edtCep.Text := LJSONObj.values['cep'].Value;
         edtEstado.Text := LJSONObj.values['state'].Value;
         edtCidade.Text := LJSONObj.values['city'].Value;
         edtRua.Text := LJSONObj.values['street'].Value;
         edtBairro.Text := LJSONObj.values['neighborhood'].Value;

         edtNumero.SetFocus;
      except
         on E: Exception do
         begin
            TLoading.ToastMessage(frmCriarCadastro,
                                  'N�o foi poss�vel consultar o CEP!'+#13+
                                  'Erro: '+E.Message,
                             $FFFA3F3F,
                             TAlignLayout.Bottom);
         end;
      end;
   end;
end;

procedure TfrmCriarCadastro.edtCidadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtDtaNascimentoEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtEmailEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtEstadoEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtNomeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtNumeroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtRuaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtSenhaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtTelefoneEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.FormShow(Sender: TObject);
begin
   edtNome.Text := '';
   edtTelefone.Text := '';
   edtDtaNascimento.Text := '';
   edtCep.Text := '';
   edtRua.Text := '';
   edtBairro.Text := '';
   edtCidade.Text := '';
   edtEstado.Text := '';
   edtEmail.Text := '';
   edtSenha.Text := '';

   edtNome.SetFocus;
end;

procedure TfrmCriarCadastro.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
   VertScrollBox1.Margins.Bottom := 0;
end;


procedure TfrmCriarCadastro.imgBuscarCepClick(Sender: TObject);
var
  LCEP: String;
  LJSONObj: TJSONObject;
begin
   try
      LCEP := trim(edtCep.Text);

      RESTClient1.BaseURL := format(_URL_CONSULTAR_CEP,[LCEP]);
      RESTClient1.SecureProtocols := [THTTPSecureProtocol.TLS12];

      RESTRequest1.Method := rmGET;
      RESTRequest1.Execute;

      LJSONObj := RESTRequest1.Response.JSONValue AS TJSONObject;

      edtCep.Text := LJSONObj.values['cep'].Value;
      edtEstado.Text := LJSONObj.values['state'].Value;
      edtCidade.Text := LJSONObj.values['city'].Value;
      edtRua.Text := LJSONObj.values['street'].Value;
      edtBairro.Text := LJSONObj.values['neighborhood'].Value;

      edtNumero.SetFocus;
   except
      on E: Exception do
      begin
        ShowMessage('N�o foi poss�vel consultar o CEP!'+#13+
                    'Erro: '+E.Message);
        Close;
      end;
   end;
end;

procedure TfrmCriarCadastro.imgVoltarClick(Sender: TObject);
begin
   frmLogin.Show;
end;

procedure TfrmCriarCadastro.Label9Click(Sender: TObject);
begin
   btnCriarContaClick(Sender);
end;

end.

