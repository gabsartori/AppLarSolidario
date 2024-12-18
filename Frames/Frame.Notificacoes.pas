unit Frame.Notificacoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.VirtualKeyboard, FMX.Platform;

type
  TFrameNotificacoes = class(TFrame)
    lblNotificacao: TLabel;
    btnAceitar: TRoundRect;
    Label5: TLabel;
    btnRecusar: TRoundRect;
    Label6: TLabel;
    Rectangle4: TRectangle;
    btnVerPerfil: TRoundRect;
    Label1: TLabel;
    lblCodSolicitacao: TLabel;
    procedure btnVerPerfilClick(Sender: TObject);
    procedure btnRecusarClick(Sender: TObject);
    procedure btnAceitarClick(Sender: TObject);
  private
    { Private declarations }
    sNomePessoa, sTelefone, sEndereco, sCidade, sCodCidade, sTelas, sTipoAnimal,
    sCidadeLar, sCodCidadeLar, sEnderecoLar, sTelefoneLar: String;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDtmServidor, uFrmNotificacoes;

procedure TFrameNotificacoes.btnAceitarClick(Sender: TObject);
begin
   dtmServidor.qryGeral.SQL.Text := ' select cod_animal,      '+
                                    '        cod_lar,         '+
                                    '        cod_pessoa,      '+
                                    '        tipo_solicitacao '+
                                    ' from solicitacoes       '+
                                    ' where cod_solicitacao = '+lblCodSolicitacao.Text;
   dtmServidor.qryGeral.Active := True;

   if (lblCodSolicitacao.Text <> '') then
   begin
      if dtmServidor.qryGeral.FieldByName('tipo_solicitacao').AsString = 'Hospedar' then
      begin
          frmNotificacoes.AceitaSolicitacaoLar(lblCodSolicitacao.Text,
                                               dtmServidor.qryGeral.FieldByName('cod_animal').AsString,
                                               dtmServidor.qryGeral.FieldByName('cod_lar').AsString);
      end
      else
      begin
         frmNotificacoes.AceitaSolicitacaoAdocao(lblCodSolicitacao.Text,
                                                 dtmServidor.qryGeral.FieldByName('cod_animal').AsString,
                                                 dtmServidor.qryGeral.FieldByName('cod_pessoa').AsString);
      end;
      frmNotificacoes.Show;
   end;
end;

procedure TFrameNotificacoes.btnRecusarClick(Sender: TObject);
var
  VirtualKeyboard: IFMXVirtualKeyboardService;
begin
   if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
   begin
      VirtualKeyboard.HideVirtualKeyboard;
   end;

   if (lblCodSolicitacao.Text <> '') then
   begin
      frmNotificacoes.BuscaSolicitacao(lblCodSolicitacao.Text);
      frmNotificacoes.Show;
   end;

   frmNotificacoes.lytOpaco.Visible := True;
   frmNotificacoes.lytNegativa.Visible := True;
end;

procedure TFrameNotificacoes.btnVerPerfilClick(Sender: TObject);
var
  VirtualKeyboard: IFMXVirtualKeyboardService;
