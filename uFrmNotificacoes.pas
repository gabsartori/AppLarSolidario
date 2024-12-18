unit uFrmNotificacoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.ComboEdit;

type
  TfrmNotificacoes = class(TForm)
    Layout2: TLayout;
    Rectangle1: TRectangle;
    imgVoltar: TImage;
    Image1: TImage;
    Image2: TImage;
    Layout1: TLayout;
    Label1: TLabel;
    Rectangle2: TRectangle;
    Rectangle4: TRectangle;
    lbNotificacoes: TListBox;
    vbsNotificacoes: TVertScrollBox;
    lytNaoEncontrou: TLayout;
    Label9: TLabel;
    Image3: TImage;
    lytOpaco: TLayout;
    Rectangle3: TRectangle;
    lytPerfil: TLayout;
    Panel1: TPanel;
    lblTipo: TLabel;
    lblCidadeLar: TLabel;
    lblTelefoneLar: TLabel;
    lblEndereco: TLabel;
    btnOk: TRoundRect;
    Label5: TLabel;
    lytNegativa: TLayout;
    Panel2: TPanel;
    Label2: TLabel;
    cbxMotivos: TComboEdit;
    Label3: TLabel;
    mmoMotivo: TMemo;
    btnSalvar: TRoundRect;
    Label4: TLabel;
    btnCancelar: TRoundRect;
    Label10: TLabel;
    Label6: TLabel;
    lblEnderecoLar: TLabel;
    lblCidade: TLabel;
    lblTelefone: TLabel;
    lblNome: TLabel;
    Label13: TLabel;
    lblTelas: TLabel;
    procedure imgVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListarNotificacoes;
    procedure BuscaSolicitacao(CodSolicitacao: String);
    procedure AtualizaSolicitacao(CodSolicitacao: String);
    procedure LimpaTodosFramesNotificacoes;
    procedure btnNaoClick(Sender: TObject);
    procedure BuscaInformacoesPerfil(Nome, Telefone, Endereco, Cidade,
                                     TelefoneLar, CidadeLar, EnderecoLar, Telas, TipoAnimal: String);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure cbxMotivosEnter(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure AceitaSolicitacaoLar(CodSolicitacao, CodAnimal, CodLar: String);
    procedure AceitaSolicitacaoAdocao(CodSolicitacao, CodAnimal, CodPessoa: String);
  private
    { Private declarations }
    sCodSolicitacao: String;
  public
    { Public declarations }
  end;

var
  frmNotificacoes: TfrmNotificacoes;

implementation

{$R *.fmx}

uses uPaginaInicial, Frame.Notificacoes, uDtmServidor, uFrmEdicaoLares,
  uFrmLogin, Notificacao, Frame.NotificacoesRespondidas;

procedure TfrmNotificacoes.AceitaSolicitacaoAdocao(CodSolicitacao, CodAnimal, CodPessoa: String);
begin
   try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE solicitacoes '+
                                        ' SET status_solicitacao = 1 '+
                                        ' WHERE cod_solicitacao = :cod_solicitacao ';

      dtmServidor.qryUpdate.Params.ParamByName('cod_solicitacao').AsString := CodSolicitacao;

      dtmServidor.qryUpdate.ExecSQL;

      try
         if dtmServidor.fdConexao.InTransaction then
         begin
            dtmServidor.fdConexao.Commit;
         end;
      except
         TLoading.ToastMessage(frmNotificacoes,
                            'N�o foi poss�vel realizar a opera��o!',
                             $FFFA3F3F,
                             TAlignLayout.Top);
         Exit;
      end;

      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE animais '+
                                        ' SET cod_pessoa = :cod_pessoa, '+
                                        '     situacao_animal = ''Adotado'' '+
                                        ' WHERE cod_animal = :cod_animal ';

      dtmServidor.qryUpdate.Params.ParamByName('cod_pessoa').AsString := CodPessoa;
      dtmServidor.qryUpdate.Params.ParamByName('cod_animal').AsString := CodAnimal;

      dtmServidor.qryUpdate.ExecSQL;

      try
         if dtmServidor.fdConexao.InTransaction then
         begin
            dtmServidor.fdConexao.Commit;
         end;
      except
         TLoading.ToastMessage(frmNotificacoes,
                            'N�o foi poss�vel realizar a opera��o!',
                             $FFFA3F3F,
                             TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmNotificacoes,
                            'Solicita��o aceita!',
                             $FF22AF70,
                             TAlignLayout.Top);

      LimpaTodosFramesNotificacoes;
      ListarNotificacoes;
   end;
end;

procedure TfrmNotificacoes.AceitaSolicitacaoLar(CodSolicitacao, CodAnimal, CodLar: String);
begin
   try
      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE solicitacoes '+
                                        ' SET status_solicitacao = 1 '+
                                        ' WHERE cod_solicitacao = :cod_solicitacao ';

      dtmServidor.qryUpdate.Params.ParamByName('cod_solicitacao').AsString := CodSolicitacao;

      dtmServidor.qryUpdate.ExecSQL;

      try
         if dtmServidor.fdConexao.InTransaction then
         begin
            dtmServidor.fdConexao.Commit;
         end;
      except
         TLoading.ToastMessage(frmNotificacoes,
                              'N�o foi poss�vel realizar a opera��o!',
                               $FFFA3F3F,
                               TAlignLayout.Top);
         Exit;
      end;

      dtmServidor.qryUpdate.Active := False;
      dtmServidor.qryUpdate.SQL.Clear;
      dtmServidor.qryUpdate.SQL.Text := ' UPDATE animais '+
                                        ' SET cod_lar = :cod_lar, '+
                                        '     situacao_animal = ''Em lar tempor�rio'' '+
                                        ' WHERE cod_animal = :cod_animal ';

      dtmServidor.qryUpdate.Params.ParamByName('cod_lar').AsString := CodLar;
      dtmServidor.qryUpdate.Params.ParamByName('cod_animal').AsString := CodAnimal;

      dtmServidor.qryUpdate.ExecSQL;

      try
         if dtmServidor.fdConexao.InTransaction then
         begin
            dtmServidor.fdConexao.Commit;
         end;
      except
         TLoading.ToastMessage(frmNotificacoes,
                              'N�o foi poss�vel realizar a opera��o!',
                               $FFFA3F3F,
                               TAlignLayout.Top);
         Exit;
      end;

   finally
      TLoading.ToastMessage(frmNotificacoes,
                            'Solicita��o aceita!',
                             $FF22AF70,
                             TAlignLayout.Top);

      LimpaTodosFramesNotificacoes;
      ListarNotificacoes;
   end;
end;

procedure TfrmNotificacoes.AtualizaSolicitacao(CodSolicitacao: String);
begin
   try
       dtmServidor.qryUpdate.Active := False;
       dtmServidor.qryUpdate.SQL.Clear;
       dtmServidor.qryUpdate.SQL.Text := ' UPDATE solicitacoes '+
                                         ' SET status_solicitacao = 3 '+
                                         ' WHERE cod_solicitacao = :cod_solicitacao ';

       dtmServidor.qryUpdate.Params.ParamByName('cod_solicitacao').AsString := CodSolicitacao;

       dtmServidor.qryUpdate.ExecSQL;

       try
           if dtmServidor.fdConexao.InTransaction then
           begin
              dtmServidor.fdConexao.Commit;
           end;
       except
          TLoading.ToastMessage(frmNotificacoes,
                             'N�o foi poss�vel realizar a opera��o!',
                              $FFFA3F3F,
                              TAlignLayout.Top);
          Exit;
       end;

   finally
      TLoading.ToastMessage(frmNotificacoes,
                            'Solicita��o finalizada!',
                             $FF22AF70,
                             TAlignLayout.Top);

      LimpaTodosFramesNotificacoes;
      ListarNotificacoes;
   end;
end;

procedure TfrmNotificacoes.btnCancelarClick(Sender: TObject);
begin
   cbxMotivos.Clear;
   mmoMotivo.Text := '';
   frmNotificacoes.lytOpaco.Visible := False;
   frmNotificacoes.lytNegativa.Visible := False;
end;

procedure TfrmNotificacoes.btnNaoClick(Sender: TObject);
begin
   lytOpaco.Visible := False;
   lytPerfil.Visible := False;
end;

procedure TfrmNotificacoes.btnOkClick(Sender: TObject);
begin
   lblNome.Text := 'Nome: ';
   lblTelefone.Text := 'Telefone: ';
   lblEndereco.Text := 'Endere�o: ';
   lblCidade.Text := 'Cidade: ';
   lblTelefoneLar.Text := 'Telefone: ';
   lblEnderecoLar.Text := 'Endere�o: ';
   lblCidadeLar.Text := 'Cidade: ';
   lblTelas.Text := 'Lar com Telas: ';
   lblTipo.Text :=  'Tipo de Pet Aceito: ';

   lytOpaco.Visible := False;
   lytPerfil.Visible := False;
end;

procedure TfrmNotificacoes.btnSalvarClick(Sender: TObject);
var
   sCodMotivo: String;
begin
   try
      if (mmoMotivo.Text <> '') then
      begin
         dtmServidor.qryInsert.Active := False;
         dtmServidor.qryInsert.SQL.Clear;
         dtmServidor.qryInsert.SQL.Text := ' INSERT INTO Motivos (descricao) '+
                                          '              VALUES (:descricao); ';

         dtmServidor.qryInsert.ParamByName('descricao').AsString := mmoMotivo.Text;
         dtmServidor.qryInsert.ExecSQL;

         if dtmServidor.fdConexao.InTransaction then
         begin
            dtmServidor.fdConexao.Commit;
         end;

         dtmServidor.qryGeral.Active := False;
         dtmServidor.qryGeral.SQL.Text := '';
         dtmServidor.qryGeral.SQL.Text := ' SELECT cod_motivo '+
                                          ' FROM motivos  '+
                                          ' WHERE descricao = '''+mmoMotivo.Text+''' ';
         dtmServidor.qryGeral.Active := True;

         sCodMotivo := dtmServidor.qryGeral.FieldByName('cod_motivo').AsString;

         dtmServidor.qryUpdate.Active := False;
         dtmServidor.qryUpdate.SQL.Clear;
         dtmServidor.qryUpdate.SQL.Text := ' UPDATE solicitacoes '+
                                           ' SET cod_motivo = :cod_motivo, '+
                                           '     status_solicitacao = :status_solicitacao '+
                                           ' WHERE cod_solicitacao = :cod_solicitacao ';

         dtmServidor.qryUpdate.Params.ParamByName('cod_motivo').AsString := sCodMotivo;
         dtmServidor.qryUpdate.Params.ParamByName('status_solicitacao').AsString := '2';
         dtmServidor.qryUpdate.Params.ParamByName('cod_solicitacao').AsString := sCodSolicitacao;

         dtmServidor.qryUpdate.ExecSQL;

         try
             if dtmServidor.fdConexao.InTransaction then
             begin
                dtmServidor.fdConexao.Commit;
             end;
         except
            TLoading.ToastMessage(frmNotificacoes,
                               'N�o foi poss�vel realizar a opera��o!',
                                $FFFA3F3F,
                                TAlignLayout.Top);
            Exit;
         end;
      end
      else
      begin
         dtmServidor.qryUpdate.Active := False;
         dtmServidor.qryUpdate.SQL.Clear;
         dtmServidor.qryUpdate.SQL.Text := ' UPDATE solicitacoes '+
                                           ' SET cod_motivo = :cod_motivo, '+
                                           '     status_solicitacao = :status_solicitacao '+
                                           ' WHERE cod_solicitacao = :cod_solicitacao ';

         dtmServidor.qryUpdate.Params.ParamByName('cod_motivo').AsInteger := cbxMotivos.ItemIndex;
         dtmServidor.qryUpdate.Params.ParamByName('status_solicitacao').AsString := '2';
         dtmServidor.qryUpdate.Params.ParamByName('cod_solicitacao').AsString := sCodSolicitacao;

         dtmServidor.qryUpdate.ExecSQL;

         try
             if dtmServidor.fdConexao.InTransaction then
             begin
                dtmServidor.fdConexao.Commit;
             end;
         except
            TLoading.ToastMessage(frmNotificacoes,
                               'N�o foi poss�vel realizar a opera��o!',
                                $FFFA3F3F,
                                TAlignLayout.Top);
            Exit;
         end;
      end;
   finally
      TLoading.ToastMessage(frmNotificacoes,
                            'Resposta enviada com sucesso!',
                             $FF22AF70,
                             TAlignLayout.Top);

      LimpaTodosFramesNotificacoes;
      ListarNotificacoes;
      lytOpaco.Visible := False;
      lytNegativa.Visible := False;
   end;
end;

procedure TfrmNotificacoes.BuscaInformacoesPerfil(Nome, Telefone, Endereco, Cidade, TelefoneLar,
                                                  CidadeLar, EnderecoLar, Telas, TipoAnimal: String);
begin
   lblNome.Text := lblNome.Text + Nome;
   lblTelefone.Text := lblTelefone.Text + Telefone;
   lblEndereco.Text := lblEndereco.Text + Endereco;
   lblCidade.Text := lblCidade.Text + Cidade;
   lblTelefoneLar.Text := lblTelefoneLar.Text + TelefoneLar;
   lblEnderecoLar.Text := lblEnderecoLar.Text + EnderecoLar;
   lblCidadeLar.Text := lblCidadeLar.Text + CidadeLar;
   lblTelas.Text := lblTelas.Text + Telas;
   lblTipo.Text :=  lblTipo.Text + TipoAnimal;
end;

procedure TfrmNotificacoes.BuscaSolicitacao(CodSolicitacao: String);
begin
   sCodSolicitacao := CodSolicitacao;
end;

procedure TfrmNotificacoes.cbxMotivosEnter(Sender: TObject);
begin
   if (cbxMotivos.Items.Text = '') then
   begin
      cbxMotivos.Items.Add('Selecione');

      cbxMotivos.ItemIndex := 0;

      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Text := '';
      dtmServidor.qryGeral.SQL.Text := ' SELECT descricao            '+
                                       ' FROM motivos                '+
                                       ' WHERE cod_motivo in (1,2,3) '+
                                       ' ORDER BY cod_motivo         ';
      dtmServidor.qryGeral.Active := True;

      while not dtmServidor.qryGeral.Eof do
      begin
         cbxMotivos.Items.Add(dtmServidor.qryGeral.FieldByName('descricao').AsString);

         dtmServidor.qryGeral.Next;
      end;
   end;
end;

procedure TfrmNotificacoes.FormShow(Sender: TObject);
begin
   lytNaoEncontrou.Visible := False;
   lytOpaco.Visible := False;
   lytPerfil.Visible := False;
   lytNegativa.Visible := False;

   if not Assigned(frmEdicaoLares) then
   begin
      Application.CreateForm(TfrmNotificacoes, frmNotificacoes);

      LimpaTodosFramesNotificacoes;
      ListarNotificacoes;
      frmNotificacoes.Show;
   end
   else
   begin
      LimpaTodosFramesNotificacoes;
      ListarNotificacoes;
   end;
end;

procedure TfrmNotificacoes.imgVoltarClick(Sender: TObject);
begin
   frmPaginaInicial.Show;
   frmNotificacoes.Close;
end;

procedure TfrmNotificacoes.LimpaTodosFramesNotificacoes;
var
   i: Integer;
begin
   for i := ComponentCount - 1 downto 0 do
   begin
      if Components[i] is TFrameNotificacoes then
      begin
         TFrameNotificacoes(Components[i]).Free;
      end;
   end;

   for i := ComponentCount - 1 downto 0 do
   begin
      if Components[i] is TFrameNotificacoesRespondidas then
      begin
         TFrameNotificacoesRespondidas(Components[i]).Free;
      end;
   end;
end;

procedure TfrmNotificacoes.ListarNotificacoes;
var
   Frame: TFrameNotificacoes;
   Frame2: TFrameNotificacoesRespondidas;
   sCodSolicitacao, sNomePessoa, sTipo, sNomeAnimal, sCodPessoaSolicitada, sCodLar,
   sCodPessoa, sStatus, sMotivo: String;
   i: Integer;
begin
   lytNaoEncontrou.Visible := False;

   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Text := '';
   dtmServidor.qryGeral.SQL.Text := ' SELECT a.Tipo_Solicitacao,                             '+
                                    '        a.Cod_Solicitacao,                              '+
                                    '        a.Status_Solicitacao,                           '+
                                    '        a.Cod_Animal,                                   '+
                                    '        a.Cod_Pessoa,                                   '+
                                    '        a.Cod_Pessoa_Solicitada,                        '+
                                    '        a.Cod_Lar,                                      '+
                                    '        a.Cod_Motivo,                                   '+
                                    '        b.Nome_Animal,                                  '+
                                    '        c.Nome_Pessoa                                   '+
                                    ' FROM solicitacoes a, animais b, pessoas c              '+
                                    ' WHERE a.cod_animal = b.cod_animal                      '+
                                    ' AND a.cod_pessoa = c.cod_pessoa                        '+
                                    ' AND a.status_solicitacao in (0,1,2)                    '+
                                    ' AND (a.cod_pessoa_solicitada = '+frmLogin.sUsuarioLogado+
                                    ' OR a.cod_pessoa = '+frmLogin.sUsuarioLogado+')         ';

   dtmServidor.qryGeral.Active := True;

   if (dtmServidor.qryGeral.RecordCount > 0) then
   begin
       i := 1;
       dtmServidor.qryGeral.First;
       while not dtmServidor.qryGeral.Eof do
       begin
          if (dtmServidor.qryGeral.FieldByName('cod_pessoa_solicitada').AsString = frmLogin.sUsuarioLogado) and
             (dtmServidor.qryGeral.FieldByName('status_solicitacao').AsString = '0') then
          begin
             sCodSolicitacao := dtmServidor.qryGeral.FieldByName('cod_solicitacao').AsString;
             sNomePessoa := dtmServidor.qryGeral.FieldByName('nome_pessoa').AsString;
             sTipo := dtmServidor.qryGeral.FieldByName('tipo_solicitacao').AsString;
             sStatus := dtmServidor.qryGeral.FieldByName('status_solicitacao').AsString;
             sNomeAnimal := dtmServidor.qryGeral.FieldByName('nome_animal').AsString;
             sCodPessoaSolicitada := dtmServidor.qryGeral.FieldByName('cod_pessoa_solicitada').AsString;
             sCodPessoa := dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString;
             sCodLar := dtmServidor.qryGeral.FieldByName('cod_lar').AsString;

             Frame := TFrameNotificacoes.Create(Self);
             Frame.Tag := StrToInt(sCodSolicitacao);
             Frame.Parent := vbsNotificacoes;
             frame.align := TAlignLayout.Top;
             Frame.Name := 'Frame_' + sCodSolicitacao + '_' + IntToStr(i); // Definir um nome �nico para cada frame
             Frame.Visible := True;
             frame.Margins.Top := 2; // Margem superior
             frame.Margins.Bottom := 2; // Margem inferior

             if (sTipo = 'Adotar') then
             begin
                Frame.lblNotificacao.text := 'O usu�rio '+sNomePessoa+' deseja adotar o pet '+sNomeAnimal+'.';
                Frame.lblCodSolicitacao.Text := sCodSolicitacao;
             end
             else
             begin
                Frame.lblNotificacao.text := 'O usu�rio '+sNomePessoa+' deseja oferecer lar tempor�rio para o pet '+sNomeAnimal+'.';
                Frame.lblCodSolicitacao.Text := sCodSolicitacao;
             end;

             // Se o conte�do do frame for maior que o ScrollBox, ajuste a altura do ScrollBox
             if frame.Height > vbsNotificacoes.Height then
             begin
                vbsNotificacoes.Height := frame.Height;
             end;

             i := i + 1;
          end
          else
          if (dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString = frmLogin.sUsuarioLogado) and
             ((dtmServidor.qryGeral.FieldByName('status_solicitacao').AsString = '1') or
              (dtmServidor.qryGeral.FieldByName('status_solicitacao').AsString = '2')) then
          begin
             sCodSolicitacao := dtmServidor.qryGeral.FieldByName('cod_solicitacao').AsString;
             sNomePessoa := dtmServidor.qryGeral.FieldByName('nome_pessoa').AsString;
             sTipo := dtmServidor.qryGeral.FieldByName('tipo_solicitacao').AsString;
             sStatus := dtmServidor.qryGeral.FieldByName('status_solicitacao').AsString;
             sNomeAnimal := dtmServidor.qryGeral.FieldByName('nome_Animal').AsString;
             sCodPessoaSolicitada := dtmServidor.qryGeral.FieldByName('cod_pessoa_solicitada').AsString;
             sCodPessoa := dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString;
             sCodLar := dtmServidor.qryGeral.FieldByName('cod_lar').AsString;

             Frame2 := TFrameNotificacoesRespondidas.Create(Self);
             Frame2.Tag := StrToInt(sCodSolicitacao);
             Frame2.Parent := vbsNotificacoes;
             frame2.align := TAlignLayout.Top;
             Frame2.Name := 'Frame2_' + sCodSolicitacao + '_' + IntToStr(i);
             Frame2.Visible := True;
             frame2.Margins.Top := 2;
             frame2.Margins.Bottom := 2;

             if (sStatus = '1') then
             begin
                if (sTipo = 'Hospedar') then
                begin
                   Frame2.lblNotificacao.text := 'Sua solicita��o para hospedar o pet '+sNomeAnimal+' foi aprovada.';
                   Frame2.lblCodSolicitacao.Text := sCodSolicitacao;
                end
                else
                begin
                   Frame2.lblNotificacao.text := 'Sua solicita��o para adotar o pet '+sNomeAnimal+' foi aprovada.';
                   Frame2.lblCodSolicitacao.Text := sCodSolicitacao;
                end;

             end
             else
             begin
                dtmServidor.qryGeral2.Active := False;
                dtmServidor.qryGeral2.SQL.Text := '';
                dtmServidor.qryGeral2.SQL.Text := ' SELECT descricao '+
                                                  ' FROM motivos  '+
                                                  ' WHERE cod_motivo = :cod_motivo ';

                dtmServidor.qryGeral2.Params.ParamByName('cod_motivo').AsString := dtmServidor.qryGeral.FieldByName('cod_motivo').AsString;
                dtmServidor.qryGeral2.Active := True;

                sMotivo := dtmServidor.qryGeral2.FieldByName('descricao').AsString;

                if (sTipo = 'Hospedar') then
                begin
                   Frame2.lblNotificacao.text := 'Sua solicita��o para hospedar o pet '+sNomeAnimal+' foi negada.'+#13+
                                                 'Motivo: '+sMotivo;
                   Frame2.lblCodSolicitacao.Text := sCodSolicitacao;
                end
                else
                begin
                   Frame2.lblNotificacao.text := 'Sua solicita��o para adotar o pet '+sNomeAnimal+' foi negada.'+#13+
                                                 'Motivo: '+sMotivo;
                   Frame2.lblCodSolicitacao.Text := sCodSolicitacao;
                end;
             end;

             // Se o conte�do do frame for maior que o ScrollBox, ajuste a altura do ScrollBox
             if frame2.Height > vbsNotificacoes.Height then
             begin
                vbsNotificacoes.Height := frame2.Height;
             end;

             i := i + 1;
          end;

          dtmServidor.qryGeral.Next;
       end;

       if i = 1 then
       begin
          lytNaoEncontrou.Visible := True;
       end;
   end
   else
   begin
      lytNaoEncontrou.Visible := True;
   end;
end;

end.
