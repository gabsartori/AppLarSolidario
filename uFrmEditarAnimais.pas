unit uFrmEditarAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ComboEdit, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.MediaLibrary.Actions, Data.DB, System.ImageList, FMX.ImgList;

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
  private
    { Private declarations }
  public
    { Public declarations }
    iCodigoAnimal: Integer;
  end;

var
  frmEditarAnimais: TfrmEditarAnimais;

implementation

{$R *.fmx}

uses uFunctions, uDtmServidor, uPaginaConfiguracoes, Notificacao;

procedure TfrmEditarAnimais.btnAlterarCadastroClick(Sender: TObject);
begin
      try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE ANIMAIS '+
                                        ' SET NOME_ANIMAL = :NOME_ANIMAL, '+
                                        '     GENERO_ANIMAL = :GENERO_ANIMAL,'+
                                        '     IDADE_ANIMAL = :IDADE_ANIMAL, '+
                                        '     COR_PELAGEM = :COR_PELAGEM, '+
                                        '     UF = :UF, '+
                                        '     IND_CASTRADO = :IND_CASTRADO, '+
                                        '     FOTO_ANIMAL = :FOTO_ANIMAL, '+
                                        '     TIPO_ANIMAL = :TIPO_ANIMAL, '+
                                        '     INFORMACOES_ANIMAL = :INFORMACOES_ANIMAL, '+
                                        '     SITUACAO_ANIMAL = :SITUACAO_ANIMAL, '+
                                        '     DES_ENDERECO_ANIMAL = :DES_ENDERECO_ANIMAL, '+
                                        '     DES_BAIRRO_ANIMAL = :DES_BAIRRO_ANIMAL, '+
                                        '     COD_CIDADE = :COD_CIDADE '+
                                        ' WHERE COD_ANIMAL = :COD_ANIMAL ';

      dtmServidor.qryUpdate.Params.ParamByName('NOME_ANIMAL').AsString := edtNome.Text;
      dtmServidor.qryUpdate.Params.ParamByName('GENERO_ANIMAL').AsInteger := cbxGenero.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('IDADE_ANIMAL').AsString := edtIdade.Text;
      dtmServidor.qryUpdate.Params.ParamByName('COR_PELAGEM').AsString := edtCorPelagem.Text;
      dtmServidor.qryUpdate.Params.ParamByName('IND_CASTRADO').AsInteger := cbxCastrado.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('TIPO_ANIMAL').AsInteger := cbxTipoAnimal.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('INFORMACOES_ANIMAL').AsString := mmoInformacoes.Text;
      dtmServidor.qryUpdate.Params.ParamByName('SITUACAO_ANIMAL').AsString := cbxSituacao.Text;
      dtmServidor.qryUpdate.Params.ParamByName('DES_ENDERECO_ANIMAL').AsString := edtRua.Text + ',' +edtNumero.Text;
      dtmServidor.qryUpdate.Params.ParamByName('DES_BAIRRO_ANIMAL').AsString := edtBairro.Text;

      dtmServidor.qryGeral2.Active := False;
      dtmServidor.qryGeral2.SQL.Clear;
      dtmServidor.qryGeral2.SQL.Text := ' SELECT * FROM CIDADES       '+
                                        ' WHERE NOME_CIDADE = '+cbxCidade.Text;
      dtmServidor.qryGeral2.Active := True;

      dtmServidor.qryUpdate.Params.ParamByName('COD_CIDADE').AsString := dtmServidor.qryGeral2.FieldByName('COD_CIDADE').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('UF').AsString := dtmServidor.qryGeral2.FieldByName('UF').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('COD_ANIMAL').AsString := IntToStr(iCodigoAnimal); //INSERIR C�DIGO DO ANIMAL

      dtmServidor.qryInsert.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmEditarAnimais,
                              'N�o foi poss�vel realizar as altera��es!',
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
      dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM ANIMAIS WHERE COD_ANIMAL = '+IntToStr(iCodigoAnimal); //INSERIR C�DIGO DO ANIMAL
      dtmServidor.qryGeral.Active := True;

      edtNome.Text := dtmServidor.qryGeral.FieldByName('Nome_Animal').AsString;
      edtCorPelagem.Text := dtmServidor.qryGeral.FieldByName('Cor_Pelagem').AsString;
      cbxCastrado.Text := dtmServidor.qryGeral.FieldByName('Ind_Castrado').AsString;
      cbxGenero.Text := dtmServidor.qryGeral.FieldByName('Des_Endereco_Animal').AsString;
      edtRua.Text := dtmServidor.qryGeral.FieldByName('Des_Endereco_Animal').AsString;
      edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('Des_Endereco_Animal').AsString);
      edtBairro.Text := dtmServidor.qryGeral.FieldByName('Des_Bairro_Animal').AsString;
      cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('Nome_Cidade').AsString;
   end;
end;

procedure TfrmEditarAnimais.btnCancelarClick(Sender: TObject);
begin
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmEditarAnimais.BuscaCodigoAnimal(CodAnimal: Integer);
begin
   iCodigoAnimal := CodAnimal;
end;

procedure TfrmEditarAnimais.btnVoltarClick(Sender: TObject);
begin
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

procedure TfrmEditarAnimais.FormShow(Sender: TObject);
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

   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Clear;
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM ANIMAIS WHERE COD_ANIMAL = '+IntToStr(iCodigoAnimal);
   dtmServidor.qryGeral.Active := True;

   dtmServidor.qryGeral2.Active := False;
   dtmServidor.qryGeral2.SQL.Clear;
   dtmServidor.qryGeral2.SQL.Text := ' SELECT NOME_CIDADE '+
                                     ' FROM CIDADES       '+
                                     ' WHERE COD_CIDADE = '+dtmServidor.qryGeral.FieldByName('COD_CIDADE').AsString;
   dtmServidor.qryGeral2.Active := True;

   edtNome.Text := dtmServidor.qryGeral.FieldByName('Nome_Animal').AsString;
   edtCorPelagem.Text := dtmServidor.qryGeral.FieldByName('Cor_Palgem').AsString;
   edtRua.Text := dtmServidor.qryGeral.FieldByName('Des_Endereco_Animal').AsString;
   edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('Des_Endereco_Animal').AsString);
   edtBairro.Text := dtmServidor.qryGeral.FieldByName('Des_Bairro_Animal').AsString;
   cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('Nome_Cidade').AsString;
   mmoInformacoes.Text := dtmServidor.qryGeral.FieldByName('Informacoes_Animal').AsString;

   if dtmServidor.qryGeral.FieldByName('foto_animal').AsString <> '' then
   begin
      TFunctions.LoadBitmapFromBlob(cFotoEditar.Fill.Bitmap.Bitmap,
                                    TBlobField(dtmServidor.qryGeral.FieldByName('foto_animal')));
      cFotoEditar.Repaint;
   end;

   cbxCastrado.ItemIndex := dtmServidor.qryGeral.FieldByName('Ind_Castrado').AsInteger;
   cbxGenero.ItemIndex := dtmServidor.qryGeral.FieldByName('Genero_Animal').AsInteger;
   cbxTipoAnimal.ItemIndex := dtmServidor.qryGeral.FieldByName('Tipo_Animal').AsInteger;
   cbxSituacao.Text := dtmServidor.qryGeral.FieldByName('Situacao_Animal').AsString;
end;

end.