begin
   if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(VirtualKeyboard)) then
   begin
      VirtualKeyboard.HideVirtualKeyboard;
   end;

   dtmServidor.qryGeral.Active := False;
   dtmServidor.qryGeral.SQL.Text := '';
   dtmServidor.qryGeral.SQL.Text := ' select a.Nome_Pessoa,                 '+
                                    '        a.Telefone_Pessoa,             '+
                                    '        a.Des_Rua,                     '+
                                    '        a.Des_Bairro,                  '+
                                    '        a.UF as uf_pessoa,              '+
                                    '        a.Cod_Cidade as cidade_pessoa, '+
                                    '        c.Cod_Cidade as cidade_lar,    '+
                                    '        c.UF as uf_lar,                 '+
                                    '        c.Des_Bairro_Lar,              '+
                                    '        c.Des_Endereco_Lar,            '+
                                    '        c.Ind_Telas,                   '+
                                    '        c.Telefone_Lar,                '+
                                    '        c.Tipo_Animal                  '+
                                    ' from pessoas a, solicitacoes b, lartemporario c   '+
                                    ' where a.cod_pessoa = b.cod_pessoa             '+
                                    ' and a.cod_pessoa = c.cod_pessoa               '+
                                    ' and a.cod_pessoa = b.cod_pessoa         '+
                                    ' and b.cod_solicitacao = '+lblCodSolicitacao.Text;
   dtmServidor.qryGeral.Active := True;

   sNomePessoa := dtmServidor.qryGeral.FieldByName('nome_pessoa').AsString;
   sTelefone := dtmServidor.qryGeral.FieldByName('telefone_pessoa').AsString;
   sEndereco := dtmServidor.qryGeral.FieldByName('des_rua').AsString+', '+dtmServidor.qryGeral.FieldByName('des_bairro').AsString;
   sCodCidade := dtmServidor.qryGeral.FieldByName('cidade_pessoa').AsString;
   sCodCidadeLar := dtmServidor.qryGeral.FieldByName('cidade_Lar').AsString;
   sCidade := dtmServidor.qryGeral.FieldByName('uf_pessoa').AsString;

   dtmServidor.qryGeral2.Active := False;
   dtmServidor.qryGeral2.SQL.Text := '';
   dtmServidor.qryGeral2.SQL.Text := ' select nome_cidade '+
                                    ' from cidades  '+
                                    ' where cod_cidade = '+sCodCidade;
   dtmServidor.qryGeral2.Active := True;

   sCidade := dtmServidor.qryGeral2.FieldByName('nome_cidade').AsString+', '+sCidade;

   if (sCodCidadeLar <> '') then
   begin
      if dtmServidor.qryGeral.FieldByName('ind_telas').AsString = '1' then
      begin
         sTelas := 'Sim';
      end
      else
      begin
         sTelas := 'Não';
      end;

      if dtmServidor.qryGeral.FieldByName('tipo_animal').AsString = '1' then
      begin
         sTipoAnimal := 'Cachorro';
      end
      else
      if dtmServidor.qryGeral.FieldByName('tipo_animal').AsString = '2' then
      begin
         sTipoAnimal := 'Gato';
      end
      else
      begin
         sTipoAnimal := 'Ambos';
      end;

      sTelefoneLar := dtmServidor.qryGeral.FieldByName('telefone_Lar').AsString;
      sEnderecoLar := dtmServidor.qryGeral.FieldByName('Des_Endereco_Lar').AsString+', '+dtmServidor.qryGeral.FieldByName('Des_Bairro_Lar').AsString;
      sCidadeLar := dtmServidor.qryGeral.FieldByName('uf_lar').AsString;

      dtmServidor.qryGeral2.Active := False;
      dtmServidor.qryGeral2.SQL.Text := '';
      dtmServidor.qryGeral2.SQL.Text := ' select nome_cidade '+
                                        ' from cidades  '+
                                        ' where cod_cidade = '+sCodCidadeLar;
      dtmServidor.qryGeral2.Active := True;

      sCidadeLar := dtmServidor.qryGeral2.FieldByName('nome_cidade').AsString+', '+sCidadeLar;
   end
   else
   begin
      sTelefoneLar := 'Sem informações';
      sCidadeLar := 'Sem informações';
      sEnderecoLar := 'Sem informações';
      sTelas := 'Sem informações';
      sTipoAnimal := 'Sem informações';
   end;

   frmNotificacoes.BuscaInformacoesPerfil(sNomePessoa, sTelefone, sEndereco, sCidade, sTelefoneLar,
                                          sCidadeLar, sEnderecoLar, sTelas, sTipoAnimal);
   frmNotificacoes.lytOpaco.Visible := True;
   frmNotificacoes.lytPerfil.Visible := True;
end;

end.
