unit uCriarCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.ExtCtrls, FMX.Edit, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers, FMX.Helpers.Android, FMX.ComboEdit;

type
  TfrmCriarCadastro = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    edtNome: TEdit;
    Label8: TLabel;
    lblNome: TLabel;
    btnCriarConta: TRoundRect;
    Label9: TLabel;
    lblTelefone: TLabel;
    edtTelefone: TEdit;
    edtBairro: TEdit;
    lblRua: TLabel;
    lblBairro: TLabel;
    edtRua: TEdit;
    edtEmail: TEdit;
    edtSenha: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    imgVoltar: TImage;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout6: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Layout10: TLayout;
    Layout11: TLayout;
    Layout13: TLayout;
    lblCidade: TLabel;
    lblEmail: TLabel;
    lblSenha: TLabel;
    cbxCidade: TComboEdit;
    procedure imgVoltarClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure AbrirWhatsApp(sTelefone: string);
    procedure Label9Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //procedure edtCepExit(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure LimpaCampos(Sender: TObject);
    procedure edtBairroEnter(Sender: TObject);
   // procedure edtCepEnter(Sender: TObject);
    procedure edtRuaEnter(Sender: TObject);
    procedure edtNumeroEnter(Sender: TObject);
    procedure edtCidadeEnter(Sender: TObject);
    procedure edtEstadoEnter(Sender: TObject);
    procedure edtSenhaEnter(Sender: TObject);
    procedure edtTelefoneEnter(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure edtEmailEnter(Sender: TObject);
  private
    { Private declarations }
    foco: TControl;
  public
    { Public declarations }
    sNumero: String;
  end;

  const
    _URL_CONSULTAR_CEP = 'https://brasilapi.com.br/api/cep/v1/%s';

var
  frmCriarCadastro: TfrmCriarCadastro;

implementation

{$R *.fmx}

uses uFrmLogin, uPaginaInicial, JSON, System.Net.HttpClient, uDtmServidor,
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
var
   iCodCidade: integer;
   sUF: String;
begin
   if edtNome.Text = '' then
   begin
      ShowMessage('Informe o nome');
      Exit;
   end;

   if edtTelefone.Text = '' then
   begin
      ShowMessage('Informe o telefone');
      Exit;
   end;

   if edtRua.Text = '' then
   begin
      ShowMessage('Informe a rua');
      Exit;
   end;

   if edtEmail.Text = '' then
   begin
      ShowMessage('Informe o e-mail');
      Exit;
   end;

   if edtSenha.Text = '' then
   begin
      ShowMessage('Informe a senha');
      Exit;
   end;

   dtmServidor.qryGeral2.Active := False;
   dtmServidor.qryGeral2.SQL.Clear;
   dtmServidor.qryGeral2.SQL.Text := ' select * from pessoas '+
                                     ' where email_pessoa = '''+edtEmail.Text+''''+
                                     ' and ind_ativo = 1     ';
   dtmServidor.qryGeral2.Active := True;

   if (dtmServidor.qryGeral2.RecordCount > 0) then
   begin

   end;


   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Clear;
   dtmServidor.qryGeral.SQL.Text := 'select * from cidades where nome_cidade = '''+cbxCidade.Text+'''';
   dtmServidor.qryGeral.Active := True;

   iCodCidade := dtmServidor.qryGeral.FieldByName('cod_cidade').AsInteger;
   sUF := dtmServidor.qryGeral.FieldByName('uf').AsString;

   try
      dtmServidor.qryInsert.Active := False;
      dtmServidor.qryInsert.SQL.Clear;
      dtmServidor.qryInsert.SQL.Text := ' insert into Pessoas (Nome_Pessoa,     '+
                                       '                      Telefone_Pessoa, '+
                                       '                      Des_Rua,         '+
                                       '                      Des_Bairro,      '+
                                       '                      UF,              '+
                                       '                      Email_Pessoa,    '+
                                       '                      Senha_Pessoa,    '+
                                       '                      Ind_Ativo,       '+
                                       '                      Cod_Cidade)      '+
                                       '             values (:Nome_Pessoa,     '+
                                       '                     :Telefone_Pessoa, '+
                                       '                     :Des_Rua,         '+
                                       '                     :Des_Bairro,      '+
                                       '                     :UF,              '+
                                       '                     :Email_Pessoa,    '+
                                       '                     :Senha_Pessoa,    '+
                                       '                     :Ind_Ativo,       '+
                                       '                     :Cod_Cidade);     ';

      if (edtNumero.Text = '') then
      begin
         sNumero := 'S/N';
      end
      else
      begin
         sNumero := edtNumero.Text;
      end;

      dtmServidor.qryInsert.ParamByName('Nome_Pessoa').AsString := edtNome.Text;
      dtmServidor.qryInsert.ParamByName('Telefone_Pessoa').AsString := edtTelefone.Text;
      dtmServidor.qryInsert.ParamByName('Des_Rua').AsString := edtRua.Text +','+ sNumero;
      dtmServidor.qryInsert.ParamByName('Des_Bairro').AsString := edtBairro.Text;
      dtmServidor.qryInsert.ParamByName('UF').AsString := sUF;
      dtmServidor.qryInsert.ParamByName('Email_Pessoa').AsString := edtEmail.Text;
      dtmServidor.qryInsert.ParamByName('Senha_Pessoa').AsString := edtSenha.Text;
      dtmServidor.qryInsert.ParamByName('Ind_Ativo').AsString := '1';
      dtmServidor.qryInsert.ParamByName('Cod_Cidade').AsInteger := iCodCidade;

      dtmServidor.qryInsert.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmCriarCadastro,
                            'N�o foi poss�vel realizar o cadastro!',
                             $FFFA3F3F,
                             TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmCriarCadastro,
                            'Cadastrado com sucesso',
                             $FF22AF70,
                             TAlignLayout.Top);
      LimpaCampos(Sender);
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

//procedure TfrmCriarCadastro.edtCepEnter(Sender: TObject);
//begin
//   foco := TControl(TEdit(sender).Parent);
//   Ajustar_Scroll();
//end;

//procedure TfrmCriarCadastro.edtCepExit(Sender: TObject);
//var
//  LCEP: String;
//  LJSONObj: TJSONObject;
//begin
//   if (edtCep.Text <> '') then
//   begin
//      try
//         LCEP := trim(edtCep.Text);
//
//         dtmServidor.RESTClient1.BaseURL := format(_URL_CONSULTAR_CEP,[LCEP]);
//         dtmServidor.RESTClient1.SecureProtocols := [THTTPSecureProtocol.TLS12];
//
//         dtmServidor.RESTRequest1.Method := rmGET;
//         dtmServidor.RESTRequest1.Execute;
//
//         LJSONObj := dtmServidor.RESTRequest1.Response.JSONValue AS TJSONObject;
//
//         edtCep.Text := LJSONObj.values['cep'].Value;
//         edtEstado.Text := LJSONObj.values['state'].Value;
//         edtCidade.Text := LJSONObj.values['city'].Value;
//         edtRua.Text := LJSONObj.values['street'].Value;
//         edtBairro.Text := LJSONObj.values['neighborhood'].Value;
//
//         edtNumero.SetFocus;
//      except
//         on E: Exception do
//         begin
//            TLoading.ToastMessage(frmCriarCadastro,
//                                  'N�o foi poss�vel consultar o CEP!'+#13+
//                                  'Erro: '+E.Message,
//                             $FFFA3F3F,
//                             TAlignLayout.Bottom);
//         end;
//      end;
//   end;
//end;

procedure TfrmCriarCadastro.edtCidadeEnter(Sender: TObject);
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
   if (cbxCidade.Items.Text = '') then
   begin
      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := 'select nome_cidade from cidades order by nome_cidade ';
      dtmServidor.qryGeral.Active := True;

      while not dtmServidor.qryGeral.Eof do
      begin
         cbxCidade.Items.Add(dtmServidor.qryGeral.FieldByName('nome_cidade').AsString);

         dtmServidor.qryGeral.Next;
      end;
   end;

   LimpaCampos(Sender);
end;

procedure TfrmCriarCadastro.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
   VertScrollBox1.Margins.Bottom := 0;
end;

procedure TfrmCriarCadastro.imgVoltarClick(Sender: TObject);
begin
   LimpaCampos(Sender);
   frmLogin.Show;
end;

procedure TfrmCriarCadastro.Label9Click(Sender: TObject);
begin
   btnCriarContaClick(Sender);
end;

procedure TfrmCriarCadastro.LimpaCampos(Sender: TObject);
begin
   edtNome.Text := '';
   edtTelefone.Text := '';
   edtRua.Text := '';
   edtBairro.Text := '';
   edtEmail.Text := '';
   edtSenha.Text := '';
   edtNumero.Text := '';
end;

end.

