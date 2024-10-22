unit uFrmCadastroLarTemporario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ExtCtrls,
  FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Ani, REST.Types,
  FMX.ComboEdit;

type
  TfrmCadastroLarTemporario = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    imgVoltar: TImage;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    edtNome: TEdit;
    Label8: TLabel;
    Label1: TLabel;
    btnCriarConta: TRoundRect;
    Label9: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtRua: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    edtQuantidade: TEdit;
    Label6: TLabel;
    Label10: TLabel;
    V: TLayout;
    Layout3: TLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Label13: TLabel;
    edtTelefone: TEdit;
    Layout5: TLayout;
    Layout10: TLayout;
    mmoInformacoes: TMemo;
    Label3: TLabel;
    cbxTelas: TComboEdit;
    cbxTipoAnimal: TComboEdit;
    cbxCidade: TComboEdit;
    edtBairro: TEdit;
    procedure btnCriarContaClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure LimpaCampos(Sender: TObject);
  //  procedure edtCepExit(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure edtTelefoneEnter(Sender: TObject);
    procedure edtBairroEnter(Sender: TObject);
    procedure edtRuaEnter(Sender: TObject);
    procedure edtNumeroEnter(Sender: TObject);
    procedure edtQuantidadeEnter(Sender: TObject);
    procedure cbxTelasEnter(Sender: TObject);
    procedure cbxTipoAnimalEnter(Sender: TObject);
    procedure mmoInformacoesEnter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }
    foco: TControl;
  public
    { Public declarations }
  end;

  const
  _URL_CONSULTAR_CEP = 'https://brasilapi.com.br/api/cep/v1/%s';
var
  frmCadastroLarTemporario: TfrmCadastroLarTemporario;

implementation

{$R *.fmx}

uses Notificacao, uDtmServidor, uLogin, uPaginaInicial, JSON, System.Net.HttpClient;

procedure Ajustar_Scroll();
var
   x: Integer;
begin
   with frmCadastroLarTemporario do
   begin
      VertScrollBox1.Margins.Bottom := 250;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                TControl(foco).Position.Y - 150);
   end;
end;

