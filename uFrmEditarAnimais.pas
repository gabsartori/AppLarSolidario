unit uFrmEditarAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ComboEdit, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.MediaLibrary.Actions, Data.DB, System.ImageList, FMX.ImgList,
  u99Permissions;

type
  TfrmEditarAnimais = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    Label8: TLabel;
    Layout4: TLayout;
    Label15: TLabel;
    cFotoEditar: TCircle;
    Layout3: TLayout;
    Label1: TLabel;
    edtNome: TEdit;
    Layout9: TLayout;
    Label13: TLabel;
    edtCorPelagem: TEdit;
    Layout6: TLayout;
    Layout12: TLayout;
    Label6: TLabel;
    edtRua: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    Layout10: TLayout;
    Label7: TLabel;
    cbxCidade: TComboEdit;
    Layout11: TLayout;
    Label10: TLabel;
    mmoInformacoes: TMemo;
    Layout5: TLayout;
    Layout13: TLayout;
    Label14: TLabel;
    cbxSituacao: TComboEdit;
    Layout8: TLayout;
    Label5: TLabel;
    edtBairro: TEdit;
    ActionList1: TActionList;
    actBuscaFoto: TTakePhotoFromLibraryAction;
    Layout14: TLayout;
    btnCancelar: TRoundRect;
    Label11: TLabel;
    btnAlterarCadastro: TRoundRect;
    Label16: TLabel;
    Layout7: TLayout;
    Label3: TLabel;
    edtIdade: TEdit;
    Cas: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    cbxCastrado: TComboEdit;
    cbxTipoAnimal: TComboEdit;
    cbxGenero: TComboEdit;
    btnVoltar: TButton;
    ImageList1: TImageList;
    procedure FormShow(Sender: TObject);
    function ExtrairNumeroAposVirgula(const Texto: string): string;
    procedure btnAlterarCadastroClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure BuscaCodigoAnimal(CodAnimal: Integer);
    procedure btnVoltarClick(Sender: TObject);
    function ExtrairStringAntesVirgula(const Texto: string): string;
    procedure cFotoEditarClick(Sender: TObject);
    procedure actBuscaFotoDidFinishTaking(Image: TBitmap);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure edtCorPelagemEnter(Sender: TObject);
    procedure edtRuaEnter(Sender: TObject);
    procedure edtNumeroEnter(Sender: TObject);
    procedure edtIdadeEnter(Sender: TObject);
    procedure cbxCastradoEnter(Sender: TObject);
    procedure cbxGeneroEnter(Sender: TObject);
    procedure cbxTipoAnimalEnter(Sender: TObject);
    procedure edtBairroEnter(Sender: TObject);
    procedure cbxCidadeEnter(Sender: TObject);
    procedure cbxSituacaoEnter(Sender: TObject);
    procedure mmoInformacoesEnter(Sender: TObject);
  private
    { Private declarations }
    permissao: T99Permissions;
    procedure TratarErroPermissao(Sender: TObject);
  public
    { Public declarations }
    foco: TControl;
    iCodigoAnimal: Integer;
  end;

var
  frmEditarAnimais: TfrmEditarAnimais;

implementation

{$R *.fmx}

uses uFunctions, uDtmServidor, uPaginaConfiguracoes, Notificacao,
  uFrmEdicaoAnimais;

procedure Ajustar_Scroll();
var
   x: Integer;
begin
   with frmEditarAnimais do
   begin
      VertScrollBox1.Margins.Bottom := 250;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                TControl(foco).Position.Y - 150);
   end;
end;

procedure TfrmEditarAnimais.actBuscaFotoDidFinishTaking(Image: TBitmap);
begin
   cFotoEditar.Fill.Bitmap.Bitmap := Image;
end;

