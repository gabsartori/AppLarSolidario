unit uCriarCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.ExtCtrls, FMX.Edit, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  FMX.ComboEdit, System.ImageList, FMX.ImgList, FMX.DialogService, FMX.VirtualKeyboard,
  FMX.Platform;

type
  TfrmCriarCadastro = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    edtNome: TEdit;
    Label8: TLabel;
    lblNome: TLabel;
    btnCriarConta: TRoundRect;
    Label9: TLabel;
    lblTelefone: TLabel;
    edtTelefone: TEdit;
    edtBairro: TEdit;
    lblRua: TLabel;
    lblBairro: TLabel;
    edtRua: TEdit;
    edtEmail: TEdit;
    edtSenha: TEdit;
    edtNumero: TEdit;
    Label12: TLabel;
    Image1: TImage;
    Image2: TImage;
    VertScrollBox1: TVertScrollBox;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout6: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Layout10: TLayout;
    Layout11: TLayout;
    Layout13: TLayout;
    lblCidade: TLabel;
    lblEmail: TLabel;
    lblSenha: TLabel;
    cbxCidade: TComboEdit;
    btnVoltar: TButton;
    ImageList1: TImageList;
    lytOpaco: TLayout;
    Rectangle3: TRectangle;
    lytConfirmaAtivacao: TLayout;
    Panel1: TPanel;
    btnSim: TRoundRect;
    Label5: TLabel;
    btnNao: TRoundRect;
    Label10: TLabel;
    lblConfirmacao: TLabel;
    procedure btnVoltarClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure LimpaCampos(Sender: TObject);
    procedure edtBairroEnter(Sender: TObject);
    procedure edtRuaEnter(Sender: TObject);
    procedure edtNumeroEnter(Sender: TObject);
    procedure edtCidadeEnter(Sender: TObject);
    procedure edtEstadoEnter(Sender: TObject);
    procedure edtSenhaEnter(Sender: TObject);
    procedure edtTelefoneEnter(Sender: TObject);
    procedure edtNomeEnter(Sender: TObject);
    procedure edtEmailEnter(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
    procedure btnSimClick(Sender: TObject);
  private
    { Private declarations }
    foco: TControl;
  public
    { Public declarations }
    sNumero, sCodPessoa: String;
  end;


var
  frmCriarCadastro: TfrmCriarCadastro;

implementation

{$R *.fmx}

uses uFrmLogin, uPaginaInicial, JSON, System.Net.HttpClient, uDtmServidor,
  Notificacao;

procedure Ajustar_Scroll();
var
   x: Integer;
begin
   with frmCriarCadastro do
   begin
      VertScrollBox1.Margins.Bottom := 250;
      VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X,
                                                TControl(foco).Position.Y - 150);
   end;
end;

procedure TfrmCriarCadastro.btnCriarContaClick(Sender: TObject);
var
   iCodCidade: integer;
   sUF: String;
   VirtualKeyboard: IFMXVirtualKeyboardService;
