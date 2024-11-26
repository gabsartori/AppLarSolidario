unit uFrmEditarCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ComboEdit, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  System.ImageList, FMX.ImgList;

type
  TfrmEditarCadastro = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    btnAlterarCadastro: TRoundRect;
    Label9: TLabel;
    Layout3: TLayout;
    Label8: TLabel;
    Layout4: TLayout;
    lblNome: TLabel;
    edtNome: TEdit;
    Layout6: TLayout;
    lblTelefone: TLabel;
    edtTelefone: TEdit;
    Layout8: TLayout;
    lblRua: TLabel;
    edtRua: TEdit;
    Label12: TLabel;
    edtNumero: TEdit;
    Layout9: TLayout;
    lblBairro: TLabel;
    edtBairro: TEdit;
    Layout11: TLayout;
    lblEmail: TLabel;
    edtEmail: TEdit;
    Layout13: TLayout;
    lblCidade: TLabel;
    cbxCidade: TComboEdit;
    btnCancelar: TRoundRect;
    Label2: TLabel;
    Layout5: TLayout;
    btnVoltar: TButton;
    ImageList1: TImageList;
    function ExtrairNumeroAposVirgula(const Texto: string): string;
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarCadastroClick(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure edtTelefoneEnter(Sender: TObject);
    procedure edtRuaEnter(Sender: TObject);
    procedure edtNumeroEnter(Sender: TObject);
    procedure edtBairroEnter(Sender: TObject);
    procedure cbxCidadeEnter(Sender: TObject);
    procedure edtEmailEnter(Sender: TObject);
    function ExtrairStringAntesVirgula(const Texto: string): string;
  private
    { Private declarations }
  public
    { Public declarations }
    foco: TControl;
  end;

var
  frmEditarCadastro: TfrmEditarCadastro;

implementation

{$R *.fmx}

uses uDtmServidor, uFrmLogin, uPaginaConfiguracoes, uCriarCadastro, Notificacao;

{ TfrmEditarCadastro }

procedure Ajustar_Scroll();
var
   x: Integer;
begin
   with frmEditarCadastro do
   begin
      VertScrollBox1.Margins.Bottom := 250;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                TControl(foco).Position.Y - 150);
   end;
end;

procedure TfrmEditarCadastro.btnAlterarCadastroClick(Sender: TObject);
begin
   try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE pessoas                         '+
                                        ' SET nome_pessoa = :nome_pessoa,        '+
                                        '     telefone_pessoa = :telefone_pessoa,'+
                                        '     des_rua = :telefone_pessoa,        '+
                                        '     des_bairro = :des_bairro,          '+
                                        '     email_pessoa = :email_pessoa,      '+
                                        '     cod_cidade = :cod_cidade,          '+
                                        '     UF = :UF                           '+
                                        ' WHERE cod_pessoa = :cod_pessoa         ';

      dtmServidor.qryUpdate.Params.ParamByName('nome_pessoa').AsString := edtNome.Text;
      dtmServidor.qryUpdate.Params.ParamByName('telefone_pessoa').AsString := edtNome.Text;
      dtmServidor.qryUpdate.Params.ParamByName('telefone_pessoa').AsString := edtRua.Text + ', ' +edtNumero.Text;
      dtmServidor.qryUpdate.Params.ParamByName('des_bairro').AsString := edtBairro.Text;
      dtmServidor.qryUpdate.Params.ParamByName('email_pessoa').AsString := edtEmail.Text;

      dtmServidor.qryGeral2.Active := False;
      dtmServidor.qryGeral2.SQL.Clear;
      dtmServidor.qryGeral2.SQL.Text := ' SELECT * FROM cidades       '+
                                        ' WHERE nome_cidade = :nome_cidade ';

      dtmServidor.qryGeral2.Params.ParamByName('nome_cidade').AsString := cbxCidade.Text;
      dtmServidor.qryGeral2.Active := True;

      dtmServidor.qryUpdate.Params.ParamByName('cod_cidade').AsString := dtmServidor.qryGeral2.FieldByName('COD_CIDADE').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('UF').AsString := dtmServidor.qryGeral2.FieldByName('UF').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('cod_pessoa').AsString := frmLogin.sUsuarioLogado;

      dtmServidor.qryUpdate.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmCriarCadastro,
                            'Não foi possível realizar as alterações!',
                             $FFFA3F3F,
                             TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmEditarCadastro,
                       'Registro atualizado com sucesso',
                        $FF22AF70,
                        TAlignLayout.Top);

      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM pessoas                      '+
                                       ' WHERE cod_pessoa = '+frmLogin.sUsuarioLogado;
      dtmServidor.qryGeral.Active := True;

      frmPaginaConfiguracoes.Show;
   end;
end;

procedure TfrmEditarCadastro.btnCancelarClick(Sender: TObject);
begin
   frmEditarCadastro.Close;
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmEditarCadastro.btnVoltarClick(Sender: TObject);
begin
   frmEditarCadastro.Close;
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmEditarCadastro.cbxCidadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarCadastro.edtBairroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarCadastro.edtEmailEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarCadastro.edtNomeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarCadastro.edtNumeroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarCadastro.edtRuaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmEditarCadastro.edtTelefoneEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

function TfrmEditarCadastro.ExtrairNumeroAposVirgula(const Texto: string): string;
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

function TfrmEditarCadastro.ExtrairStringAntesVirgula(
  const Texto: string): string;
var
  VirgulaPos: Integer;
begin
  VirgulaPos := Pos(',', Texto);
  if VirgulaPos > 0 then
    Result := Copy(Texto, 1, VirgulaPos - 1)
  else
    Result := Texto;
end;

procedure TfrmEditarCadastro.FormShow(Sender: TObject);
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
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM pessoas                      '+
                                    ' WHERE cod_pessoa = '+frmLogin.sUsuarioLogado;
   dtmServidor.qryGeral.Active := True;

   dtmServidor.qryGeral2.Active := False;
   dtmServidor.qryGeral2.SQL.Clear;
   dtmServidor.qryGeral2.SQL.Text := ' SELECT nome_cidade                                                         '+
                                     ' FROM cidades                                                               '+
                                     ' WHERE cod_cidade = '+dtmServidor.qryGeral.FieldByName('cod_cidade').AsString;
   dtmServidor.qryGeral2.Active := True;

   edtNome.Text := dtmServidor.qryGeral.FieldByName('nome_pessoa').AsString;
   edtTelefone.Text := dtmServidor.qryGeral.FieldByName('telefone_pessoa').AsString;
   edtRua.Text := ExtrairStringAntesVirgula(dtmServidor.qryGeral.FieldByName('des_rua').AsString);
   edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('des_rua').AsString);
   edtBairro.Text := dtmServidor.qryGeral.FieldByName('des_bairro').AsString;
   cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('nome_cidade').AsString;
   edtEmail.Text := dtmServidor.qryGeral.FieldByName('email_pessoa').AsString;
end;

procedure TfrmEditarCadastro.Label2Click(Sender: TObject);
begin
   btnCancelarClick(Sender);
end;

procedure TfrmEditarCadastro.Label9Click(Sender: TObject);
begin
   btnAlterarCadastroClick(Sender);
end;

end.
