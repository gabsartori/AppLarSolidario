unit uFrmCadastroLarTemporario;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ExtCtrls,
  FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Ani;

type
  TfrmCadastroLarTemporario = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    imgVoltar: TImage;
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
    edtCep: TEdit;
    edtRua: TEdit;
    edtCidade: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    edtQuantidade: TEdit;
    cbxTelas: TComboBox;
    cbxTipoAnimal: TComboBox;
    Label6: TLabel;
    Label10: TLabel;
    Layout4: TLayout;
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
    procedure btnCriarContaClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure LimpaCampos(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastroLarTemporario: TfrmCadastroLarTemporario;

implementation

{$R *.fmx}

uses Notificacao, uDtmServidor, uLogin, uPaginaInicial;

procedure TfrmCadastroLarTemporario.btnCriarContaClick(Sender: TObject);
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
      ShowMessage('Informe a rua');
      Exit;
   end;

   if edtCidade.Text = '' then
   begin
      ShowMessage('Informe a cidade');
      Exit;
   end;

   if edtQuantidade.Text = '' then
   begin
      ShowMessage('Informe a quantidade');
      Exit;
   end;

   try
      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Clear;
      dtmServidor.qryGeral.SQL.Text := ' insert into Lar_Temporario (nome_pessoa, '+
                                       '                             telefone,    '+
                                       '                             cep,         '+
                                       '                             endereco,    '+
                                       '                             cidade,      '+
                                       '                             qtd_animais, '+
                                       '                             ind_telas,   '+
                                       '                             tipo_animal, '+
                                       '                             informacoes, '+
                                       '                             ind_ativo,   '+
                                       '                             cod_pessoa)  '+
                                       '                    values (:nome_pessoa, '+
                                       '                            :telefone,    '+
                                       '                            :cep,         '+
                                       '                            :endereco,    '+
                                       '                            :cidade,      '+
                                       '                            :qtd_animais, '+
                                       '                            :ind_telas,   '+
                                       '                            :tipo_animal, '+
                                       '                            :informacoes, '+
                                       '                            :ind_ativo,   '+
                                       '                            :cod_pessoa); ';

      dtmServidor.qryGeral.ParamByName('nome_pessoa').AsString := edtNome.Text;
      dtmServidor.qryGeral.ParamByName('telefone').AsString := edtTelefone.Text;
      dtmServidor.qryGeral.ParamByName('cep').AsString := edtCep.Text;
      dtmServidor.qryGeral.ParamByName('endereco').AsString := edtRua.Text +', '+edtNumero.Text;
      dtmServidor.qryGeral.ParamByName('cidade').AsString := edtCidade.Text;
      dtmServidor.qryGeral.ParamByName('qtd_animais').AsString := edtQuantidade.Text;
      dtmServidor.qryGeral.ParamByName('ind_telas').AsInteger := cbxTelas.ItemIndex;
      dtmServidor.qryGeral.ParamByName('tipo_animal').AsInteger := cbxTipoAnimal.ItemIndex;
      dtmServidor.qryGeral.ParamByName('informacoes').AsString := mmoInformacoes.Text;
      dtmServidor.qryGeral.ParamByName('ind_ativo').AsString := '1';
      dtmServidor.qryGeral.ParamByName('cod_pessoa').AsString := frmLogin.sUsuarioLogado;

      dtmServidor.qryGeral.ExecSQL;

      if dtmServidor.fdConexao.InTransaction then
      begin
         dtmServidor.fdConexao.Commit;
      end;
   finally
      TLoading.ToastMessage(frmCadastroLarTemporario,
                            'Cadastrado com sucesso!',
                             $FF22AF70,
                             TAlignLayout.Bottom);
      frmPaginaInicial.Show;
      LimpaCampos(Sender);
   end;
end;

procedure TfrmCadastroLarTemporario.imgVoltarClick(Sender: TObject);
begin
   LimpaCampos(Sender);
   frmPaginaInicial.Show;
end;

procedure TfrmCadastroLarTemporario.LimpaCampos(Sender: TObject);
begin
   edtNome.Text	:= '';
   edtTelefone.Text := '';
   edtCep.Text := '';
   edtRua.Text := '';
   edtNumero.Text := '';
   edtCidade.Text := '';
   edtQuantidade.Text := '';
   cbxTelas.ItemIndex := 0;
   cbxTipoAnimal.ItemIndex := 0;
   mmoInformacoes.Text := '';
end;

end.
