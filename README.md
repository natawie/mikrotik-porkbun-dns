# Mikrotik Cloudflare DNS Updater Script (RouterOS v7)

This script is designed for [Mikrotik](https://mikrotik.com/) RouterOS v7 routers. It updates a Cloudflare DNS record whenever there’s a change in the router’s public IP address.

It’s important to note that Mikrotik RouterOS already includes an [IP Cloud DDNS](https://wiki.mikrotik.com/wiki/Manual:IP/Cloud#DDNS) feature.
This feature works efficiently and can be used to recursively update other records (using `CNAME`) that point to the dynamic DNS record generated by Mikrotik (for example `529c0491d41c.sn.mynetname.net`).

However, I needed a script that could log changes to the WAN-IP and, optionally, perform the Cloudflare DNS update as well.
This script is the result of that requirement.

## Setup

* `CFAPIAUTHEMAIL` - This is the email address associated with your Cloudflare account. It’s required for API authentication.
* `CFAPIDNSRCNAME` - This is the domain record (hostname) at Cloudflare that you wish to update. For instance, it could be something like `mywanip.domain.com`.
* `CFAPIDNSZONEID` - This is the Cloudflare DNS Zone ID. You can locate this in your Cloudflare dashboard.
* `CFAPIDNSRCRDID` - This is the Cloudflare DNS Record ID. More details on this are provided below.
* `CFAPIAUTHTOKEN` - This is the Cloudflare AuthKey/Token. You can find this in your Cloudflare dashboard.

### API Token

To create the “API TOKEN” (`CFAPIAUTHTOKEN`) in the Cloudflare dashboard, follow these steps:

1. Click on the profile icon located at the top right corner of the dashboard, then select ‘My Profile’.
2. Navigate to ‘API Tokens’, and click on ‘Create Token’.
3. Select ‘Start with a template’, then choose the ‘Edit zone DNS’ template.
4. Under ‘Zone Resources’, select your top-level domain name.
5. Proceed by clicking ‘Continue to summary’.
6. Finally, click ‘Create Token’ to generate your API token.