procedure TfrmEditarAnimais.btnAlterarCadastroClick(Sender: TObject);
begin
      try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE animais                                  '+
                                        ' SET nome_animal = :nome_animal,                 '+
                                        '     genero_animal = :genero_animal,             '+
                                        '     idade_animal = :idade_animal,               '+
                                        '     cor_pelagem = :cor_pelagem,                 '+
                                        '     UF = :UF,                                   '+
                                        '     ind_castrado = :ind_castrado,               '+
                                        '     foto_animal = :foto_animal,                 '+
                                        '     tipo_animal = :tipo_animal,                 '+
                                        '     informacoes_animal = :informacoes_animal,   '+
                                        '     situacao_animal = :situacao_animal,         '+
                                        '     des_endereco_animal = :des_endereco_animal, '+
                                        '     des_bairro_animal = :des_bairro_animal,     '+
                                        '     cod_cidade = :cod_cidade                    '+
                                        ' WHERE cod_animal = :cod_animal                  ';

      dtmServidor.qryUpdate.Params.ParamByName('nome_animal').AsString := edtNome.Text;
      dtmServidor.qryUpdate.Params.ParamByName('genero_animal').AsInteger := cbxGenero.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('idade_animal').AsString := edtIdade.Text;
      dtmServidor.qryUpdate.Params.ParamByName('cor_pelagem').AsString := edtCorPelagem.Text;
      dtmServidor.qryUpdate.Params.ParamByName('ind_castrado').AsInteger := cbxCastrado.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('tipo_animal').AsInteger := cbxTipoAnimal.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('informacoes_animal').AsString := mmoInformacoes.Text;
      dtmServidor.qryUpdate.Params.ParamByName('situacao_animal').AsString := cbxSituacao.Text;
      dtmServidor.qryUpdate.Params.ParamByName('des_endereco_animal').AsString := edtRua.Text + ', ' +edtNumero.Text;
      dtmServidor.qryUpdate.Params.ParamByName('des_bairro_animal').AsString := edtBairro.Text;

      if cFotoEditar.Fill.Bitmap.Bitmap <> nil then
      begin
         dtmServidor.qryUpdate.ParamByName('foto_animal').Assign(cFotoEditar.Fill.Bitmap.Bitmap);
      end
      else
      begin
         dtmServidor.qryUpdate.ParamByName('foto_animal').Value := unassigned;
      end;

      dtmServidor.qryGeral2.Active := False;
      dtmServidor.qryGeral2.SQL.Clear;
      dtmServidor.qryGeral2.SQL.Text := ' SELECT * FROM cidades            '+
                                        ' WHERE nome_cidade = :nome_cidade ';

      dtmServidor.qryGeral2.Params.ParamByName('nome_cidade').AsString := cbxCidade.Text;
      dtmServidor.qryGeral2.Active := True;

      dtmServidor.qryUpdate.Params.ParamByName('cod_cidade').AsString := dtmServidor.qryGeral2.FieldByName('cod_cidade').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('UF').AsString := dtmServidor.qryGeral2.FieldByName('UF').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('cod_animal').AsString := IntToStr(iCodigoAnimal);

      dtmServidor.qryUpdate.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmEditarAnimais,
                              'Não foi possível realizar as alterações!',
                               $FFFA3F3F,
                               TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmEditarAnimais,
                           'Registro atualizado com sucesso',
                            $FF22AF70,
                            TAlignLayout.Top);

      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM animais '+
                                       ' WHERE cod_animal = '+IntToStr(iCodigoAnimal);
      dtmServidor.qryGeral.Active := True;

      frmEdicaoAnimais.LimpaTodosFramesEditarAnimais;
      frmEdicaoAnimais.ListarAnimais;
      frmEdicaoAnimais.Show;
   end;
end;

procedure TfrmEditarAnimais.btnCancelarClick(Sender: TObject);
begin
   frmEditarAnimais.Close;
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmEditarAnimais.BuscaCodigoAnimal(CodAnimal: Integer);
begin
   iCodigoAnimal := CodAnimal;
end;

procedure TfrmEditarAnimais.cbxCastradoEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.cbxCidadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.cbxGeneroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.cbxSituacaoEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.cbxTipoAnimalEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.cFotoEditarClick(Sender: TObject);
begin
   {$IFDEF MSWINDOWS}
   {$ELSE}
   permissao.PhotoLibrary(actBuscaFoto, TratarErroPermissao);
   {$ENDIF}
