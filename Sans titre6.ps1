{
  "$schema": "schema.json",
  "actions": [
      {
        "verb": "setSiteLogo",
        "url": "https://contoso.sharepoint.com/SiteAssets/company-logo.png"
      }
  ]
}

Get-Content 'c:\scripts\site-script.json' -Raw | Add-SPOSiteScript -Title "Customer logo" -Description "Applies customer logo for customer sites"

$script = @'
>> {
>>     "$schema": "schema.json",
>>         "actions": [
>> {
>>    "verb": "setSiteExternalSharingCapability",
>>    "capability": "ExternalUserAndGuestSharing"
>> }
>>         ],
>>         "bindata": { },
>>         "version": 1
>> };
>> '@

Add-SPOSiteScript -Title "External User and Guest Sharing site script" -Description "A site script to manage the
guest access of a site" -Content $script

Id          : ea9e3a52-7c12-4da8-a901-4912be8a76bc
Title       : External User and Guest Sharing site script
Description : A site script to manage theguest access of a site
Content     :
Version     : 0

Add-SPOSiteDesign -Title "Communication Site with External Users and Guest Sharing" -WebTemplate "68" -SiteScripts "ea9e3a52-7c12-4da8-a901-4912be8a76bc"