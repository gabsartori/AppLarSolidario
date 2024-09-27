object dtmServidor: TdtmServidor
  OnCreate = DataModuleCreate
  Height = 242
  Width = 272
  object fdConexao: TFDConnection
    Params.Strings = (
      'DriverID=sQLite')
    LoginPrompt = False
    AfterConnect = fdConexaoAfterConnect
    Left = 32
    Top = 24
  end
  object qryGeral: TFDQuery
    Connection = fdConexao
    Left = 136
    Top = 32
  end
end
