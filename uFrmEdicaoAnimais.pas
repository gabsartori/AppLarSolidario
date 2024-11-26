unit uFrmEdicaoAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, Data.DB;

type
  TfrmEdicaoAnimais = class(TForm)
    Rectangle1: TRectangle;
    Image1: TImage;
    Image2: TImage;
    imgVoltar: TImage;
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    lbAnimais: TListBox;
    vbsAnimais: TVertScrollBox;
    lytNaoEncontrou: TLayout;
    Label2: TLabel;
    Image4: TImage;
    Rectangle2: TRectangle;
    lytOpaco: TLayout;
    Rectangle3: TRectangle;
    lytConfirmaInativacao: TLayout;
    Panel1: TPanel;
    btnSim: TRoundRect;
    Label5: TLabel;
    btnNao: TRoundRect;
    Label6: TLabel;
    lblConfirmacao: TLabel;
    procedure ListarAnimais;
    procedure imgVoltarClick(Sender: TObject);
    procedure LimpaTodosFramesEditarAnimais;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ParametrosInativacao(IndAnimal, CodAnimal: String);
    procedure btnSimClick(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
  private
    { Private declarations }
    sIndAnimal, sCodAnimal: String;
  public
    { Public declarations }
  end;

var
  frmEdicaoAnimais: TfrmEdicaoAnimais;

implementation

{$R *.fmx}

uses uDtmServidor, Frame.EditarAnimais, uFrmLogin, uFunctions,
  uPaginaConfiguracoes, Notificacao, uFrmEdicaoLares;

{ TfrmEdicaoAnimais }

procedure TfrmEdicaoAnimais.btnNaoClick(Sender: TObject);
begin
   lytOpaco.Visible := False;
   lytConfirmaInativacao.Visible := False;
end;

procedure TfrmEdicaoAnimais.btnSimClick(Sender: TObject);
begin
   if (sIndAnimal = 'Desativar') then
   begin
      try
         dtmServidor.qryUpdate.Active := False;
         dtmServidor.qryUpdate.SQL.Clear;
         dtmServidor.qryUpdate.SQL.Text := ' UPDATE animais                 '+
                                           ' SET ind_ativo = 0              '+
                                           ' WHERE cod_animal = :cod_animal ';

         dtmServidor.qryUpdate.Params.ParamByName('cod_animal').AsString := sCodAnimal;

         dtmServidor.qryUpdate.ExecSQL;

         try
             if dtmServidor.fdConexao.InTransaction then
             begin
                dtmServidor.fdConexao.Commit;
             end;
         except
            TLoading.ToastMessage(frmEdicaoAnimais,
                                 'N�o foi poss�vel realizar a opera��o!',
                                  $FFFA3F3F,
                                  TAlignLayout.Top);
            Exit;
         end;

      finally
         TLoading.ToastMessage(frmEdicaoAnimais,
                              'Pet inativado com sucesso',
                               $FF22AF70,
                               TAlignLayout.Top);

         LimpaTodosFramesEditarAnimais;
         ListarAnimais;
         lytOpaco.Visible := False;
         lytConfirmaInativacao.Visible := False;
      end;
   end
   else
   begin
      try
          dtmServidor.qryUpdate.Active := False;
          dtmServidor.qryUpdate.SQL.Clear;
          dtmServidor.qryUpdate.SQL.Text := ' UPDATE animais '+
                                            ' SET ind_ativo = 1 '+
                                            ' WHERE cod_animal = :cod_animal ';

          dtmServidor.qryUpdate.Params.ParamByName('cod_animal').AsString := sCodAnimal;

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
                               'Pet ativado com sucesso',
                                $FF22AF70,
                                TAlignLayout.Top);

         LimpaTodosFramesEditarAnimais;
         ListarAnimais;
         lytOpaco.Visible := False;
         lytConfirmaInativacao.Visible := False;
      end;
   end;
end;

procedure TfrmEdicaoAnimais.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   LimpaTodosFramesEditarAnimais;
end;

procedure TfrmEdicaoAnimais.FormShow(Sender: TObject);
begin
   lytNaoEncontrou.Visible := False;
   lytOpaco.Visible := False;
   lytConfirmaInativacao.Visible := False;

   if not Assigned(frmEdicaoAnimais) then
   begin
      Application.CreateForm(TfrmEdicaoAnimais, frmEdicaoAnimais);

      LimpaTodosFramesEditarAnimais;
      ListarAnimais;
      frmEdicaoAnimais.Show;
   end
   else
   begin
      LimpaTodosFramesEditarAnimais;
      ListarAnimais;
   end;
end;

procedure TfrmEdicaoAnimais.imgVoltarClick(Sender: TObject);
begin
   LimpaTodosFramesEditarAnimais;
   frmEdicaoAnimais.Close;
   frmPaginaConfiguracoes.Show;
end;

procedure TfrmEdicaoAnimais.LimpaTodosFramesEditarAnimais;
var
   i: Integer;