end;

procedure TfrmEditarAnimais.edtBairroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.edtCorPelagemEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.edtIdadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.edtNomeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.edtNumeroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.edtRuaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.btnVoltarClick(Sender: TObject);
begin
   frmEditarAnimais.Close;
   frmPaginaConfiguracoes.Show;
end;

function TfrmEditarAnimais.ExtrairNumeroAposVirgula(const Texto: string): string;
var
  PosicaoVirgula: Integer;
begin
   PosicaoVirgula := Pos(',', Texto);
   if PosicaoVirgula > 0 then
   begin
      Result := Trim(Copy(Texto, PosicaoVirgula + 1, Length(Texto) - PosicaoVirgula));
   end
   else
   begin
      Result := '';
   end;
end;

function TfrmEditarAnimais.ExtrairStringAntesVirgula(const Texto: string): string;
var
  VirgulaPos: Integer;
begin
  VirgulaPos := Pos(',', Texto);
  if VirgulaPos > 0 then
    Result := Copy(Texto, 1, VirgulaPos - 1)
  else
    Result := Texto;

end;

procedure TfrmEditarAnimais.FormCreate(Sender: TObject);
begin
   permissao := T99Permissions.Create;
end;

procedure TfrmEditarAnimais.FormDestroy(Sender: TObject);
begin
   permissao.DisposeOf;
end;

procedure TfrmEditarAnimais.FormShow(Sender: TObject);
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

   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Clear;
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM animais                      '+
                                    ' WHERE cod_animal = '+IntToStr(iCodigoAnimal);
   dtmServidor.qryGeral.Active := True;

   dtmServidor.qryGeral2.Active := False;
   dtmServidor.qryGeral2.SQL.Clear;
   dtmServidor.qryGeral2.SQL.Text := ' SELECT nome_cidade '+
                                     ' FROM cidades       '+
                                     ' WHERE cod_cidade = '+dtmServidor.qryGeral.FieldByName('cod_cidade').AsString;
   dtmServidor.qryGeral2.Active := True;

   edtNome.Text := dtmServidor.qryGeral.FieldByName('nome_animal').AsString;
   edtCorPelagem.Text := dtmServidor.qryGeral.FieldByName('cor_pelagem').AsString;
   edtRua.Text := ExtrairStringAntesVirgula(dtmServidor.qryGeral.FieldByName('des_endereco_animal').AsString);
   edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('des_endereco_animal').AsString);
   edtBairro.Text := dtmServidor.qryGeral.FieldByName('des_bairro_animal').AsString;
   edtIdade.Text := dtmServidor.qryGeral.FieldByName('idade_animal').AsString;
   cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('nome_cidade').AsString;
   mmoInformacoes.Text := dtmServidor.qryGeral.FieldByName('informacoes_animal').AsString;

   if dtmServidor.qryGeral.FieldByName('foto_animal').AsString <> '' then
   begin
      TFunctions.LoadBitmapFromBlob(cFotoEditar.Fill.Bitmap.Bitmap,
                                    TBlobField(dtmServidor.qryGeral.FieldByName('foto_animal')));
      cFotoEditar.Repaint;
   end;

   cbxCastrado.ItemIndex := dtmServidor.qryGeral.FieldByName('ind_castrado').AsInteger;
   cbxGenero.ItemIndex := dtmServidor.qryGeral.FieldByName('genero_animal').AsInteger;
   cbxTipoAnimal.ItemIndex := dtmServidor.qryGeral.FieldByName('tipo_animal').AsInteger;
   cbxSituacao.Text := dtmServidor.qryGeral.FieldByName('situacao_animal').AsString;
end;

procedure TfrmEditarAnimais.mmoInformacoesEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarAnimais.TratarErroPermissao(Sender: TObject);
begin
   ShowMessage('Você não possui permissão para este recurso!');
end;

end.
