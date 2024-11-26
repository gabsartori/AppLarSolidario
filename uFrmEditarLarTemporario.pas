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
    function ExtrairStringAntesVirgula(const Texto: string): string;
    procedure btnCancelarClick(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure edtTelefoneEnter(Sender: TObject);
    procedure edtRuaEnter(Sender: TObject);
    procedure edtNumeroEnter(Sender: TObject);
    procedure edtBairroEnter(Sender: TObject);
    procedure cbxCidadeEnter(Sender: TObject);
    procedure edtQuantidadeEnter(Sender: TObject);
    procedure cbxTelasEnter(Sender: TObject);
    procedure cbxTipoAnimalEnter(Sender: TObject);
    procedure mmoInformacoesEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    foco: TControl;
    iCodigoLar: Integer;
  end;

var
  frmEditarLarTemporario: TfrmEditarLarTemporario;

implementation

{$R *.fmx}

uses uPaginaConfiguracoes, uDtmServidor, uFrmEditarAnimais, Notificacao,
  uFrmEdicaoLares;

procedure Ajustar_Scroll();
var
   x: Integer;
begin
   with frmEditarLarTemporario do
   begin
      VertScrollBox1.Margins.Bottom := 250;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                TControl(foco).Position.Y - 150);
   end;
end;

procedure TfrmEditarLarTemporario.btnAlterarCadastroClick(Sender: TObject);
begin
   try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE LarTemporario '+
                                        ' SET nome_lar = :nome_lar, '+
                                        '     telefone_lar = :telefone_lar,     '+
                                        '     qtd_animais = :qtd_animais,'+
                                        '     UF = :UF, '+
                                        '     ind_telas = :ind_telas, '+
                                        '     tipo_animal = :tipo_animal, '+
                                        '     informacoes_lar = :informacoes_lar, '+
                                        '     des_endereco_lar = :des_endereco_lar, '+
                                        '     des_bairro_lar = :des_bairro_lar, '+
                                        '     cod_cidade = :Cod_Cidade '+
                                        ' WHERE Cod_Lar = :Cod_Lar ';

      dtmServidor.qryUpdate.Params.ParamByName('nome_lar').AsString := edtNome.Text;
      dtmServidor.qryUpdate.Params.ParamByName('telefone_lar').AsString := edtTelefone.Text;
      dtmServidor.qryUpdate.Params.ParamByName('qtd_animais').AsString := edtQuantidade.Text;
      dtmServidor.qryUpdate.Params.ParamByName('ind_telas').AsInteger := cbxTelas.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('tipo_animal').AsInteger := cbxTipoAnimal.ItemIndex;
      dtmServidor.qryUpdate.Params.ParamByName('informacoes_lar').AsString := mmoInformacoes.Text;
      dtmServidor.qryUpdate.Params.ParamByName('des_endereco_lar').AsString := edtRua.Text + ', ' +edtNumero.Text;
      dtmServidor.qryUpdate.Params.ParamByName('des_bairro_lar').AsString := edtBairro.Text;

      dtmServidor.qryGeral2.Active := False;
      dtmServidor.qryGeral2.SQL.Clear;
      dtmServidor.qryGeral2.SQL.Text := ' SELECT * FROM cidades            '+
                                        ' WHERE nome_cidade = :nome_cidade ';

      dtmServidor.qryGeral2.Params.ParamByName('nome_cidade').AsString := cbxCidade.Text;
      dtmServidor.qryGeral2.Active := True;

      dtmServidor.qryUpdate.Params.ParamByName('cod_cidade').AsString := dtmServidor.qryGeral2.FieldByName('COD_CIDADE').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('UF').AsString := dtmServidor.qryGeral2.FieldByName('UF').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('cod_lar').AsString := IntToStr(iCodigoLar);

      try
         dtmServidor.qryUpdate.ExecSQL;
      except
         on E: Exception do
         begin
            ShowMessage(E.Message);
         end;
      end;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmEditarLarTemporario,
                              'Não foi possível realizar as alterações!',
                               $FFFA3F3F,
                               TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmEdicaoLares,
                           'Registro atualizado com sucesso',
                            $FF22AF70,
                            TAlignLayout.Top);

      frmEdicaoLares.LimpaTodosFramesEditarLares;
      frmEdicaoLares.ListarLares;
      frmEdicaoLares.Show;
   end;
end;

procedure TfrmEditarLarTemporario.btnCancelarClick(Sender: TObject);
begin
   frmEdicaoLares.Show;
end;

procedure TfrmEditarLarTemporario.btnVoltarClick(Sender: TObject);
begin
   btnCancelarClick(Sender);
end;

procedure TfrmEditarLarTemporario.BuscaCodigoLar(CodLar: Integer);
begin
   iCodigoLar := CodLar;
end;

procedure TfrmEditarLarTemporario.cbxCidadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarLarTemporario.cbxTelasEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarLarTemporario.cbxTipoAnimalEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarLarTemporario.edtBairroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarLarTemporario.edtNomeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarLarTemporario.edtNumeroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarLarTemporario.edtQuantidadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarLarTemporario.edtRuaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarLarTemporario.edtTelefoneEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
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

function TfrmEditarLarTemporario.ExtrairStringAntesVirgula(const Texto: string): string;
var
  VirgulaPos: Integer;
begin
  VirgulaPos := Pos(',', Texto);
  if VirgulaPos > 0 then
    Result := Copy(Texto, 1, VirgulaPos - 1)
  else
    Result := Texto;
end;

procedure TfrmEditarLarTemporario.FormShow(Sender: TObject);
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
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM LarTemporario          '+
                                    ' WHERE cod_lar = '+IntToStr(iCodigoLar);
   dtmServidor.qryGeral.Active := True;

   dtmServidor.qryGeral2.Active := False;
   dtmServidor.qryGeral2.SQL.Clear;
   dtmServidor.qryGeral2.SQL.Text := ' SELECT nome_cidade                                                         '+
                                     ' FROM cidades                                                               '+
                                     ' WHERE cod_cidade = '+dtmServidor.qryGeral.FieldByName('cod_cidade').AsString;
   dtmServidor.qryGeral2.Active := True;

   edtNome.Text := dtmServidor.qryGeral.FieldByName('nome_lar').AsString;
   edtTelefone.Text := dtmServidor.qryGeral.FieldByName('telefone_lar').AsString;
   edtRua.Text := ExtrairStringAntesVirgula(dtmServidor.qryGeral.FieldByName('des_endereco_lar').AsString);
   edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('des_endereco_lar').AsString);
   edtBairro.Text := dtmServidor.qryGeral.FieldByName('des_bairro_lar').AsString;
   cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('nome_cidade').AsString;
   edtQuantidade.Text := dtmServidor.qryGeral.FieldByName('qtd_Animais').AsString;
   cbxTelas.ItemIndex := dtmServidor.qryGeral.FieldByName('ind_telas').AsInteger;
   cbxTipoAnimal.ItemIndex := dtmServidor.qryGeral.FieldByName('tipo_animal').AsInteger;
   mmoInformacoes.Text := dtmServidor.qryGeral.FieldByName('informacoes_lar').AsString;
end;

procedure TfrmEditarLarTemporario.mmoInformacoesEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

end.
