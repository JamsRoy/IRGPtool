
function FindProxyForURL(url, host) {
  if (isPlainHostName(host) || shExpMatch(host, "*.local")) return "DIRECT";
  var m365Allowed = ["outlook.office.com","login.microsoftonline.com"];
  for (var i=0;i<m365Allowed.length;i++){
    if (dnsDomainIs(host, m365Allowed[i]) || shExpMatch(host, m365Allowed[i])) return "DIRECT";
  }
  return "PROXY 127.0.0.1:9";
}
