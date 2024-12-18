unit uFrmPaginaBuscas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, Data.DB,
  FMX.Edit, FMX.ComboEdit;

type
  TfrmPaginaBuscas = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    imgVoltar: TImage;
    Image1: TImage;
    Image2: TImage;
    lbAnimais: TListBox;
    vbsListaAnimais: TVertScrollBox;
    Layout1: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbxCastrado: TComboEdit;
    cbxCidade: TComboEdit;
    cbxTipoAnimal: TComboEdit;
    Label6: TLabel;
    cbxGenero: TComboEdit;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    btnBuscar: TRoundRect;
    Label7: TLabel;
    btnLimparFiltros: TRoundRect;
    Label8: TLabel;
    Layout7: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Rectangle2: TRectangle;
    lytNaoEncontrou: TLayout;
    Label9: TLabel;
    Image3: TImage;
    lytOpaco: TLayout;
    Rectangle3: TRectangle;
    lytConfirmaSolicitacao: TLayout;
    Panel1: TPanel;
    btnSim: TRoundRect;
    Label5: TLabel;
    btnNao: TRoundRect;
    Label10: TLabel;
    lblConfirmacao: TLabel;
    procedure ListarAnimais;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnLimparFiltrosClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure LimpaTodosFramesBusca;
    procedure BuscaCodigoAnimal(CodAnimal: Integer);
    procedure btnSimClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    iCodAnimal: Integer;
    sBotaoClicado: String;
  end;

var
  frmPaginaBuscas: TfrmPaginaBuscas;

implementation

{$R *.fmx}

uses Frame.AnimaisCadastrados, uDtmServidor, uFunctions, uPaginaInicial,
  Notificacao, uFrmLogin, uFrmCadastroAnimais;

{ TfrmPaginaBuscas }

{ TfrmPaginaBuscas }

procedure TfrmPaginaBuscas.btnBuscarClick(Sender: TObject);
begin
   LimpaTodosFramesBusca;
   ListarAnimais;
   Rectangle2.Visible := True;
end;

procedure TfrmPaginaBuscas.btnLimparFiltrosClick(Sender: TObject);
begin
   LimpaTodosFramesBusca;
   cbxTipoAnimal.ItemIndex := 0;
   cbxCastrado.ItemIndex := 0;
   cbxGenero.ItemIndex := 0;
   cbxCidade.ItemIndex := 0;
end;

procedure TfrmPaginaBuscas.btnSimClick(Sender: TObject);
var
   sCodPessoa, sCodLar: String;