begin
   for i := ComponentCount - 1 downto 0 do
   begin
      if Components[i] is TFrameEditarAnimais then
      begin
         TFrameEditarAnimais(Components[i]).Free;
      end;
   end;
end;

procedure TfrmEdicaoAnimais.ListarAnimais;
var
   Frame : TFrameEditarAnimais;
   sCodAnimal, sNome, sTipo, sCor, sGenero, sCastrado, sIdade, sResponsavel, sSituacao,
   sEndereco, sTelefone, sInformacoes, sSelectGenero, sSelectTipo, sSelectCastrado: String;
   i : Integer;
begin
   try
      lytNaoEncontrou.Visible := False;
      lbAnimais.Items.Clear;

      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Text := '';
      dtmServidor.qryGeral.SQL.Text := ' SELECT cod_animal,                              '+
                                       '        nome_animal,                             '+
                                       '        cor_pelagem,                             '+
                                       '        UF,                                      '+
                                       '        CASE                                     '+
                                       '          WHEN ind_castrado = 1 THEN ''Sim''     '+
                                       '          ELSE ''N�o''                           '+
                                       '        END AS castrado,                         '+
                                       '        CASE                                     '+
                                       '          WHEN tipo_animal = 1 THEN ''Cachorro'' '+
                                       '          ELSE ''Gato''                          '+
                                       '        END AS tipo_animal,                      '+
                                       '        situacao_animal,                         '+
                                       '        ind_ativo,                               '+
                                       '        des_endereco_animal,                     '+
                                       '        des_bairro_animal,                       '+
                                       '        CASE                                     '+
                                       '          WHEN genero_animal = 1 THEN ''F�mea''  '+
                                       '          ELSE ''Macho''                         '+
                                       '        END AS genero_animal,                    '+
                                       '        informacoes_animal,                      '+
                                       '        idade_animal,                            '+
                                       '        foto_animal,                             '+
                                       '        cod_cidade                               '+
                                       ' FROM animais                                    '+
                                       ' WHERE cod_pessoa = '+ frmLogin.sUsuarioLogado    +
                                       ' ORDER BY cod_animal                             ';
      dtmServidor.qryGeral.Active := True;

      if (dtmServidor.qryGeral.RecordCount > 0) then
      begin
          i := 1;
          dtmServidor.qryGeral.First;
          while not dtmServidor.qryGeral.Eof do
          begin
             dtmServidor.qryGeral2.Active := False;
             dtmServidor.qryGeral2.SQL.Text := '';
             dtmServidor.qryGeral2.SQL.Text := ' SELECT nome_cidade, UF                                                         '+
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
             sSituacao := dtmServidor.qryGeral.FieldByName('situacao_animal').AsString;
             sEndereco := dtmServidor.qryGeral.FieldByName('des_endereco_animal').AsString + ', '+
                          dtmServidor.qryGeral.FieldByName('des_bairro_animal').AsString + ', '+
                          dtmServidor.qryGeral2.FieldByName('nome_cidade').AsString + ', '+
                          dtmServidor.qryGeral2.FieldByName('uf').AsString;
             sInformacoes := dtmServidor.qryGeral.FieldByName('informacoes_animal').AsString;

             Frame := TFrameEditarAnimais.Create(Self);
             Frame.Tag := StrToInt(sCodAnimal);
             Frame.Parent := vbsAnimais;
             frame.align := TAlignLayout.Top;
             Frame.Name := 'Frame_' + sCodAnimal + '_' + IntToStr(i); // Definir um nome �nico para cada frame
             Frame.Visible := True;
             frame.Margins.Top := 2; // Margem superior
             frame.Margins.Bottom := 2; // Margem inferior

             Frame.lblCodAnimal.Text := sCodAnimal;
             Frame.lblNome.text := sNome;
             Frame.lblCor.Text := Frame.lblCor.Text + ' ' + sCor;
             Frame.lblTipo.Text := Frame.lblTipo.Text + ' ' + sTipo;
             Frame.lblGenero.Text := Frame.lblGenero.Text + ' ' + sGenero;
             Frame.lblEndereco.Text := Frame.lblEndereco.Text + ' ' + sEndereco;

             if (sInformacoes <> '') then
             begin
                Frame.lblInformacoes.Text := Frame.lblInformacoes.Text + ' ' + sInformacoes;
             end
             else
             begin
                Frame.lblInformacoes.Text := Frame.lblInformacoes.Text + ' Sem informa��es adicionais.';
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

             if (dtmServidor.qryGeral.FieldByName('ind_ativo').AsString = '0') then
             begin
                Frame.lblDesativar.Text := 'Ativar';
             end;

             if (sSituacao = 'Adotado') then
             begin
                Frame.btnDesativar.Enabled := False;
                Frame.btnEditar.Enabled := False;
             end;

             if frame.Height > vbsAnimais.Height then
             begin
                vbsAnimais.Height := frame.Height;
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

procedure TfrmEdicaoAnimais.ParametrosInativacao(IndAnimal, CodAnimal: String);
begin
   sIndAnimal := IndAnimal;
   sCodAnimal := CodAnimal;
end;

end.
