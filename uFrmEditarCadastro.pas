unit uFrmEditarCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ComboEdit, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmEditarCadastro = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    imgVoltar: TImage;
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
    function ExtrairNumeroAposVirgula(const Texto: string): string;
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarCadastroClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditarCadastro: TfrmEditarCadastro;

implementation

{$R *.fmx}

uses uDtmServidor, uFrmLogin, uPaginaConfiguracoes, uCriarCadastro, Notificacao;

{ TfrmEditarCadastro }

procedure TfrmEditarCadastro.btnAlterarCadastroClick(Sender: TObject);
begin
   try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE PESSOAS '+
                                        ' SET NOME_PESSOA = :NOME_PESSOA, '+
                                        '     TELEFONE_PESSOA = :TELEFONE_PESSOA,'+
                                        '     DES_RUA = :DES_RUA, '+
                                        '     DES_BAIRRO = :DES_BAIRRO, '+
                                        '     EMAIL_PESSOA = :EMAIL_PESSOA, '+
                                        '     COD_CIDADE = :COD_CIDADE '+
                                        ' WHERE COD_PESSOA = :COD_PESSOA ';

      dtmServidor.qryUpdate.Params.ParamByName('NOME_PESSOA').AsString := edtNome.Text;
      dtmServidor.qryUpdate.Params.ParamByName('TELEFONE_PESSOA').AsString := edtNome.Text;
      dtmServidor.qryUpdate.Params.ParamByName('DES_RUA').AsString := edtRua.Text + ',' +edtNumero.Text;
      dtmServidor.qryUpdate.Params.ParamByName('DES_BAIRRO').AsString := edtBairro.Text;
      dtmServidor.qryUpdate.Params.ParamByName('EMAIL_PESSOA').AsString := edtEmail.Text;

      dtmServidor.qryGeral2.Active := False;
      dtmServidor.qryGeral2.SQL.Clear;
      dtmServidor.qryGeral2.SQL.Text := ' SELECT COD_CIDADE '+
                                        ' FROM CIDADES       '+
                                        ' WHERE NOME_CIDADE = '+cbxCidade.Text;
      dtmServidor.qryGeral2.Active := True;

      dtmServidor.qryUpdate.Params.ParamByName('COD_CIDADE').AsString := dtmServidor.qryGeral2.FieldByName('COD_CIDADE').AsString;
      dtmServidor.qryUpdate.Params.ParamByName('COD_PESSOA').AsString := frmLogin.sUsuarioLogado;

      dtmServidor.qryInsert.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmCriarCadastro,
                            'N�o foi poss�vel realizar as altera��es!',
                             $FFFA3F3F,
                             TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmCriarCadastro,
                       'Registro atualizado com sucesso',
                        $FF22AF70,
                        TAlignLayout.Top);

      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM PESSOAS WHERE COD_PESSOA = '+frmLogin.sUsuarioLogado;
      dtmServidor.qryGeral.Active := True;

      edtNome.Text := dtmServidor.qryGeral.FieldByName('Nome_Pessoa').AsString;
      edtTelefone.Text := dtmServidor.qryGeral.FieldByName('Telefone_Pessoa').AsString;
      edtRua.Text := dtmServidor.qryGeral.FieldByName('Des_Rua').AsString;
      edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('Des_Rua').AsString);
      edtBairro.Text := dtmServidor.qryGeral.FieldByName('Des_Bairro').AsString;
      cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('Nome_Cidade').AsString;
      edtEmail.Text := dtmServidor.qryGeral.FieldByName('Email_Pessoa').AsString;
   end;
end;

procedure TfrmEditarCadastro.btnCancelarClick(Sender: TObject);
begin
   frmPaginaConfiguracoes.Show;
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

procedure TfrmEditarCadastro.FormShow(Sender: TObject);
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
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM PESSOAS WHERE COD_PESSOA = '+frmLogin.sUsuarioLogado;
   dtmServidor.qryGeral.Active := True;

   dtmServidor.qryGeral2.Active := False;
   dtmServidor.qryGeral2.SQL.Clear;
   dtmServidor.qryGeral2.SQL.Text := ' SELECT NOME_CIDADE '+
                                     ' FROM CIDADES       '+
                                     ' WHERE COD_CIDADE = '+dtmServidor.qryGeral.FieldByName('COD_CIDADE').AsString;
   dtmServidor.qryGeral2.Active := True;

   edtNome.Text := dtmServidor.qryGeral.FieldByName('Nome_Pessoa').AsString;
   edtTelefone.Text := dtmServidor.qryGeral.FieldByName('Telefone_Pessoa').AsString;
   edtRua.Text := dtmServidor.qryGeral.FieldByName('Des_Rua').AsString;
   edtNumero.Text := ExtrairNumeroAposVirgula(dtmServidor.qryGeral.FieldByName('Des_Rua').AsString);
   edtBairro.Text := dtmServidor.qryGeral.FieldByName('Des_Bairro').AsString;
   cbxCidade.Text := dtmServidor.qryGeral2.FieldByName('Nome_Cidade').AsString;
   edtEmail.Text := dtmServidor.qryGeral.FieldByName('Email_Pessoa').AsString;
end;

end.