begin
   if (sBotaoClicado = 'Ado��o') then
   begin
      try
         dtmServidor.qryGeral.Active := False;
         dtmServidor.qryGeral.SQL.Clear;
         dtmServidor.qryGeral.SQL.Text := ' SELECT cod_pessoa                       '+
                                          ' FROM animais                            '+
                                          ' WHERE cod_animal = '+IntToStr(iCodAnimal);
         dtmServidor.qryGeral.Active := True;

         sCodPessoa := dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString;

         dtmServidor.qryInsert.Active := False;
         dtmServidor.qryInsert.SQL.Clear;
         dtmServidor.qryInsert.SQL.Text := ' INSERT INTO solicitacoes (tipo_solicitacao,      '+
                                           '                           status_solicitacao,    '+
                                           '                           cod_animal,            '+
                                           '                           cod_pessoa_solicitada, '+
                                           '                           cod_pessoa)            '+
                                           '                  VALUES (:tipo_solicitacao,      '+
                                           '                          :status_solicitacao,    '+
                                           '                          :cod_animal,            '+
                                           '                          :cod_pessoa_solicitada, '+
                                           '                          :cod_pessoa);           ';

         dtmServidor.qryInsert.ParamByName('tipo_solicitacao').AsString := 'Adotar';
         dtmServidor.qryInsert.ParamByName('status_solicitacao').AsInteger := 0;
         dtmServidor.qryInsert.ParamByName('cod_animal').AsInteger := iCodAnimal;
         dtmServidor.qryInsert.ParamByName('cod_pessoa_solicitada').AsString := sCodPessoa;
         dtmServidor.qryInsert.ParamByName('cod_pessoa').AsString := frmLogin.sUsuarioLogado;

         dtmServidor.qryInsert.ExecSQL;

         try
             if dtmServidor.fdConexao.InTransaction then
             begin
                dtmServidor.fdConexao.Commit;
             end;
         except
            TLoading.ToastMessage(frmPaginaBuscas,
                               'N�o foi poss�vel enviar a solicita��o!',
                                $FFFA3F3F,
                                TAlignLayout.Top);
            Exit;
         end;
      finally
         TLoading.ToastMessage(frmPaginaBuscas,
                               'Solicita��o enviada com sucesso!',
                                $FF22AF70,
                                TAlignLayout.Top);

         lytOpaco.Visible := False;
         lytConfirmaSolicitacao.Visible := False;
      end;
   end
   else
   begin
      try
         dtmServidor.qryGeral.Active := False;
         dtmServidor.qryGeral.SQL.Clear;
         dtmServidor.qryGeral.SQL.Text := ' SELECT cod_pessoa '+
                                          ' FROM animais      '+
                                          ' WHERE cod_animal = '+IntToStr(iCodAnimal);
         dtmServidor.qryGeral.Active := True;

         sCodPessoa := dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString;

         dtmServidor.qryGeral.Active := False;
         dtmServidor.qryGeral.SQL.Clear;
         dtmServidor.qryGeral.SQL.Text := ' SELECT cod_lar '+
                                          ' FROM lartemporario      '+
                                          ' WHERE cod_pessoa = '+frmLogin.sUsuarioLogado;
         dtmServidor.qryGeral.Active := True;

         sCodLar := dtmServidor.qryGeral.FieldByName('cod_lar').AsString;

         if (sCodLar = '') then
         begin
            ShowMessage('Voc� precisa ter um cadastro de lar tempor�rio!');
            Exit;
         end;

         dtmServidor.qryInsert.Active := False;
         dtmServidor.qryInsert.SQL.Clear;
         dtmServidor.qryInsert.SQL.Text := ' INSERT INTO solicitacoes (tipo_solicitacao,      '+
                                           '                           status_solicitacao,    '+
                                           '                           cod_animal,            '+
                                           '                           cod_lar,               '+
                                           '                           cod_pessoa_solicitada, '+
                                           '                           cod_pessoa)            '+
                                           '                  VALUES (:Tipo_solicitacao,      '+
                                           '                          :Status_solicitacao,    '+
                                           '                          :cod_animal,            '+
                                           '                          :cod_lar,               '+
                                           '                          :cod_pessoa_solicitada, '+
                                           '                          :cod_pessoa);           ';

         dtmServidor.qryInsert.ParamByName('tipo_solicitacao').AsString := 'Hospedar';
         dtmServidor.qryInsert.ParamByName('status_solicitacao').AsInteger := 0;
         dtmServidor.qryInsert.ParamByName('cod_animal').AsInteger := iCodAnimal;
         dtmServidor.qryInsert.ParamByName('cod_lar').AsString := sCodLar;
         dtmServidor.qryInsert.ParamByName('cod_pessoa_solicitada').AsString := sCodPessoa;
         dtmServidor.qryInsert.ParamByName('cod_pessoa').AsString := frmLogin.sUsuarioLogado;

         dtmServidor.qryInsert.ExecSQL;

         try
             if dtmServidor.fdConexao.InTransaction then
             begin
                dtmServidor.fdConexao.Commit;
             end;
         except
            TLoading.ToastMessage(frmPaginaBuscas,
                               'N�o foi poss�vel enviar a solicita��o!',
                                $FFFA3F3F,
                                TAlignLayout.Top);
            Exit;
         end;
      finally
         TLoading.ToastMessage(frmPaginaBuscas,
                               'Solicita��o enviada com sucesso!',
                                $FF22AF70,
                                TAlignLayout.Top);

         lytOpaco.Visible := False;
         lytConfirmaSolicitacao.Visible := False;
      end;
   end;
end;

procedure TfrmPaginaBuscas.BuscaCodigoAnimal(CodAnimal: Integer);
begin
   iCodAnimal := CodAnimal;
end;

procedure TfrmPaginaBuscas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   LimpaTodosFramesBusca;
   Rectangle2.Visible := False;
end;

procedure TfrmPaginaBuscas.FormShow(Sender: TObject);
begin
   cbxCidade.Items.Clear;

   if (cbxCidade.Items.Text = '') then
   begin
      cbxCidade.Items.Add('Todas');

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

   cbxCidade.ItemIndex := 0;
   lytNaoEncontrou.Visible := False;
   lytOpaco.Visible := False;
   lytConfirmaSolicitacao.Visible := False;
   LimpaTodosFramesBusca;
   Rectangle2.Visible := False;
end;

procedure TfrmPaginaBuscas.imgVoltarClick(Sender: TObject);
begin
   frmPaginaBuscas.Close;
   frmPaginaInicial.Show;
