object MqmSrvLoad_Service: TMqmSrvLoad_Service
  OldCreateOrder = False
  Dependencies = <
    item
      Name = 'IBG_gds_db'
      IsGroup = False
    end
    item
      Name = 'IBS_gds_db'
      IsGroup = False
    end>
  DisplayName = 'MqmService'
  Interactive = True
  OnExecute = ServiceExecute
  Height = 150
  Width = 215
end
