unit uFrmCadastroAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ListBox, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Actions, FMX.ActnList, u99Permissions,
  FMX.StdActns, FMX.MediaLibrary.Actions;

type
  TfrmCadastroAnimais = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    imgVoltar: TImage;
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
    cbxCastrado: TComboBox;
    cbxGenero: TComboBox;
    cbxTipoAnimal: TComboBox;
    Label4: TLabel;
    Layout8: TLayout;
    Label5: TLabel;
    edtCep: TEdit;
    Layout6: TLayout;
    Layout10: TLayout;
    edtCidade: TEdit;
    Label7: TLabel;
    Layout11: TLayout;
    mmoInformacoes: TMemo;
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
    Label11: TLabel;
    Label14: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actBuscaFotoDidFinishTaking(Image: TBitmap);
    procedure btnCriarContaClick(Sender: TObject);
    procedure cFotoEditarClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
  private
    { Private declarations }
    permissao: T99Permissions;
    procedure TratarErroPermissao(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmCadastroAnimais: TfrmCadastroAnimais;

implementation

{$R *.fmx}

uses uDtmServidor, uLogin, uPaginaInicial, Notificacao;

procedure TfrmCadastroAnimais.actBuscaFotoDidFinishTaking(Image: TBitmap);
begin
   cFotoEditar.Fill.Bitmap.Bitmap := Image;
end;

procedure TfrmCadastroAnimais.btnCriarContaClick(Sender: TObject);
begin
   if edtNome.Text = '' then
   begin
      ShowMessage('Informe o nome');
      Exit;
   end;

   if cFotoEditar.Fill.Bitmap.Bitmap = nil then
   begin
      ShowMessage('Insira a foto do pet');
      Exit;
   end;

   if edtRua.Text = '' then
   begin
      ShowMessage('Informe a rua');
      Exit;
   end;

   if edtCidade.Text = '' then
   begin
      ShowMessage('Informe a cidade');
      Exit;
   end;

   if edtCorPelagem.Text = '' then
   begin
      ShowMessage('Informe a cor da pelagem');
      Exit;
   end;

   try
      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := ' insert into Animais (Nome,         '+
                                       '                      Idade,        '+
                                       '                      Genero,       '+
                                       '                      Cor_Pelagem,  '+
                                       '                      CEP,          '+
                                       '                      Endereco,     '+
                                       '                      Cidade,       '+
                                       '                      Tipo_Animal,  '+
                                       '                      Ind_Ativo,    '+
                                       '                      Ind_Castrado, '+
                                       '                      Foto,         '+
                                       '                      Informacoes,  '+
                                       '                      Cod_Pessoa)   '+
                                       '             values (:Nome,         '+
                                       '                     :Idade,        '+
                                       '                     :Genero,       '+
                                       '                     :Cor_Pelagem,  '+
                                       '                     :CEP,          '+
                                       '                     :Endereco,     '+
                                       '                     :Cidade,       '+
                                       '                     :Tipo_Animal,  '+
                                       '                     :ind_ativo,    '+
                                       '                     :ind_Castrado, '+
                                       '                     :foto,         '+
                                       '                     :informacoes,  '+
                                       '                     :cod_pessoa);  ';

      dtmServidor.qryGeral.ParamByName('nome').AsString := edtNome.Text;
      dtmServidor.qryGeral.ParamByName('idade').AsString := edtIdade.Text;
      dtmServidor.qryGeral.ParamByName('genero').AsInteger := cbxGenero.ItemIndex;
      dtmServidor.qryGeral.ParamByName('cor_pelagem').AsString := edtCorPelagem.Text;
      dtmServidor.qryGeral.ParamByName('cep').AsString := edtCep.Text;
      dtmServidor.qryGeral.ParamByName('endereco').AsString := edtRua.Text +', '+edtNumero.Text;
      dtmServidor.qryGeral.ParamByName('cidade').AsString := edtCidade.Text;
      dtmServidor.qryGeral.ParamByName('tipo_animal').AsInteger := cbxTipoAnimal.ItemIndex;
      dtmServidor.qryGeral.ParamByName('ind_ativo').AsString := '1';
      dtmServidor.qryGeral.ParamByName('ind_castrado').AsInteger := cbxCastrado.ItemIndex;

      if cFotoEditar.Fill.Bitmap.Bitmap <> nil then
      begin
         dtmServidor.qryGeral.ParamByName('imagem_usuario').Assign(cFotoEditar.Fill.Bitmap.Bitmap);
      end
      else
      begin
//         dtmServidor.qryGeral.ParamByName('imagem_usuario').DataType := ftString;
         dtmServidor.qryGeral.ParamByName('imagem_usuario').Value := unassigned;
      end;

      dtmServidor.qryGeral.ParamByName('informacoes').AsString := mmoInformacoes.Text;
      dtmServidor.qryGeral.ParamByName('cod_pessoa').AsString := frmLogin.sUsuarioLogado;

      dtmServidor.qryGeral.ExecSQL;

      if dtmServidor.fdConexao.InTransaction then
      begin
         dtmServidor.fdConexao.Commit;
      end;
   finally
      TLoading.ToastMessage(frmCadastroAnimais,
                            'Cadastrado com sucesso!',
                             $FF22AF70,
                             TAlignLayout.Bottom);
      frmPaginaInicial.Show;
   end;
end;

procedure TfrmCadastroAnimais.cFotoEditarClick(Sender: TObject);
begin
   {$IFDEF MSWINDOWS}
   {$ELSE}
   permissao.PhotoLibrary(actBuscaFoto, TratarErroPermissao);
   {$ENDIF}
end;

procedure TfrmCadastroAnimais.FormCreate(Sender: TObject);
begin
   permissao := T99Permissions.Create;
end;

procedure TfrmCadastroAnimais.FormDestroy(Sender: TObject);
begin
   permissao.DisposeOf;
end;

procedure TfrmCadastroAnimais.imgVoltarClick(Sender: TObject);
begin
   frmPaginaInicial.Show;
end;

procedure TfrmCadastroAnimais.TratarErroPermissao(Sender: TObject);
begin
   ShowMessage('Você não possui permissão para este recurso!');
end;

end.
