# Nutanix-WebhookToPowerShell
Proxy service which listens Nutanix [event notifications](https://portal.nutanix.com/#/page/docs/details?targetId=AHV-Admin-Guide-v51:ahv-webhooks-event-notifications-c.html) and send them to PowerShell scripts.

It can be used to implement realtime integrations e.g. update CMDB always when virtal machines are updated or migrated between hypervisor hosts.

# How it works
ASP.NET Code implements web server which listens POST requests coming from Nutanix Prism Elements and send those to script **WebhookToPowerShell\ProcessWebhooks.ps1**

ProcessWebhooks.ps1 converts JSON payload to PowerShell objects and send that to event type specific script.
Event type specific example scripts will currently only info messages to log file but those can be easily enhanced to do what ever you want.

Example log:
```
2019-04-08 12:29:17Z - New virtual machine "example" was created
2019-04-08 12:29:19Z - Virtual machine "example" was updated
2019-04-08 12:29:21Z - Virtual machine "example" was updated
2019-04-08 12:30:30Z - Virtual machine "example" was powered on in host "10.10.10.101"
2019-04-08 12:31:21Z - Virtual machine "example" was migrated to host "10.10.10.102"
2019-04-08 12:31:47Z - Virtual machine "example" was powered off
2019-04-08 12:32:16Z - Virtual machine "example" was deleted
```

Example content of JSON payload coming from Nutanix:
```json
{
	"entity_reference": {
		"kind": "vm",
		"uuid": "addfa04e-751f-456d-b35b-4550238a7389"
	},
	"data": {
		"metadata": {
			"status": {
				"state": "COMPLETE",
				"name": "example",
				"resources": {
					"num_threads_per_core": 1,
					"vnuma_config": {
						"num_vnuma_nodes": 0
					},
					"host_reference": {
						"kind": "host",
						"uuid": "041ceddb-ad28-4fa2-88ee-9236c2378366",
						"name": "10.10.10.101"
					},
					"serial_port_list": [],
					"nic_list": [
						{
							"nic_type": "NORMAL_NIC",
							"uuid": "e45016a1-a216-47ba-87db-422aed4d41d7",
							"ip_endpoint_list": [
								{
									"ip": "1.2.3.4",
									"type": "ASSIGNED"
								}
							],
							"mac_address": "50:6b:8d:6c:a1:3a",
							"subnet_reference": {
								"kind": "subnet",
								"name": "ExampleNetwork",
								"uuid": "b2751567-8165-4781-9020-be9821b593c3"
							},
							"is_connected": true
						}
					],
					"hypervisor_type": "AHV",
					"num_vcpus_per_socket": 2,
					"num_sockets": 2,
					"gpu_list": [],
					"memory_size_mib": 4096,
					"power_state": "ON",
					"hardware_clock_timezone": "Europe/Helsinki",
					"power_state_mechanism": {
						"guest_transition_config": {}
					},
					"vga_console_enabled": true,
					"disk_list": [
						{
							"data_source_reference": {
								"kind": "image",
								"uuid": "34aef9fe-5281-42f6-b819-a75a633fc7e7"
							},
							"device_properties": {
								"disk_address": {
									"device_index": 0,
									"adapter_type": "IDE"
								},
								"device_type": "CDROM"
							},
							"uuid": "161afc29-f2d8-4786-a867-6534bd0ce240",
							"disk_size_bytes": 4843016192,
							"disk_size_mib": 4619
						},
						{
							"device_properties": {
								"disk_address": {
									"device_index": 0,
									"adapter_type": "SCSI"
								},
								"device_type": "DISK"
							},
							"uuid": "2609cdcf-8836-432a-ae56-76f63c48083e",
							"disk_size_bytes": 42949672960,
							"disk_size_mib": 40960
						}
					]
				},
				"cluster_reference": {
					"kind": "cluster",
					"name": "ntnx-ahv-cluster",
					"uuid": "00057f6b-7d3b-efcc-0000-000000025225"
				}
			},
			"spec": {
				"name": "example",
				"resources": {
					"num_threads_per_core": 1,
					"vnuma_config": {
						"num_vnuma_nodes": 0
					},
					"serial_port_list": [],
					"nic_list": [
						{
							"nic_type": "NORMAL_NIC",
							"uuid": "e45016a1-a216-47ba-87db-422aed4d41d7",
							"ip_endpoint_list": [
								{
									"ip": "1.2.3.4",
									"type": "ASSIGNED"
								}
							],
							"mac_address": "50:6b:8d:6c:a1:3a",
							"subnet_reference": {
								"kind": "subnet",
								"name": "ExampleNetwork",
								"uuid": "b2751567-8165-4781-9020-be9821b593c3"
							},
							"is_connected": true
						}
					],
					"num_vcpus_per_socket": 2,
					"num_sockets": 2,
					"gpu_list": [],
					"memory_size_mib": 4096,
					"power_state": "ON",
					"hardware_clock_timezone": "Europe/Helsinki",
					"power_state_mechanism": {},
					"vga_console_enabled": true,
					"disk_list": [
						{
							"data_source_reference": {
								"kind": "image",
								"uuid": "34aef9fe-5281-42f6-b819-a75a633fc7e7"
							},
							"device_properties": {
								"disk_address": {
									"device_index": 0,
									"adapter_type": "IDE"
								},
								"device_type": "CDROM"
							},
							"uuid": "161afc29-f2d8-4786-a867-6534bd0ce240",
							"disk_size_bytes": 4843016192,
							"disk_size_mib": 4619
						},
						{
							"device_properties": {
								"disk_address": {
									"device_index": 0,
									"adapter_type": "SCSI"
								},
								"device_type": "DISK"
							},
							"uuid": "2609cdcf-8836-432a-ae56-76f63c48083e",
							"disk_size_bytes": 42949672960,
							"disk_size_mib": 40960
						}
					]
				},
				"cluster_reference": {
					"kind": "cluster",
					"name": "ntnx-ahv-cluster",
					"uuid": "00057f6b-7d3b-efcc-0000-000000025225"
				}
			},
			"api_version": "3.1",
			"metadata": {
				"last_update_time": "2019-04-08T06:29:45Z",
				"kind": "vm",
				"uuid": "addfa04e-751f-456d-b35b-4550238a7389",
				"creation_time": "2019-04-08T06:28:42Z",
				"spec_version": 1,
				"categories": {}
			}
		}
	},
	"version": "1.0",
	"event_type": "VM.ON"
}
``` 

# Usage
## Build
Build Docker image (pre-build image is also available which you can use for testing purposes).
```bash
docker build . -t ollijanatuinen/nutanix-webhook2pwsh
```

## Deploy
Create Docker service
```bash
mkdir /data/nutanix-webhook2pwsh

docker service create \
    --name nutanix-webhook2pwsh \
    --mount type=bind,source=/data/nutanix-webhook2pwsh,target=/logs \
    -p 5000:5000 \
    ollijanatuinen/nutanix-webhook2pwsh
```

Establish connection to Nutanix Prism Elements
```powershell
# Settings
$NutanixPrismElementsUrl = "https://1.2.3.4:9440"
$Username = "admin"
$Password = "pwd"
$Webhook2PwshUrl = "http://dockerhost:5000"

#####################################################
# Use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Disable certificate check
Add-Type -TypeDefinition @"
	using System.Net;
	using System.Security.Cryptography.X509Certificates;
	public class TrustAllCertsPolicy : ICertificatePolicy {
		public bool CheckValidationResult(
				ServicePoint srvPoint, X509Certificate certificate,
				WebRequest request, int certificateProblem) {
			return true;
		}
	}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$AuthorizationBytes = [System.Text.Encoding]::UTF8.GetBytes($Username + ":" + $Password)
$AuthorizationBase64 = [System.Convert]::ToBase64String($AuthorizationBytes)
$NutanixAuthenticationHeaders = @{ Authorization = "Basic $AuthorizationBase64" }
```

Create enable webhook
```powershell
$Metadata = New-Object -TypeName PSObject -Property @{
	"kind" = "webhook"
}
$Credentials = New-Object -TypeName PSObject -Property @{
}
$Resources = New-Object -TypeName PSObject -Property @{
	"post_url" = $Webhook2PwshUrl
	"credentials" = $Credentials
	"events_filter_list" = @(
		"VM.CREATE",
		"VM.DELETE",
		"VM.UPDATE",
		"VM.ON",
		"VM.OFF",
		"VM.MIGRATE"
	)
}
$Spec = New-Object -TypeName PSObject -Property @{
	"name" = "WebhookToPowerShell"
	"resources" = $Resources
	"description" = "Send webhooks to PowerShell"
}
$Item = New-Object -TypeName PSObject -Property @{
	"metadata" = $Metadata
	"spec" = $Spec
	"api_version" = "3.0"
}
$Body = $Item | ConvertTo-Json -Depth 3 -Compress
$Webhook = Invoke-RestMethod -UseBasicParsing -Uri "$NutanixPrismElementsUrl/api/nutanix/v3/webhooks" -Headers $NutanixAuthenticationHeaders  -Method POST -Body $Body -ContentType "application/json"

```

Delete webhook
```powershell
$Webhooks = Invoke-RestMethod -UseBasicParsing -Uri "$NutanixPrismElementsUrl/api/nutanix/v3/webhooks/list" -Headers $NutanixAuthenticationHeaders  -Method POST -Body "{}" -ContentType "application/json"
$Webhook = $Webhooks.entities | Where-Object {$_.spec.name -eq "WebhookToPowerShell"}

Invoke-RestMethod -UseBasicParsing -Uri "$NutanixPrismElementsUrl/api/nutanix/v3/webhooks/$($Webhook.metadata.uuid)" -Headers $NutanixAuthenticationHeaders  -Method DELETE
```