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
    Label5: TLabel;
    cbxCastrado: TComboEdit;
    cbxCidade: TComboEdit;
    cbxTipoAnimal: TComboEdit;
    cbxEstado: TComboEdit;
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
//    procedure AddAnimais(lb: TListBox; iCodAnimal: Integer; sNome, sTipo, sCor, sGenero, sCastrado,
//                        sIdade, sResponsavel, sSituacao, sEndereco, sTelefone, sInformacoes: String);
    procedure ListarAnimais;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnLimparFiltrosClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
    procedure LimparLista;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPaginaBuscas: TfrmPaginaBuscas;

implementation

{$R *.fmx}

uses Frame.AnimaisCadastrados, uDtmServidor, uFunctions, uPaginaInicial;

{ TfrmPaginaBuscas }

{ TfrmPaginaBuscas }

//procedure TfrmPaginaBuscas.AddAnimais(lb: TListBox; iCodAnimal: Integer; sNome, sTipo, sCor,
//  sGenero, sCastrado, sIdade, sResponsavel, sSituacao, sEndereco, sTelefone, sInformacoes: String);
//var
//   item: TListBoxItem;
//begin
//   ///
//   item := TListBoxItem.Create(nil);
//   item.Text := '';
//   item.Tag := iCodAnimal;
//   item.Selectable := False;
//
//   lbAnimais.AddObject(item);
//end;

procedure TfrmPaginaBuscas.btnBuscarClick(Sender: TObject);
begin
   lbAnimais.Items.Clear;
   ListarAnimais;
   Rectangle2.Visible := True;
end;

procedure TfrmPaginaBuscas.btnLimparFiltrosClick(Sender: TObject);
begin
   cbxTipoAnimal.ItemIndex := 0;
   cbxCastrado.ItemIndex := 0;
   cbxGenero.ItemIndex := 0;
   cbxCidade.ItemIndex := 0;
   cbxEstado.ItemIndex := 0;
end;

procedure TfrmPaginaBuscas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   lbAnimais.Clear;
   Rectangle2.Visible := False;
end;

procedure TfrmPaginaBuscas.FormShow(Sender: TObject);
begin
   lytNaoEncontrou.Visible := False;
   LimparLista;
   Rectangle2.Visible := False;
end;

procedure TfrmPaginaBuscas.imgVoltarClick(Sender: TObject);
begin
   lbAnimais.Clear;
   frmPaginaBuscas.Close;
   frmPaginaInicial.Show;
end;

procedure TfrmPaginaBuscas.LimparLista;
var
  i: Integer;
begin
   // Percorre os itens do ListBox e libera os Frames
   for i := 0 to lbAnimais.Count - 1 do
   begin
     if lbAnimais.ListItems[i].TagObject is TFrame then
     begin
       // Libera o frame associado ao item, se houver
       lbAnimais.ListItems[i].TagObject.Free;
       lbAnimais.ListItems[i].TagObject := nil;
     end;
   end;
   // Limpa todos os itens do ListBox
   lbAnimais.Clear;
end;

procedure TfrmPaginaBuscas.ListarAnimais;
var
   Frame : TFrameAnimaisCadastrados;
   sCodAnimal, sNome, sTipo, sCor, sGenero, sCastrado, sIdade, sResponsavel, sSituacao,
   sEndereco, sTelefone, sInformacoes, sSelectGenero, sSelectTipo, sSelectCastrado: String;
   i : Integer;
begin
   try
      lytNaoEncontrou.Visible := False;
      lbAnimais.Items.Clear;

      if (cbxCastrado.ItemIndex = 1) then
      begin
         sSelectCastrado := 'and a.Ind_Castrado = 1 ';
      end
      else if (cbxCastrado.ItemIndex = 2) then
      begin
         sSelectCastrado := 'and a.Ind_Castrado = 2 ';
      end
      else
      begin
         sSelectCastrado := '';
      end;

      if (cbxGenero.ItemIndex = 1) then
      begin
         sSelectGenero := 'and a.Genero_Animal = 1 ';
      end
      else if (cbxGenero.ItemIndex = 2) then
      begin
         sSelectGenero := 'and a.Genero_Animal = 2 ';
      end
      else
      begin
         sSelectGenero := '';
      end;

      if (cbxTipoAnimal.ItemIndex = 1) then
      begin
         sSelectTipo := 'and a.Tipo_Animal = 1 ';
      end
      else if (cbxTipoAnimal.ItemIndex = 2) then
      begin
         sSelectTipo := 'and a.Tipo_Animal = 2 ';
      end
      else
      begin
         sSelectTipo := '';
      end;


      dtmServidor.qryGeral.Active := False;
      dtmServidor.qryGeral.SQL.Text := '';
      dtmServidor.qryGeral.SQL.Text := ' select a.cod_animal,                          '+
                                       '        a.nome_animal,                         '+
                                       '        a.cor_pelagem,                         '+
                                       '        CASE                                   '+
                                       '          WHEN a.ind_castrado = 1 THEN ''Sim'' '+
                                       '          ELSE ''N�o''                         '+
                                       '        END AS castrado,                       '+
                                       '        CASE                                   '+
                                       '          WHEN a.Tipo_Animal = 1 THEN ''Cachorro'' '+
                                       '          ELSE ''Gato''                         '+
                                       '        END AS tipo_animal,                       '+
                                       '        a.Situacao_Animal,                     '+
                                       '        a.Des_Endereco_Animal,                 '+
                                       '        CASE                                   '+
                                       '          WHEN a.Genero_Animal = 1 THEN ''F�mea'' '+
                                       '          ELSE ''Macho''                         '+
                                       '        END AS Genero_Animal,                       '+
                                       '        a.Informacoes_Animal,                  '+
                                       '        a.Idade_Animal,                        '+
                                       '        a.Foto_Animal,                         '+
                                       '        b.Nome_Pessoa,                         '+
                                       '        b.Telefone_Pessoa                      '+
                                       ' from animais a, pessoas b                     '+
                                       ' where a.cod_pessoa = b.cod_pessoa             '+
                                       sSelectGenero                                    +
                                       sSelectTipo                                      +
                                       sSelectCastrado                                  +
                                       ' order by nome_animal                          ';
      dtmServidor.qryGeral.Active := True;

      if (dtmServidor.qryGeral.RecordCount > 0) then
      begin
          i := 1;
          dtmServidor.qryGeral.First;
          while not dtmServidor.qryGeral.Eof do
          begin
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
             Frame.Name := 'Frame_' + sCodAnimal + '_' + IntToStr(i); // Definir um nome �nico para cada frame
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

             // Se o conte�do do frame for maior que o ScrollBox, ajuste a altura do ScrollBox
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
