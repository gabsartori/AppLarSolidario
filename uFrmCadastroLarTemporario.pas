unit uFrmCadastroLarTemporario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ExtCtrls,
  FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Ani, REST.Types,
  FMX.ComboEdit, System.ImageList, FMX.ImgList;

type
  TfrmCadastroLarTemporario = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
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
    ImageList1: TImageList;
    btnVoltar: TButton;
    procedure btnCriarContaClick(Sender: TObject);
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
    procedure btnVoltarClick(Sender: TObject);
  private
    { Private declarations }
    foco: TControl;
  public
    { Public declarations }
    sNumero: String;
  end;

var
  frmCadastroLarTemporario: TfrmCadastroLarTemporario;

implementation

{$R *.fmx}

uses Notificacao, uDtmServidor, uFrmLogin, uPaginaInicial, JSON, System.Net.HttpClient;

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
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM cidades                     '+
                                    ' WHERE nome_cidade = '''+cbxCidade.Text+'''';
   dtmServidor.qryGeral.Active := True;

   iCodCidade := dtmServidor.qryGeral.FieldByName('cod_cidade').AsInteger;
   sUF := dtmServidor.qryGeral.FieldByName('uf').AsString;

   try
      dtmServidor.qryInsert.Active := False;
      dtmServidor.qryInsert.SQL.Clear;
      dtmServidor.qryInsert.SQL.Text := ' INSERT INTO LarTemporario (nome_lar,         '+
                                        ' 					   	             telefone_lar,     '+
                                        ' 				            	     des_endereco_lar, '+
                                        ' 				             	     des_bairro_lar,   '+
                                        ' 				            	     UF,               '+
                                        ' 				            	     qtd_animais,      '+
                                        ' 				            	     ind_telas,        '+
                                        ' 				            	     tipo_animal,      '+
                                        ' 				            	     informacoes_lar,  '+
                                        ' 				            	     ind_ativo,        '+
                                        ' 				             	     cod_pessoa,       '+
                                        '                            cod_cidade)       '+
                                        ' 				          VALUES (:nome_lar,         '+
                                        ' 				          	  		:telefone_lar,     '+
                                        ' 				          	  		:des_endereco_lar, '+
                                        ' 				             	    :des_bairro_lar,   '+
                                        ' 				          	  		:UF,               '+
                                        ' 				          	  		:qtd_animais,      '+
                                        ' 				          	  		:ind_telas,        '+
                                        ' 				          	  		:tipo_animal,      '+
                                        ' 				          	  		:informacoes_lar,  '+
                                        ' 				          	  		:ind_ativo,        '+
                                        ' 				          	  		:cod_pessoa,       '+
                                        '                           :cod_cidade);      ';

      if (edtNumero.Text = '') then
      begin
         sNumero := 'S/N';
      end
      else
      begin
         sNumero := edtNumero.Text;
      end;

      dtmServidor.qryInsert.ParamByName('nome_lar').AsString := edtNome.Text;
      dtmServidor.qryInsert.ParamByName('telefone_lar').AsString := edtTelefone.Text;
      dtmServidor.qryInsert.ParamByName('des_bairro_lar').AsString := edtBairro.Text;
      dtmServidor.qryInsert.ParamByName('des_endereco_lar').AsString := edtRua.Text +', '+sNumero;
      dtmServidor.qryInsert.ParamByName('UF').AsString := sUF;
      dtmServidor.qryInsert.ParamByName('qtd_animais').AsString := edtQuantidade.Text;
      dtmServidor.qryInsert.ParamByName('ind_telas').AsInteger := cbxTelas.ItemIndex;
      dtmServidor.qryInsert.ParamByName('tipo_animal').AsInteger := cbxTipoAnimal.ItemIndex;
      dtmServidor.qryInsert.ParamByName('informacoes_lar').AsString := mmoInformacoes.Text;
      dtmServidor.qryInsert.ParamByName('ind_ativo').AsString := '1';
      dtmServidor.qryInsert.ParamByName('cod_pessoa').AsString := frmLogin.sUsuarioLogado;
      dtmServidor.qryInsert.ParamByName('cod_cidade').AsInteger := iCodCidade;

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
                             TAlignLayout.Top);
      LimpaCampos(Sender);
   end;
end;

procedure TfrmCadastroLarTemporario.btnVoltarClick(Sender: TObject);
begin
   LimpaCampos(Sender);
   frmCadastroLarTemporario.Close;
   frmPaginaInicial.Show;
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
   if (cbxCidade.Items.Text = '') then
   begin
      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := ' SELECT nome_cidade   '+
                                       ' FROM cidades         '+
                                       ' ORDER BY nome_cidade ';
      dtmServidor.qryGeral.Active := True;

      while not dtmServidor.qryGeral.Eof do
      begin
         cbxCidade.Items.Add(dtmServidor.qryGeral.FieldByName('nome_cidade').AsString);

         dtmServidor.qryGeral.Next;
      end;
   end;

   LimpaCampos(Sender);
end;

procedure TfrmCadastroLarTemporario.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
   VertScrollBox1.Margins.Bottom := 0;
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
