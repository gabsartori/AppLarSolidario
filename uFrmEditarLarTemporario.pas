unit uFrmEditarLarTemporario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.ComboEdit, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, System.ImageList,
  FMX.ImgList;

type
  TfrmEditarLarTemporario = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    Label8: TLabel;
    V: TLayout;
    edtQuantidade: TEdit;
    Label2: TLabel;
    Label6: TLabel;
    Label10: TLabel;
    cbxTelas: TComboEdit;
    cbxTipoAnimal: TComboEdit;
    Layout3: TLayout;
    Label1: TLabel;
    edtNome: TEdit;
    Layout6: TLayout;
    Label7: TLabel;
    cbxCidade: TComboEdit;
    Layout7: TLayout;
    Label5: TLabel;
    edtRua: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    Layout8: TLayout;
    Label4: TLabel;
    edtBairro: TEdit;
    Layout9: TLayout;
    Label13: TLabel;
    edtTelefone: TEdit;
    Layout5: TLayout;
    Layout10: TLayout;
    mmoInformacoes: TMemo;
    Label3: TLabel;
    Layout4: TLayout;
    btnCancelar: TRoundRect;
    Label9: TLabel;
    btnAlterarCadastro: TRoundRect;
    Label11: TLabel;
    ImageList1: TImageList;
    btnVoltar: TButton;
    procedure btnVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function ExtrairNumeroAposVirgula(const Texto: string): string;
    procedure BuscaCodigoLar(CodLar: Integer);
    procedure btnAlterarCadastroClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    iCodigoLar: Integer;
  end;

var
  frmEditarLarTemporario: TfrmEditarLarTemporario;

implementation

{$R *.fmx}

uses uPaginaConfiguracoes, uDtmServidor, uFrmEditarAnimais, Notificacao;

procedure TfrmEditarLarTemporario.btnAlterarCadastroClick(Sender: TObject);
begin
      try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE Lar_Temporario '+
                                        ' SET Nome_Lar = :Nome_Lar, '+
                                        '     Telefone_Lar := :Telefone_Lar,     '+
                                        '     Qtd_Animais = :Qtd_Animais,'+
                                        '     UF = :UF, '+
                                        '     Ind_Telas = :Ind_Telas, '+
                                        '     Tipo_Animal = :Tipo_Animal, '+
                                        '     Informacoes_Lar = :Informacoes_Lar, '+
                                        '     SITUACAO_ANIMAL = :SITUACAO_ANIMAL, '+
                                        '     Des_Endereco_Lar = :Des_Endereco_Lar, '+
                                        '     Des_Bairro_Lar = :Des_Bairro_Lar, '+
                                        '     Cod_Cidade = :Cod_Cidade '+
                                        ' WHERE Cod_Lar = :Cod_Lar ';

      dtmServidor.qryUpdate.Params.ParamByName('Nome_Lar').AsString := edtNome.Text;
      dtmServidor.qryUpdate.Params.ParamByName('Telefone_Lar').AsString := edtTelefone.Text;
      dtmServidor.qryUpdate.Params.ParamByName('Qtd_Animais').AsString := edtQuantidade.Text;
      dtmServidor.qryUpdate.Params.ParamByName('Ind_Telas').AsInteger := cbxTelas.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('Tipo_Animal').AsInteger := cbxTipoAnimal.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('Informacoes_Lar').AsString := mmoInformacoes.Text;
      dtmServidor.qryUpdate.Params.ParamByName('Des_Endereco_Lar').AsString := edtRua.Text + ',' +edtNumero.Text;
      dtmServidor.qryUpdate.Params.ParamByName('Des_Bairro_Lar').AsString := edtBairro.Text;

      dtmServidor.qryGeral2.Active := False;
      dtmServidor.qryGeral2.SQL.Clear;
      dtmServidor.qryGeral2.SQL.Text := ' SELECT * FROM CIDADES       '+
                                        ' WHERE NOME_CIDADE = '+cbxCidade.Text;
      dtmServidor.qryGeral2.Active := True;

      dtmServidor.qryUpdate.Params.ParamByName('Cod_Cidade').AsString := dtmServidor.qryGeral2.FieldByName('COD_CIDADE').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('UF').AsString := dtmServidor.qryGeral2.FieldByName('UF').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('Cod_Lar').AsString := IntToStr(iCodigoLar); //INSERIR C�DIGO DO ANIMAL

      dtmServidor.qryInsert.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmEditarLarTemporario,
                              'N�o foi poss�vel realizar as altera��es!',
                               $FFFA3F3F,
                               TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmEditarLarTemporario,
                           'Registro atualizado com sucesso',
                            $FF22AF70,
                            TAlignLayout.Top);

      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM LarTemporario WHERE COD_LAR = '+IntToStr(iCodigoLar); //INSERIR C�DIGO DO ANIMAL
      dtmServidor.qryGeral.Active := True;

      edtNome.Text := dtmServidor.qryGeral.FieldByName('Nome_Lar').AsString;
      edtTelefone.Text := dtmServidor.qryGeral.FieldByName('Telefone_Lar').AsString;
      edtRua.Text := dtmServidor.qryGeral.FieldByName('Des_Endereco_Lar').AsString;
      edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('Des_Endereco_Lar').AsString);
      edtBairro.Text := dtmServidor.qryGeral.FieldByName('Des_Bairro_Lar').AsString;
      cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('Nome_Cidade').AsString;
      edtQuantidade.Text := dtmServidor.qryGeral.FieldByName('Qtd_Animais').AsString;
      cbxTelas.ItemIndex := dtmServidor.qryGeral.FieldByName('Ind_Telas').AsInteger;
      cbxTipoAnimal.ItemIndex := dtmServidor.qryGeral.FieldByName('Tipo_Animal').AsInteger;
      mmoInformacoes.Text := dtmServidor.qryGeral.FieldByName('Informacoes_Lar').AsString;
   end;
