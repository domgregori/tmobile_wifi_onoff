source ./.env
if [ $# -eq 0 ]
  then
	  echo "Valid options are (on, off, hide, show, current)"
    echo ""
    echo "on:       turns on radios"
    echo "off:      turns off radios"
    echo "hide:     ssid hidden"
    echo "show:     broadcasts ssid"
    echo "current:  shows current config"
	  exit
fi

function currentConfig {
	config=$(curl -s http://${TMOBILE_IP}:8080/TMI/v1/network/configuration/v2\?get\=ap -H "Authorization: Bearer ${token}")
}

token=$(curl -s -X POST http://${TMOBILE_IP}:8080/TMI/v1/auth/login -d "{\"pin\": 0, \"username\": \"admin\", \"password\": \"${TMOBILE_ADMIN_PASSWORD}\" }" | jq -r .auth.token)

currentConfig

case "$1" in
	"on" )
		onConfig=$(echo ${config} | jq -r '.[].isRadioEnabled = true')
		curl -d "$onConfig" http://${TMOBILE_IP}:8080/TMI/v1/network/configuration/v2\?set\=ap -H "Authorization: Bearer ${token}"
		currentConfig
		echo $config | jq;;

	"off" )
		offConfig=$(echo ${config} | jq -r '.[].isRadioEnabled = false')
		curl -d "$offConfig" http://${TMOBILE_IP}:8080/TMI/v1/network/configuration/v2\?set\=ap -H "Authorization: Bearer ${token}"
		currentConfig
		echo $config | jq;;

	"hide" )
		offConfig=$(echo ${config} | jq -r '.[].ssid.isBroadcastEnabled = false')
		curl -d "$offConfig" http://${TMOBILE_IP}:8080/TMI/v1/network/configuration/v2\?set\=ap -H "Authorization: Bearer ${token}"
		currentConfig
		echo $config | jq;;

	"show" )
		offConfig=$(echo ${config} | jq -r '.[].ssid.isBroadcastEnabled = true')
		curl -d "$offConfig" http://${TMOBILE_IP}:8080/TMI/v1/network/configuration/v2\?set\=ap -H "Authorization: Bearer ${token}"
		currentConfig
		echo $config | jq;;

	"current" )
		echo "$config" | jq
esac
