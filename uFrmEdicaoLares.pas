unit uFrmEdicaoLares;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox;

type
  TfrmEdicaoLares = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Image1: TImage;
    Image2: TImage;
    btnVoltar: TImage;
    Layout2: TLayout;
    Label1: TLabel;
    lbLaresTemporarios: TListBox;
    vbsLaresTemporarios: TVertScrollBox;
    lytNaoEncontrou: TLayout;
    Label2: TLabel;
    Image3: TImage;
    Rectangle2: TRectangle;
    lytConfirmaInativacao: TLayout;
    Panel1: TPanel;
    btnSim: TRoundRect;
    Label5: TLabel;
    btnNao: TRoundRect;
    Label6: TLabel;
    lblConfirmacao: TLabel;
    lytOpaco: TLayout;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    procedure ListarLares;
    procedure FormShow(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure LimpaTodosFramesEditarLares;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSimClick(Sender: TObject);
    procedure ParametrosInativacao(IndLar, CodLar: String);
    procedure btnNaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sIndLar, sCodLar: String;
  end;

var
  frmEdicaoLares: TfrmEdicaoLares;

implementation

{$R *.fmx}

uses Frame.EditarLaresTemporarios, uDtmServidor, uFrmLogin, uPaginaConfiguracoes,
  Notificacao;

{ TfrmEdicaoLares }

procedure TfrmEdicaoLares.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   LimpaTodosFramesEditarLares;
   Action := TCloseAction.caFree;
end;

procedure TfrmEdicaoLares.FormShow(Sender: TObject);
begin
   lytNaoEncontrou.Visible := False;
   lytOpaco.Visible := False;
   lytConfirmaInativacao.Visible := False;

   if not Assigned(frmEdicaoLares) then
   begin
      Application.CreateForm(TfrmEdicaoLares, frmEdicaoLares);

      LimpaTodosFramesEditarLares;
      ListarLares;
      frmEdicaoLares.Show;
   end
   else
   begin
      LimpaTodosFramesEditarLares;
      ListarLares;
   end;
end;

procedure TfrmEdicaoLares.btnNaoClick(Sender: TObject);
begin
   lytOpaco.Visible := False;
   lytConfirmaInativacao.Visible := False;
end;

procedure TfrmEdicaoLares.btnSimClick(Sender: TObject);
begin
   if (sIndLar = 'Desativar') then
   begin
       try
          dtmServidor.qryUpdate.Active := False;
          dtmServidor.qryUpdate.SQL.Clear;
          dtmServidor.qryUpdate.SQL.Text := ' UPDATE LarTemporario '+
                                            ' SET ind_ativo = 0 '+
                                            ' WHERE cod_lar = :cod_lar ';

          dtmServidor.qryUpdate.Params.ParamByName('cod_lar').AsString := sCodLar;

          dtmServidor.qryUpdate.ExecSQL;

          try
              if dtmServidor.fdConexao.InTransaction then
              begin
                 dtmServidor.fdConexao.Commit;
              end;
          except
             TLoading.ToastMessage(frmEdicaoLares,
                                  'N�o foi poss�vel realizar a opera��o!',
                                   $FFFA3F3F,
                                   TAlignLayout.Top);
             Exit;
          end;

       finally
          TLoading.ToastMessage(frmEdicaoLares,
                               'Lar inativado com sucesso',
                                $FF22AF70,
                                TAlignLayout.Top);

          LimpaTodosFramesEditarLares;
          ListarLares;
          lytOpaco.Visible := False;
          lytConfirmaInativacao.Visible := False;
       end;
   end
   else
   begin
       try
           dtmServidor.qryUpdate.Active := False;
           dtmServidor.qryUpdate.SQL.Clear;
           dtmServidor.qryUpdate.SQL.Text := ' UPDATE LarTemporario '+
                                             ' SET ind_ativo = 1 '+
                                             ' WHERE cod_lar = :cod_lar ';

           dtmServidor.qryUpdate.Params.ParamByName('cod_lar').AsString := sCodLar;

           dtmServidor.qryUpdate.ExecSQL;

           try
               if dtmServidor.fdConexao.InTransaction then
               begin
                  dtmServidor.fdConexao.Commit;
               end;
           except
              TLoading.ToastMessage(frmEdicaoLares,
                                   'N�o foi poss�vel realizar a opera��o!',
                                    $FFFA3F3F,
                                    TAlignLayout.Top);
              Exit;
           end;

       finally
           TLoading.ToastMessage(frmEdicaoLares,
                                'Lar ativado com sucesso',
                                 $FF22AF70,
                                 TAlignLayout.Top);

           LimpaTodosFramesEditarLares;
           ListarLares;
           lytOpaco.Visible := False;
           lytConfirmaInativacao.Visible := False;
       end;
   end;
end;

procedure TfrmEdicaoLares.btnVoltarClick(Sender: TObject);
begin
   frmEdicaoLares.Close;
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmEdicaoLares.ParametrosInativacao(IndLar, CodLar: String);
begin
   sIndLar := IndLar;
   sCodLar := CodLar;
end;

procedure TfrmEdicaoLares.LimpaTodosFramesEditarLares;
var
   i: Integer;
begin
   for i := ComponentCount - 1 downto 0 do
   begin
      if Components[i] is TFrameEditarLaresTemporarios then
      begin
         TFrameEditarLaresTemporarios(Components[i]).Free;
      end;
   end;
end;

procedure TfrmEdicaoLares.ListarLares;
var
   Frame: TFrameEditarLaresTemporarios;
   sCodLar, sNome, sTipo, sTelas, sSituacao, sEndereco, sTelefone, sInformacoes, sQtdAnimais: String;
   i: Integer;
begin
   try
      lytNaoEncontrou.Visible := False;
      lbLaresTemporarios.Items.Clear;

      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Text := '';
      dtmServidor.qryGeral.SQL.Text := ' select cod_lar,                                 '+
                                       '        nome_lar,                                '+
                                       '        des_endereco_lar,                        '+
                                       '        des_bairro_lar,                          '+
                                       '        UF,                                      '+
                                       '        CASE                                     '+
                                       '          WHEN ind_ativo = 1 THEN ''Ativo''      '+
                                       '          ELSE ''Inativo''                       '+
                                       '        END AS situacao,                         '+
                                       '        telefone_lar,                            '+
                                       '        qtd_animais,                             '+
                                       '        CASE                                     '+
                                       '          WHEN tipo_animal = 1 THEN ''Cachorro'' '+
                                       '          WHEN tipo_animal = 2 THEN ''Gato''     '+
                                       '          ELSE ''Ambos''                         '+
                                       '        END AS tipo_animal,                      '+
                                       '        informacoes_lar,                         '+
                                       '        CASE                                     '+
                                       '          WHEN Ind_Telas = 1 THEN ''Sim''        '+
                                       '          ELSE ''N�o''                           '+
                                       '        END AS telas,                            '+
                                       '        cod_cidade                               '+
                                       ' FROM LarTemporario                              '+
                                       ' WHERE cod_pessoa = '+ frmLogin.sUsuarioLogado    +
                                       ' ORDER BY cod_lar                                ';
      dtmServidor.qryGeral.Active := True;

      if (dtmServidor.qryGeral.RecordCount > 0) then
      begin
          i := 1;
          dtmServidor.qryGeral.First;
          while not dtmServidor.qryGeral.Eof do
          begin
             dtmServidor.qryGeral2.Active := False;
             dtmServidor.qryGeral2.SQL.Text := '';
             dtmServidor.qryGeral2.SQL.Text := ' SELECT nome_cidade                                                          '+
                                               ' FROM cidades                                                                '+
                                               ' WHERE cod_cidade = '+ dtmServidor.qryGeral.FieldByName('cod_cidade').AsString;
             dtmServidor.qryGeral2.Active := True;

             sCodLar := dtmServidor.qryGeral.FieldByName('cod_lar').AsString;
             sNome := dtmServidor.qryGeral.FieldByName('nome_lar').AsString;
             sTipo := dtmServidor.qryGeral.FieldByName('tipo_animal').AsString;
             sSituacao := dtmServidor.qryGeral.FieldByName('situacao').AsString;
             sEndereco := dtmServidor.qryGeral.FieldByName('des_endereco_lar').AsString + ', '+
                          dtmServidor.qryGeral.FieldByName('des_bairro_lar').AsString + ', '+
                          dtmServidor.qryGeral2.FieldByName('nome_cidade').AsString + ', '+
                          dtmServidor.qryGeral.FieldByName('uf').AsString;
             sTelefone := dtmServidor.qryGeral.FieldByName('telefone_lar').AsString;
             sInformacoes := dtmServidor.qryGeral.FieldByName('informacoes_lar').AsString;
             sQtdAnimais := dtmServidor.qryGeral.FieldByName('qtd_animais').AsString;
             sTelas := dtmServidor.qryGeral.FieldByName('telas').AsString;

             Frame := TFrameEditarLaresTemporarios.Create(Self);
             Frame.Tag := StrToInt(sCodLar);
             Frame.Parent := vbsLaresTemporarios;
             frame.align := TAlignLayout.Top;
             Frame.Name := 'Frame_' + sCodLar + '_' + IntToStr(i); // Definir um nome �nico para cada frame
             Frame.Visible := True;
             frame.Margins.Top := 2; // Margem superior
             frame.Margins.Bottom := 2; // Margem inferior


             Frame.lblNome.text := sNome;
             Frame.lblCodLar.Text := sCodLar;
             Frame.lblEndereco.Text := Frame.lblEndereco.Text + ' ' + sEndereco;
             Frame.lblTelefone.Text := Frame.lblTelefone.Text + ' ' + sTelefone;
             Frame.lblTipoAnimal.Text := Frame.lblTipoAnimal.Text + ' ' + sTipo;
             Frame.lblTelas.Text := Frame.lblTelas.Text + ' ' + sTelas;
             Frame.lblQtdAnimais.Text := Frame.lblQtdAnimais.Text + ' ' + sQtdAnimais;
             Frame.lblSituacao.Text := Frame.lblSituacao.Text + ' ' + sSituacao;
             Frame.lblInformacoes.Text := Frame.lblInformacoes.Text + ' ' + sInformacoes;

             if (sInformacoes <> '') then
             begin
                Frame.lblInformacoes.Text := Frame.lblInformacoes.Text + ' ' + sInformacoes;
             end
             else
             begin
                Frame.lblInformacoes.Text := Frame.lblInformacoes.Text + ' Sem informa��es adicionais.';
             end;

             if (sSituacao = 'Inativo') then
             begin
                Frame.lblDesativar.Text := 'Ativar';
             end;

             // Se o conte�do do frame for maior que o ScrollBox, ajuste a altura do ScrollBox
             if frame.Height > vbsLaresTemporarios.Height then
             begin
                vbsLaresTemporarios.Height := frame.Height;
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