end;

procedure TfrmEditarLarTemporario.btnVoltarClick(Sender: TObject);
begin
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmEditarLarTemporario.BuscaCodigoLar(CodLar: Integer);
begin
   iCodigoLar := CodLar;
end;

function TfrmEditarLarTemporario.ExtrairNumeroAposVirgula(const Texto: string): string;
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

procedure TfrmEditarLarTemporario.FormShow(Sender: TObject);
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
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM LarTemporario WHERE COD_LAR = '+IntToStr(iCodigoLar);
   dtmServidor.qryGeral.Active := True;

   dtmServidor.qryGeral2.Active := False;
   dtmServidor.qryGeral2.SQL.Clear;
   dtmServidor.qryGeral2.SQL.Text := ' SELECT NOME_CIDADE '+
                                     ' FROM CIDADES       '+
                                     ' WHERE COD_CIDADE = '+dtmServidor.qryGeral.FieldByName('COD_CIDADE').AsString;
   dtmServidor.qryGeral2.Active := True;

   edtNome.Text := dtmServidor.qryGeral.FieldByName('Nome_Lar').AsString;
   edtTelefone.Text := dtmServidor.qryGeral.FieldByName('Telefone_Lar').AsString;
   edtRua.Text := dtmServidor.qryGeral.FieldByName('Des_Endereco_Lar').AsString;
   edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('Des_Endereco_Lar').AsString);
   edtBairro.Text := dtmServidor.qryGeral.FieldByName('Des_Bairro_Lar').AsString;
   cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('Nome_Cidade').AsString;
   edtQuantidade.Text := dtmServidor.qryGeral.FieldByName('Qtd_Animais').AsString;
   cbxTelas.ItemIndex := dtmServidor.qryGeral.FieldByName('Ind_Telas').AsInteger;
   cbxTipoAnimal.ItemIndex := dtmServidor.qryGeral.FieldByName('Tipo_Animal').AsInteger;
   mmoInformacoes.Text := dtmServidor.qryGeral.FieldByName('Informacoes_Lar').AsString;
end;

end.