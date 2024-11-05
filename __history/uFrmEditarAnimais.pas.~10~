unit uFrmEditarAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.ComboEdit, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.MediaLibrary.Actions, Data.DB;

type
  TfrmEditarAnimais = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    imgVoltar: TImage;
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
    procedure FormShow(Sender: TObject);
    function ExtrairNumeroAposVirgula(const Texto: string): string;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditarAnimais: TfrmEditarAnimais;

implementation

{$R *.fmx}

uses uFunctions;

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
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM ANIMAIS WHERE COD_ANIMAL = '+frmLogin.sUsuarioLogado;
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
      Frame.cFotoAnimal.Repaint;
   end;
end;

end.
