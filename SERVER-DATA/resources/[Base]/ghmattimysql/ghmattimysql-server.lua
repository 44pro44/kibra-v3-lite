local function safeParameters(parameters)
  if parameters == nil then
    return {[''] = ''}
  end
  return parameters
end

exports("ready", function (callback)
  Citizen.CreateThread(function ()
      -- add some more error handling
      while GetResourceState('ghmattimysql') ~= 'started' do
          Citizen.Wait(0)
      end
      -- while not exports['mysql-async']:is_ready() do
      --     Citizen.Wait(0)
      -- end
      callback()
  end)
end)


exports('executeSync', function (query, parameters)
  local res = {}
  local finishedQuery = false
  exports.ghmattimysql:execute(query, safeParameters(parameters), function (result)
    res = result
    finishedQuery = true
  end, GetInvokingResource())
  repeat Citizen.Wait(0) until finishedQuery == true
  return res
end)

exports('scalarSync', function (query, parameters)
  local res = {}
  local finishedQuery = false
  exports.ghmattimysql:scalar(query, safeParameters(parameters), function (result)
    res = result
    finishedQuery = true
  end, GetInvokingResource())
  repeat Citizen.Wait(0) until finishedQuery == true
  return res
end)

exports('transactionSync', function (query, parameters)
  local res = {}
  local finishedTransaction = false
  exports.ghmattimysql:transaction(query, safeParameters(parameters), function (result)
    res = result
    finishedTransaction = true
  end, GetInvokingResource())
  repeat Citizen.Wait(0) until finishedTransaction == true
  return res
end)

exports('storeSync', function (query)
  local res = {}
  local finishedStore = false
  exports.ghmattimysql:store(query, function (result)
    res = result
    finishedStore = true
  end, GetInvokingResource())
  repeat Citizen.Wait(0) until finishedStore == true
  return res
end)
