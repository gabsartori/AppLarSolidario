unit uFrmCadastroAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Actions, FMX.ActnList, u99Permissions,
  FMX.StdActns, FMX.MediaLibrary.Actions, REST.Types, FMX.ComboEdit,
  System.ImageList, FMX.ImgList;

type
  TfrmCadastroAnimais = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    Label8: TLabel;
    Layout4: TLayout;
    Layout3: TLayout;
    Label1: TLabel;
    edtNome: TEdit;
    Layout9: TLayout;
    Label13: TLabel;
    edtCorPelagem: TEdit;
    ActionList1: TActionList;
    actBuscaFoto: TTakePhotoFromLibraryAction;
    Layout7: TLayout;
    Label3: TLabel;
    edtIdade: TEdit;
    Cas: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Layout6: TLayout;
    Layout10: TLayout;
    Label7: TLabel;
    Layout11: TLayout;
    Label10: TLabel;
    Layout5: TLayout;
    btnCriarConta: TRoundRect;
    Label9: TLabel;
    Layout12: TLayout;
    Label6: TLabel;
    edtRua: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    Label15: TLabel;
    cFotoEditar: TCircle;
    mmoInformacoes: TMemo;
    Layout13: TLayout;
    Label14: TLabel;
    cbxSituacao: TComboEdit;
    cbxCastrado: TComboEdit;
    cbxTipoAnimal: TComboEdit;
    cbxGenero: TComboEdit;
    cbxCidade: TComboEdit;
    Layout8: TLayout;
    Label5: TLabel;
    edtBairro: TEdit;
    btnVoltar: TButton;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actBuscaFotoDidFinishTaking(Image: TBitmap);
    procedure btnCriarContaClick(Sender: TObject);
    procedure cFotoEditarClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure LimpaCampos(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  //  procedure edtCepExit(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure edtCorPelagemEnter(Sender: TObject);
    procedure edtIdadeEnter(Sender: TObject);
    procedure cbxCastradoEnter(Sender: TObject);
    procedure cbxGeneroEnter(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edtRuaEnter(Sender: TObject);
    procedure edtNumeroEnter(Sender: TObject);
    procedure edtBairroEnter(Sender: TObject);
    procedure cbxCidadeEnter(Sender: TObject);
    procedure cbxSituacaoEnter(Sender: TObject);
    procedure mmoInformacoesEnter(Sender: TObject);
  private
    { Private declarations }
    foco: TControl;
    permissao: T99Permissions;
    procedure TratarErroPermissao(Sender: TObject);

  public
    { Public declarations }
    sNumero: String;
  end;

var
  frmCadastroAnimais: TfrmCadastroAnimais;

implementation

{$R *.fmx}

uses uDtmServidor, uFrmLogin, uPaginaInicial, Notificacao , JSON, System.Net.HttpClient;

procedure Ajustar_Scroll();
var
   x: Integer;
begin
   with frmCadastroAnimais do
   begin
      VertScrollBox1.Margins.Bottom := 250;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                TControl(foco).Position.Y - 150);
   end;
end;

procedure TfrmCadastroAnimais.actBuscaFotoDidFinishTaking(Image: TBitmap);
begin
   cFotoEditar.Fill.Bitmap.Bitmap := Image;
end;

procedure TfrmCadastroAnimais.btnCriarContaClick(Sender: TObject);
var
   iCodCidade: Integer;
   sUF: String;
begin
   if edtNome.Text = '' then
   begin
      ShowMessage('Informe o nome');
      Exit;
   end;

   if edtBairro.Text = '' then
   begin
      ShowMessage('Informe o bairro');
      Exit;
   end;

   if cFotoEditar.Fill.Bitmap.Bitmap = nil then
   begin
      ShowMessage('Insira a foto do pet');
      Exit;
   end;

   if edtRua.Text = '' then
   begin
      ShowMessage('Informe o endereço');
      Exit;
   end;

   if edtCorPelagem.Text = '' then
   begin
      ShowMessage('Informe a cor da pelagem');
      Exit;
   end;

   if (cbxTipoAnimal.ItemIndex = 0) then
   begin
      ShowMessage('Selecione uma opção de pet');
      Exit;
   end;

   if (cbxGenero.ItemIndex = 0) then
   begin
      ShowMessage('Selecione uma opção de gênero');
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
      dtmServidor.qryInsert.SQL.Text := ' INSERT INTO Animais (nome_animal,        '+
                                       '                       genero_animal,      '+
                                       '                       idade_animal,       '+
                                       '                       cor_pelagem, '+
                                       '                       ind_ativo,   '+
                                       '                       UF,          '+
                                       '                       ind_castrado,'+
                                       '                       foto_animal,        '+
                                       '                       tipo_animal, '+
                                       '                       informacoes_animal, '+
                                       '                       situacao_animal,    '+
                                       '                       des_endereco_animal,    '+
                                       '                       des_bairro_animal, '+
                                       '                       cod_cidade,      '+
                                       '                       cod_Pessoa)  '+
                                       '              VALUES (:nome_animal,        '+
                                       '                      :genero_animal,      '+
                                       '                      :idade_animal,       '+
                                       '                      :cor_pelagem, '+
                                       '                      :ind_ativo,   '+
                                       '                      :UF,          '+
                                       '                      :ind_castrado,'+
                                       '                      :foto_animal,        '+
                                       '                      :tipo_animal, '+
                                       '                      :informacoes_animal, '+
                                       '                      :situacao_animal,    '+
                                       '                      :des_endereco_animal,    '+
                                       '                      :des_bairro_animal, '+
                                       '                      :cod_cidade,      '+
                                       '                      :cod_Pessoa); ';

      if (edtNumero.Text = '') then
      begin
         sNumero := 'S/N';
      end
      else
      begin
         sNumero := edtNumero.Text;
      end;

      dtmServidor.qryInsert.ParamByName('nome_animal').AsString := edtNome.Text;
      dtmServidor.qryInsert.ParamByName('idade_animal').AsString := edtIdade.Text;
      dtmServidor.qryInsert.ParamByName('genero_animal').AsInteger := cbxGenero.ItemIndex;
      dtmServidor.qryInsert.ParamByName('cor_pelagem').AsString := edtCorPelagem.Text;
      dtmServidor.qryInsert.ParamByName('des_endereco_animal').AsString := edtRua.Text +', '+ sNumero;
      dtmServidor.qryInsert.ParamByName('des_bairro_animal').AsString := edtBairro.Text;
      dtmServidor.qryInsert.ParamByName('UF').AsString := sUF;
      dtmServidor.qryInsert.ParamByName('cod_cidade').AsInteger := iCodCidade;
      dtmServidor.qryInsert.ParamByName('tipo_animal').AsInteger := cbxTipoAnimal.ItemIndex;
      dtmServidor.qryInsert.ParamByName('ind_ativo').AsString := '1';
      dtmServidor.qryInsert.ParamByName('ind_castrado').AsInteger := cbxCastrado.ItemIndex;

      if cFotoEditar.Fill.Bitmap.Bitmap <> nil then
      begin
         dtmServidor.qryInsert.ParamByName('foto_animal').Assign(cFotoEditar.Fill.Bitmap.Bitmap);
      end
      else
      begin
         dtmServidor.qryInsert.ParamByName('foto_animal').Value := unassigned;
      end;

      dtmServidor.qryInsert.ParamByName('informacoes_animal').AsString := mmoInformacoes.Text;
      dtmServidor.qryInsert.ParamByName('situacao_animal').AsString := cbxSituacao.Text;
      dtmServidor.qryInsert.ParamByName('cod_Pessoa').AsString := frmLogin.sUsuarioLogado;

      dtmServidor.qryInsert.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmCadastroAnimais,
                            'Não foi possível realizar o cadastro!',
                             $FFFA3F3F,
                             TAlignLayout.Top);
         Exit;
      end;
   finally
      TLoading.ToastMessage(frmCadastroAnimais,
                            'Cadastrado com sucesso!',
                             $FF22AF70,
                             TAlignLayout.Top);
      LimpaCampos(Sender);
   end;
