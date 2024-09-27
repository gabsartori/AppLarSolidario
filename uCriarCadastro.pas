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
    Layout3: TLayout;
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
    Label7: TLabel;
    edtCep: TEdit;
    edtRua: TEdit;
    Esa: TLabel;
    edtEstado: TEdit;
    Label10: TLabel;
    edtEmail: TEdit;
    RESTRequest1: TRESTRequest;
    RESTClient1: TRESTClient;
    RESTResponse1: TRESTResponse;
    imgBuscarCep: TImageControl;
    Label11: TLabel;
    edtSenha: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    imgVoltar: TImage;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    procedure imgVoltarClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure imgBuscarCepClick(Sender: TObject);
    procedure AbrirWhatsApp(sTelefone: string);
    procedure Label9Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
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

procedure TfrmCriarCadastro.AbrirWhatsApp(sTelefone: string);
var
  sURL: string;
begin
  // Formatar o número de telefone para o formato internacional correto
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
//      AbrirWhatsApp('5554991690101'); // Substitua pelo número desejado
//   except
//      on E: Exception do
//      begin
//        ShowMessage('Não foi possível abrir o WhatsApp!'+#13+
//                    'Erro: '+E.Message);
//        Close;
//      end;
//   end;
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
        ShowMessage('Não foi possível consultar o CEP!'+#13+
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

