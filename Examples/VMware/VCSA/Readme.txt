Automated Deployment of VMware VCSA 6.5
# FQDN Required Prior

1. Copy VCSA media to C:\VCSA
2. Edit the VCSA-Internal.json file
3. Copy the JSON file to C:\VCSA\vcsa-cli-installer
4. Add A Record with PTR for the VCSA FQDN name. I'm using vcsa.ctxlab.local on 192.168.1.200
5. Open CMD prompt
6. CD C:\VCSA\vcsa-cli-installer\win32
7. vcsa-deploy.exe install --no-esx-ssl-verify --accept-eula --acknowledge-ceip C:\VCSA\vcsa-cli-installer\VCSA-Internal-65.json

Automated Deployment of VMware VCSA 6.7
# FQDN Required After Pre-Check but before Reboot

1. Copy VCSA media to C:\VCSA
2. Edit the VCSA-Internal.json file
3. Copy the JSON file to C:\VCSA\vcsa-cli-installer
4. Open CMD prompt
5. CD C:\VCSA\vcsa-cli-installer\win32
6. vcsa-deploy.exe install --no-ssl-certificate-verification --accept-eula --acknowledge-ceip C:\VCSA\vcsa-cli-installer\VCSA-Internal-67.json
7. After ping test - Add A Record with PTR for the VCSA FQDN name. I'm using vcsa.ctxlab.local on 192.168.1.200