procedure TfrmCadastroLarTemporario.btnCriarContaClick(Sender: TObject);
var
   iCodCidade: Integer;
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
      ShowMessage('Informe o endereço');
      Exit;
   end;

   if edtQuantidade.Text = '' then
   begin
      ShowMessage('Informe a quantidade');
      Exit;
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
      dtmServidor.qryInsert.SQL.Text := ' INSERT INTO LarTemporario (Nome_Lar,         '+
                                        ' 					   	             Telefone_Lar,     '+
                                        ' 				            	     Des_Endereco_Lar, '+
                                        ' 				             	     Des_Bairro_Lar,   '+
                                        ' 				            	     UF,               '+
                                        ' 				            	     Qtd_Animais,      '+
                                        ' 				            	     Ind_Telas,        '+
                                        ' 				            	     Tipo_Animal,      '+
                                        ' 				            	     Informacoes_Lar,  '+
                                        ' 				            	     Ind_Ativo,        '+
                                        ' 				             	     Cod_Pessoa,       '+
                                        '                            Cod_Cidade)       '+
                                        ' 				          VALUES (:Nome_Lar,         '+
                                        ' 				          	  		:Telefone_Lar,     '+
                                        ' 				          	  		:Des_Endereco_Lar, '+
                                        ' 				             	    :Des_Bairro_Lar,   '+
                                        ' 				          	  		:UF,               '+
                                        ' 				          	  		:Qtd_Animais,      '+
                                        ' 				          	  		:Ind_Telas,        '+
                                        ' 				          	  		:Tipo_Animal,      '+
                                        ' 				          	  		:Informacoes_Lar,  '+
                                        ' 				          	  		:Ind_Ativo,        '+
                                        ' 				          	  		:Cod_Pessoa,       '+
                                        '                           :Cod_Cidade);      ';

      dtmServidor.qryInsert.ParamByName('Nome_Lar').AsString := edtNome.Text;
      dtmServidor.qryInsert.ParamByName('Telefone_Lar').AsString := edtTelefone.Text;
      dtmServidor.qryInsert.ParamByName('Des_Bairro_Lar').AsString := edtBairro.Text;
      dtmServidor.qryInsert.ParamByName('Des_Endereco_Lar').AsString := edtRua.Text +', '+edtNumero.Text;
      dtmServidor.qryInsert.ParamByName('UF').AsString := sUF;
      dtmServidor.qryInsert.ParamByName('Qtd_Animais').AsString := edtQuantidade.Text;
      dtmServidor.qryInsert.ParamByName('Ind_Telas').AsInteger := cbxTelas.ItemIndex;
      dtmServidor.qryInsert.ParamByName('Tipo_Animal').AsString := cbxTipoAnimal.Text;
      dtmServidor.qryInsert.ParamByName('Informacoes_Lar').AsString := mmoInformacoes.Text;
      dtmServidor.qryInsert.ParamByName('Ind_Ativo').AsString := '1';
      dtmServidor.qryInsert.ParamByName('Cod_Pessoa').AsString := frmLogin.sUsuarioLogado;
      dtmServidor.qryInsert.ParamByName('Cod_Cidade').AsInteger := iCodCidade;

      dtmServidor.qryInsert.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmCadastroLarTemporario,
                               'Não foi possível realizar o cadastro!',
                                $FFFA3F3F,
                                TAlignLayout.Top);
         Exit;
      end;
   finally
      TLoading.ToastMessage(frmCadastroLarTemporario,
                            'Cadastrado com sucesso!',
                             $FF22AF70,
                             TAlignLayout.Bottom);
      LimpaCampos(Sender);
   end;
end;

procedure TfrmCadastroLarTemporario.cbxTelasEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroLarTemporario.cbxTipoAnimalEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroLarTemporario.edtBairroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

//procedure TfrmCadastroLarTemporario.edtCepExit(Sender: TObject);
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
//         edtCidade.Text := LJSONObj.values['city'].Value;
//         edtRua.Text := LJSONObj.values['street'].Value;
//         edtRua.Text := edtRua.Text + ' ,' + LJSONObj.values['neighborhood'].Value;
//
//         edtNumero.SetFocus;
//      except
//         on E: Exception do
//         begin
//            TLoading.ToastMessage(frmCadastroLarTemporario,
//                                  'Não foi possível consultar o CEP!'+#13+
//                                  'Erro: '+E.Message,
//                             $FFFA3F3F,
//                             TAlignLayout.Bottom);
//         end;
//      end;
//   end;
//end;

procedure TfrmCadastroLarTemporario.edtNomeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroLarTemporario.edtNumeroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroLarTemporario.edtQuantidadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroLarTemporario.edtRuaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroLarTemporario.edtTelefoneEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroLarTemporario.FormShow(Sender: TObject);
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

   LimpaCampos(Sender);
end;

procedure TfrmCadastroLarTemporario.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
   VertScrollBox1.Margins.Bottom := 0;
end;

procedure TfrmCadastroLarTemporario.imgVoltarClick(Sender: TObject);
begin
   LimpaCampos(Sender);
   frmPaginaInicial.Show;
end;

procedure TfrmCadastroLarTemporario.LimpaCampos(Sender: TObject);
begin
   edtNome.Text	:= '';
   edtTelefone.Text := '';
   edtBairro.Text := '';
   edtRua.Text := '';
   edtNumero.Text := '';
   edtQuantidade.Text := '';
   cbxCidade.ItemIndex := 0;
   cbxTelas.ItemIndex := 0;
   cbxTipoAnimal.ItemIndex := 0;
   mmoInformacoes.Text := '';
end;

procedure TfrmCadastroLarTemporario.mmoInformacoesEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

end.
