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
    procedure ListarLares;
    procedure FormShow(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEdicaoLares: TfrmEdicaoLares;

implementation

{$R *.fmx}

uses Frame.EditarLaresTemporarios, uDtmServidor, uFrmLogin, uPaginaConfiguracoes;

{ TfrmEdicaoLares }

procedure TfrmEdicaoLares.FormShow(Sender: TObject);
begin
   lytNaoEncontrou.Visible := False;
   ListarLares;
end;

procedure TfrmEdicaoLares.btnVoltarClick(Sender: TObject);
begin
   lbLaresTemporarios.Clear;
   frmEdicaoLares.Close;
   frmPaginaConfiguracoes.Show;
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
      dtmServidor.qryGeral.SQL.Text := ' select cod_lar,                              '+
                                       '        nome_lar,                             '+
                                       '        Des_Endereco_Lar,                     '+
                                       '        Des_Bairro_Lar,                       '+
                                       '        UF,                                   '+
                                       '        CASE                                  '+
                                       '          WHEN ind_ativo = 1 THEN ''Ativo''   '+
                                       '          ELSE ''Inativo''                    '+
                                       '        END AS situacao,                      '+
                                       '        Telefone_Lar,                         '+
                                       '        Qtd_Animais,                          '+
                                       '        Tipo_Animal,                          '+
                                       '        Informacoes_Lar,                      '+
                                       '        CASE                                  '+
                                       '          WHEN Ind_Telas = 1 THEN ''Sim''     '+
                                       '          ELSE ''N�o''                        '+
                                       '        END AS Telas,                         '+
                                       '        cod_cidade                            '+
                                       ' from lartemporario                           '+
                                       ' where cod_pessoa = '+ frmLogin.sUsuarioLogado +
                                       ' order by cod_lar                             ';
      dtmServidor.qryGeral.Active := True;

      if (dtmServidor.qryGeral.RecordCount > 0) then
      begin
          i := 1;
          dtmServidor.qryGeral.First;
          while not dtmServidor.qryGeral.Eof do
          begin
             dtmServidor.qryGeral2.Active := False;
             dtmServidor.qryGeral2.SQL.Text := '';
             dtmServidor.qryGeral2.SQL.Text := ' select nome_cidade                                                          '+
                                               ' from cidades                                                                '+
                                               ' where cod_cidade = '+ dtmServidor.qryGeral.FieldByName('cod_cidade').AsString;
             dtmServidor.qryGeral2.Active := True;

             sCodLar := dtmServidor.qryGeral.FieldByName('cod_lar').AsString;
             sNome := dtmServidor.qryGeral.FieldByName('nome_lar').AsString;
             sTipo := dtmServidor.qryGeral.FieldByName('tipo_animal').AsString;
             sSituacao := dtmServidor.qryGeral.FieldByName('situacao').AsString;
             sEndereco := dtmServidor.qryGeral.FieldByName('Des_Endereco_Lar').AsString + ', '+
                          dtmServidor.qryGeral.FieldByName('Des_Bairro_Lar').AsString + ', '+
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
             Frame.lblCodLar.Text := Frame.lblCodLar.Text + ' ' + sCodLar;
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
