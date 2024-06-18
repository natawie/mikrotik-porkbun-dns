## ---- Configuration/Start  -----

# Porkbun API access keys (from https://porkbun.com/account/api)
:local PorkbunAPIKey "__YOUR_API_KEY__"
:local PorkbunAPISecret "__YOUR_API_SECRET__"
# Porkbun domain name
:local PorkbunDomain "__YOUR_DOMAIN_NAME__"
:local PorkbunSubdomain "__YOUR_SUBDOMAIN__"

# DNS record TTL
:local RecordTTL 60

# if [false] it will only monitor/log WAN IP changes, if [true] it will enable DNS updates
:local UpdateDNS true;

# install DigiCert-Root-CA on your board if you want to enable "check-certificate"
:local CheckCertificate false;

## ---- Configuration/End  ----

:global WanIPv4Current
:do {
    :local result [:tool fetch url="http://checkip.amazonaws.com/" as-value output=user]
    :if ($result->"status" = "finished") do={
        :local WanIPv4New [:pick ($result->"data") 0 ( [ :len ($result->"data") ] -1 )]
        :if ($WanIPv4New != $WanIPv4Current) do={
            :if ([ :len ($WanIPv4New) ] > 4) do={
                # wan ip changed (result not empty and != stored ip)
                :log warning "[Porkbun DNS Update] WAN IP change detected - New IP: $WanIPv4New - Old IP: $WanIPv4Current";
                # if not in "Monitor Only" state -> update DNS
                :if ($UpdateDNS = true) do={
                    # request URL
                    :local url "https://api.porkbun.com/api/json/v3/dns/editByNameType/$PorkbunDomain/A/$PorkbunSubdomain"
                    # evaluating "check-certificate" (yes/no)
                    :local CheckYesNo
                    :if ($CheckCertificate = true) do={ :set CheckYesNo "yes"; } else { :set CheckYesNo "no"; }
                    # updating the DNS Record
                    :local cfapi [/tool fetch http-method=post mode=https url=$url check-certificate=$CheckYesNo output=user as-value \
                    http-data="{\"apikey\":\"$PorkbunAPIKey\",\"secretapikey\":\"$PorkbunAPISecret\",\"content\":\"$WanIPv4New\",\"ttl\":\"$RecordTTL\"}"]
                    # log message
                    :log warning "[Porkbun DNS Update] Updated DNS record [ $PorkbunSubdomain.$PorkbunDomain -> $WanIPv4New ]";
                }
                # update stored global variable
                :set WanIPv4Current $WanIPv4New
            }
        }
    }
} on-error={
    :log error "[Porkbun DNS Update] Error retrieving current WAN IP or updating DNS record";
}