begin
   if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
   begin
      VirtualKeyboard.HideVirtualKeyboard;
   end;
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

   if edtEmail.Text = '' then
   begin
      ShowMessage('Informe o e-mail');
      Exit;
   end;

   if edtSenha.Text = '' then
   begin
      ShowMessage('Informe a senha');
      Exit;
   end;

   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Text := '';
   dtmServidor.qryGeral.SQL.Text := ' SELECT * FROM pessoas              '+
                                    ' WHERE email_pessoa = :email_pessoa '+
                                    ' AND ind_ativo = 0                  ';

   dtmServidor.qryGeral.Params.ParamByName('email_pessoa').AsString := edtEmail.Text;
   dtmServidor.qryGeral.Active := true;

   sCodPessoa := dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString;

   if (dtmServidor.qryGeral.RecordCount > 0) then
   begin
      if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
      begin
         VirtualKeyboard.HideVirtualKeyboard;
      end;

      lytOpaco.Visible := True;
      lytConfirmaAtivacao.Visible := True;
   end
   else
   begin
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
         dtmServidor.qryInsert.SQL.Text := ' INSERT INTO Pessoas (nome_pessoa,     '+
                                          '                       telefone_pessoa, '+
                                          '                       des_rua,         '+
                                          '                       des_bairro,      '+
                                          '                       UF,              '+
                                          '                       email_pessoa,    '+
                                          '                       senha_pessoa,    '+
                                          '                       ind_ativo,       '+
                                          '                       cod_cidade)      '+
                                          '              VALUES (:nome_pessoa,     '+
                                          '                      :telefone_pessoa, '+
                                          '                      :des_rua,         '+
                                          '                      :des_bairro,      '+
                                          '                      :UF,              '+
                                          '                      :email_pessoa,    '+
                                          '                      :senha_pessoa,    '+
                                          '                      :ind_ativo,       '+
                                          '                      :cod_cidade);     ';

         if (edtNumero.Text = '') then
         begin
            sNumero := 'S/N';
         end
         else
         begin
            sNumero := edtNumero.Text;
         end;

         dtmServidor.qryInsert.ParamByName('nome_pessoa').AsString := edtNome.Text;
         dtmServidor.qryInsert.ParamByName('telefone_pessoa').AsString := edtTelefone.Text;
         dtmServidor.qryInsert.ParamByName('des_rua').AsString := edtRua.Text +', '+ sNumero;
         dtmServidor.qryInsert.ParamByName('des_bairro').AsString := edtBairro.Text;
         dtmServidor.qryInsert.ParamByName('UF').AsString := sUF;
         dtmServidor.qryInsert.ParamByName('email_pessoa').AsString := edtEmail.Text;
         dtmServidor.qryInsert.ParamByName('senha_pessoa').AsString := edtSenha.Text;
         dtmServidor.qryInsert.ParamByName('ind_ativo').AsString := '1';
         dtmServidor.qryInsert.ParamByName('cod_cidade').AsInteger := iCodCidade;

         dtmServidor.qryInsert.ExecSQL;

         try
             if dtmServidor.fdConexao.InTransaction then
             begin
                dtmServidor.fdConexao.Commit;
             end;
         except
            TLoading.ToastMessage(frmCriarCadastro,
                               'N�o foi poss�vel realizar o cadastro!',
                                $FFFA3F3F,
                                TAlignLayout.Top);
            Exit;
         end;

      finally
         TLoading.ToastMessage(frmCriarCadastro,
                               'Cadastrado com sucesso',
                                $FF22AF70,
                                TAlignLayout.Top);
         LimpaCampos(Sender);
      end;
   end;
end;

procedure TfrmCriarCadastro.edtBairroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtCidadeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtEmailEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtEstadoEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtNomeEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtNumeroEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtRuaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtSenhaEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.edtTelefoneEnter(Sender: TObject);
begin
   foco := TControl(TEdit(sender).Parent);
   Ajustar_Scroll();
end;

procedure TfrmCriarCadastro.FormShow(Sender: TObject);
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
   lytOpaco.Visible := False;
   lytConfirmaAtivacao.Visible := False;
end;

procedure TfrmCriarCadastro.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
   VertScrollBox1.Margins.Bottom := 0;
end;

procedure TfrmCriarCadastro.btnNaoClick(Sender: TObject);
begin
   lytOpaco.Visible := False;
   lytConfirmaAtivacao.Visible := False;
end;

procedure TfrmCriarCadastro.btnSimClick(Sender: TObject);
begin
   try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE pessoas '+
                                        ' SET ind_ativo = 1 '+
                                        ' WHERE cod_pessoa = :cod_pessoa ';

      dtmServidor.qryUpdate.Params.ParamByName('cod_pessoa').AsString := sCodPessoa;

      dtmServidor.qryUpdate.ExecSQL;

      try
          if dtmServidor.fdConexao.InTransaction then
          begin
             dtmServidor.fdConexao.Commit;
          end;
      except
         TLoading.ToastMessage(frmCriarCadastro,
                            'N�o foi poss�vel realizar a opera��o!',
                             $FFFA3F3F,
                             TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmCriarCadastro,
                           'Conta reativada com sucesso',
                           $FF22AF70,
                           TAlignLayout.Top);

      lytOpaco.Visible := False;
      lytConfirmaAtivacao.Visible := False;
      frmLogin.Show;
   end;
end;

procedure TfrmCriarCadastro.btnVoltarClick(Sender: TObject);
begin
   LimpaCampos(Sender);
   frmCriarCadastro.Close;
   frmLogin.Show;
end;

procedure TfrmCriarCadastro.Label9Click(Sender: TObject);
begin
   btnCriarContaClick(Sender);
end;

procedure TfrmCriarCadastro.LimpaCampos(Sender: TObject);
begin
   edtNome.Text := '';
   edtTelefone.Text := '';
   edtRua.Text := '';
   edtBairro.Text := '';
   edtEmail.Text := '';
   edtSenha.Text := '';
   edtNumero.Text := '';
end;

end.

