# Make the dir + add the API Key:

```
mkdir -p /path/to/secrets
```
```
nano /path/to/secrets/.cloudflare.ini
```
- ADD:  dns_cloudflare_api_token = YOUR_API_TOKEN_HERE
- CRTL + O to save
- CTRL + X to exit nano
```
chmod 600 /path/to/secrets/.cloudflare.ini
```
```
chown ur_username:ur_username /path/to/secrets/.cloudflare.ini
```
