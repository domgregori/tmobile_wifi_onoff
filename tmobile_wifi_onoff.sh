source .env
if [ $# -eq 0 ]
  then
	  echo "Valid options are (on, off, current)"
	  exit
fi

function currentConfig {
	config=$(curl -s http://${TMOBILE_IP}//TMI/v1/network/configuration\?get\=ap -H "Authorization: Bearer ${token}")
}

token=$(curl -s -X POST http://${TMOBILE_IP}/TMI/v1/auth/login -d "{\"username\": \"admin\", \"password\": \"${TMOBILE_ADMIN_PASSWORD}\" }" | jq -r .auth.token)

currentConfig

case "$1" in
	"on" )
		onConfig=$(echo ${config} | jq -r '.[].isRadioEnabled = true')
		curl -d "$onConfig" http://${TMOBILE_IP}/TMI/v1/network/configuration\?set\=ap -H "Authorization: Bearer ${token}"
		currentConfig
		echo $config | jq;;

	"off" )
		offConfig=$(echo ${config} | jq -r '.[].isRadioEnabled = false')
		curl -d "$offConfig" http://${TMOBILE_IP}/TMI/v1/network/configuration\?set\=ap -H "Authorization: Bearer ${token}"
		currentConfig
		echo $config | jq;;

	"current" )
		echo "$config" | jq
esac
