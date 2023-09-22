# Turn T-Mobile 5G Wifi On/Off

## Prerequisites
Script is for linux, must be connected via ethernet

jq must be installed

```sudo apt install jq```

## Usage
clone repo

cp ```.env.sample``` to ```.env```

change settings in ```.env``` file

run tmobile_wifi_onoff.sh with:

```./tmobile_wifi_onoff.sh <option>```

## Options
on, off, current

```on``` turns the radio on

```off``` turns the radio off

```current``` gets the current settings

```./tmobile_wifi_onoff.sh off```

## Notes
- When turning on/off, the script takes quite awhile (1-2 mins) because the device is rebooting

- This will turn the radio on/off for both 5ghz and 2.4ghz