end;

procedure TfrmPaginaBuscas.LimpaTodosFramesBusca;
var
   i: Integer;
begin
   for i := ComponentCount - 1 downto 0 do
   begin
      if Components[i] is TFrameAnimaisCadastrados then
      begin
         TFrameAnimaisCadastrados(Components[i]).Free;
      end;
   end;
end;

procedure TfrmPaginaBuscas.ListarAnimais;
var
   Frame : TFrameAnimaisCadastrados;
   sCodAnimal, sNome, sTipo, sCor, sGenero, sCastrado, sIdade, sResponsavel, sSituacao,
   sEndereco, sTelefone, sInformacoes, sSelectGenero, sSelectTipo, sSelectCastrado,
   sSelectEstado, sSelectCidade: String;
   i : Integer;
begin
   try
      lytNaoEncontrou.Visible := False;
      lbAnimais.Items.Clear;

      if (cbxCastrado.ItemIndex = 1) then
      begin
         sSelectCastrado := 'AND a.ind_castrado = 1 ';
      end
      else if (cbxCastrado.ItemIndex = 2) then
      begin
         sSelectCastrado := 'AND a.ind_castrado = 2 ';
      end
      else
      begin
         sSelectCastrado := '';
      end;

      if (cbxGenero.ItemIndex = 1) then
      begin
         sSelectGenero := 'AND a.genero_animal = 1 ';
      end
      else if (cbxGenero.ItemIndex = 2) then
      begin
         sSelectGenero := 'AND a.genero_animal = 2 ';
      end
      else
      begin
         sSelectGenero := '';
      end;

      if (cbxTipoAnimal.ItemIndex = 1) then
      begin
         sSelectTipo := 'AND a.tipo_animal = 1 ';
      end
      else if (cbxTipoAnimal.ItemIndex = 2) then
      begin
         sSelectTipo := 'AND a.tipo_animal = 2 ';
      end
      else
      begin
         sSelectTipo := '';
      end;

      if (cbxCidade.ItemIndex = 0) then
      begin
         sSelectCidade := '';
      end
      else
      begin
         dtmServidor.qryGeral2.Active := False;
         dtmServidor.qryGeral2.SQL.Clear;
         dtmServidor.qryGeral2.SQL.Text := ' SELECT * FROM cidades            '+
                                           ' WHERE nome_cidade = :nome_cidade ';

         dtmServidor.qryGeral2.Params.ParamByName('nome_cidade').AsString := cbxCidade.Text;
         dtmServidor.qryGeral2.Active := True;

         sSelectCidade := 'AND a.cod_cidade = '+dtmServidor.qryGeral2.FieldByName('cod_cidade').AsString;
      end;


      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Text := '';
      dtmServidor.qryGeral.SQL.Text := ' select a.cod_animal,                              '+
                                       '        a.nome_animal,                             '+
                                       '        a.cor_pelagem,                             '+
                                       '        CASE                                       '+
                                       '          WHEN a.ind_castrado = 1 THEN ''Sim''     '+
                                       '          ELSE ''N�o''                             '+
                                       '        END AS castrado,                           '+
                                       '        CASE                                       '+
                                       '          WHEN a.tipo_animal = 1 THEN ''Cachorro'' '+
                                       '          ELSE ''Gato''                            '+
                                       '        END AS tipo_animal,                        '+
                                       '        a.situacao_animal,                         '+
                                       '        a.des_endereco_animal,                     '+
                                       '        a.des_bairro_animal,                       '+
                                       '        CASE                                       '+
                                       '          WHEN a.genero_animal = 1 THEN ''F�mea''  '+
                                       '          ELSE ''Macho''                           '+
                                       '        END AS genero_animal,                      '+
                                       '        a.informacoes_animal,                      '+
                                       '        a.idade_animal,                            '+
                                       '        a.foto_animal,                             '+
                                       '        a.cod_cidade,                              '+
                                       '        b.nome_pessoa,                             '+
                                       '        b.telefone_pessoa                          '+
                                       ' FROM animais a, pessoas b                         '+
                                       ' WHERE a.cod_pessoa = b.cod_pessoa                 '+
                                       ' AND a.situacao_animal <> ''Adotado''              '+
                                       sSelectGenero                                        +
                                       sSelectTipo                                          +
                                       sSelectCastrado                                      +
                                       sSelectCidade                                        +
                                       ' ORDER BY nome_animal                              ';
      dtmServidor.qryGeral.Active := True;

      if (dtmServidor.qryGeral.RecordCount > 0) then
      begin
          i := 1;
          dtmServidor.qryGeral.First;
          while not dtmServidor.qryGeral.Eof do
          begin
             dtmServidor.qryGeral2.Active := False;
             dtmServidor.qryGeral2.SQL.Text := '';
             dtmServidor.qryGeral2.SQL.Text := ' SELECT nome_cidade, UF                                                          '+
                                               ' FROM cidades                                                                '+
                                               ' WHERE cod_cidade = '+ dtmServidor.qryGeral.FieldByName('cod_cidade').AsString;
             dtmServidor.qryGeral2.Active := True;

             sCodAnimal := dtmServidor.qryGeral.FieldByName('cod_animal').AsString;
             sNome := dtmServidor.qryGeral.FieldByName('nome_animal').AsString;
             sTipo := dtmServidor.qryGeral.FieldByName('tipo_animal').AsString;
             sCor := dtmServidor.qryGeral.FieldByName('cor_pelagem').AsString;
             sGenero := dtmServidor.qryGeral.FieldByName('genero_animal').AsString;
             sCastrado := dtmServidor.qryGeral.FieldByName('castrado').AsString;
             sIdade := dtmServidor.qryGeral.FieldByName('idade_animal').AsString;
             sResponsavel := dtmServidor.qryGeral.FieldByName('Nome_Pessoa').AsString;
             sSituacao := dtmServidor.qryGeral.FieldByName('situacao_animal').AsString;
             sEndereco := dtmServidor.qryGeral.FieldByName('des_endereco_animal').AsString + ', '+
                          dtmServidor.qryGeral.FieldByName('des_bairro_animal').AsString + ', '+
                          dtmServidor.qryGeral2.FieldByName('nome_cidade').AsString + ', '+
                          dtmServidor.qryGeral2.FieldByName('uf').AsString;
             sTelefone := dtmServidor.qryGeral.FieldByName('telefone_pessoa').AsString;
             sInformacoes := dtmServidor.qryGeral.FieldByName('informacoes_animal').AsString;

             Frame := TFrameAnimaisCadastrados.Create(Self);
             Frame.Tag := StrToInt(sCodAnimal);
             Frame.Parent := vbsListaAnimais;
             frame.align := TAlignLayout.Top;
             Frame.Name := 'Frame_' + sCodAnimal + '_' + IntToStr(i);
             Frame.Visible := True;
             frame.Margins.Top := 2;
             frame.Margins.Bottom := 2;

             Frame.lblCodAnimal.text := sCodAnimal;
             Frame.lblNome.text := sNome;
             Frame.lblCor.Text := Frame.lblCor.Text + ' ' + sCor;
             Frame.lblTipo.Text := Frame.lblTipo.Text + ' ' + sTipo;
             Frame.lblGenero.Text := Frame.lblGenero.Text + ' ' + sGenero;
             Frame.lblResponsavel.Text := Frame.lblResponsavel.Text + ' ' + sResponsavel;
             Frame.lblEndereco.Text := Frame.lblEndereco.Text + ' ' + sEndereco;
             Frame.lblTelefone.Text := Frame.lblTelefone.Text + ' ' + sTelefone;

             if (sInformacoes <> '') then
             begin
                Frame.lblInformacoes.Text := Frame.lblInformacoes.Text + ' ' + sInformacoes;
             end
             else
             begin
                Frame.lblInformacoes.Text := Frame.lblInformacoes
                .Text + ' Sem informa��es adicionais.';
             end;

             Frame.lblIdade.Text := Frame.lblIdade.Text + ' ' + sIdade;
             Frame.lblCastrado.Text := Frame.lblCastrado.Text + ' ' + sCastrado;
             Frame.lblSituacao.Text := Frame.lblSituacao.Text + ' ' + sSituacao;

             if dtmServidor.qryGeral.FieldByName('foto_animal').AsString <> '' then
             begin
                TFunctions.LoadBitmapFromBlob(Frame.cFotoAnimal.Fill.Bitmap.Bitmap,
                                              TBlobField(dtmServidor.qryGeral.FieldByName('foto_animal')));
                Frame.cFotoAnimal.Repaint;
             end;

             if (sSituacao = 'Em lar tempor�rio') then
             begin
                Frame.btnHospedar.Enabled := False;
             end;

             if frame.Height > vbsListaAnimais.Height then
             begin
                vbsListaAnimais.Height := frame.Height;
             end;

             i := i + 1;
             dtmServidor.qryGeral.Next;
          end;
      end
      else
      begin
         lytNaoEncontrou.Visible := True;
      end;
   finally

   end;
end;

end.