end;

procedure TfrmCadastroAnimais.cbxCastradoEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.cbxCidadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.cbxGeneroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.cbxSituacaoEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.cFotoEditarClick(Sender: TObject);
begin
   {$IFDEF MSWINDOWS}
   {$ELSE}
   permissao.PhotoLibrary(actBuscaFoto, TratarErroPermissao);
   {$ENDIF}
end;

procedure TfrmCadastroAnimais.edtBairroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.edtCorPelagemEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.edtIdadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.edtNomeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.edtNumeroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.edtRuaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   LimpaCampos(Sender);
end;

procedure TfrmCadastroAnimais.FormCreate(Sender: TObject);
begin
   permissao := T99Permissions.Create;
end;

procedure TfrmCadastroAnimais.FormDestroy(Sender: TObject);
begin
   permissao.DisposeOf;
end;

procedure TfrmCadastroAnimais.FormShow(Sender: TObject);
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

procedure TfrmCadastroAnimais.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds
  : TRect);
begin
   VertScrollBox1.Margins.Bottom := 0;
end;

procedure TfrmCadastroAnimais.btnVoltarClick(Sender: TObject);
begin
   frmCadastroAnimais.Close;
   LimpaCampos(Sender);
   frmPaginaInicial.Show;
end;

procedure TfrmCadastroAnimais.LimpaCampos(Sender: TObject);
begin
   edtNome.Text := '';
   edtCorPelagem.Text := '';
   edtIdade.Text := '';
   edtRua.Text := '';
   edtBairro.Text := '';
   edtNumero.Text := '';
   cbxSituacao.ItemIndex := 0;
   cbxCastrado.ItemIndex := 0;
   cbxTipoAnimal.ItemIndex := 0;
   cbxGenero.ItemIndex := 0;
   cbxCidade.ItemIndex := 0;
   cFotoEditar.Fill.Bitmap.Bitmap := nil;
   mmoInformacoes.Text := '';
end;

procedure TfrmCadastroAnimais.mmoInformacoesEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCadastroAnimais.TratarErroPermissao(Sender: TObject);
begin
   ShowMessage('Você não possui permissão para este recurso!');
end;

end.
