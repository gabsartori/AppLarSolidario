unit uFrmEdicaoAnimais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox;

type
  TfrmEdicaoAnimais = class(TForm)
    Rectangle1: TRectangle;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Layout1: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    lbAnimais: TListBox;
    vbsAnimais: TVertScrollBox;
    lytNaoEncontrou: TLayout;
    Label2: TLabel;
    Image4: TImage;
    procedure ListarAnimais;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEdicaoAnimais: TfrmEdicaoAnimais;

implementation

{$R *.fmx}

uses uDtmServidor, Frame.EditarAnimais, uLogin;

{ TfrmEdicaoAnimais }

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
      dtmServidor.qryGeral.SQL.Text := ' select cod_animal,                              '+
                                       '        nome_animal,                             '+
                                       '        Des_Endereco_animal,                     '+
                                       '        Des_Bairro_animal,                       '+
                                       '        Genero_Animal,                        '+
                                       '        Idade_Animal,                         '+
                                       '        Cor_Pelagem,                          '+
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
                                       '          ELSE ''Não''                        '+
                                       '        END AS Telas,                         '+
                                       '        cod_cidade                            '+
                                       ' from animais                                 '+
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
             sCodAnimal := dtmServidor.qryGeral.FieldByName('cod_animal').AsString;
             sNome := dtmServidor.qryGeral.FieldByName('nome_animal').AsString;
             sTipo := dtmServidor.qryGeral.FieldByName('tipo_animal').AsString;
             sCor := dtmServidor.qryGeral.FieldByName('cor_pelagem').AsString;
             sGenero := dtmServidor.qryGeral.FieldByName('genero_animal').AsString;
             sCastrado := dtmServidor.qryGeral.FieldByName('castrado').AsString;
             sIdade := dtmServidor.qryGeral.FieldByName('idade_animal').AsString;
             sResponsavel := dtmServidor.qryGeral.FieldByName('Nome_Pessoa').AsString;
             sSituacao := dtmServidor.qryGeral.FieldByName('situacao_animal').AsString;
             sEndereco := dtmServidor.qryGeral.FieldByName('Des_Endereco_Animal').AsString;
             sTelefone := dtmServidor.qryGeral.FieldByName('telefone_pessoa').AsString;
             sInformacoes := dtmServidor.qryGeral.FieldByName('informacoes_animal').AsString;

             Frame := TFrameAnimaisCadastrados.Create(Self);
             Frame.Tag := StrToInt(sCodAnimal);
             Frame.Parent := vbsListaAnimais;
             frame.align := TAlignLayout.Top;
             Frame.Name := 'Frame_' + sCodAnimal + '_' + IntToStr(i); // Definir um nome único para cada frame
             Frame.Visible := True;
             frame.Margins.Top := 2; // Margem superior
             frame.Margins.Bottom := 2; // Margem inferior

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
                Frame.lblInformacoes.Text := Frame.lblInformacoes.Text + ' Sem informações adicionais.';
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

             // Se o conteúdo do frame for maior que o ScrollBox, ajuste a altura do ScrollBox
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
