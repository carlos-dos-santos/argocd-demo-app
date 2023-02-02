#!/usr/bin/bash

#kubectl apply -f - << EOF
#apiVersion: v1
#kind: ConfigMap
#metadata:
#  name: argocd-notifications-cm
#data:
#  trigger.on-sync-succeeded: |
#    - when: app.status.operationState.phase in ['Succeeded']
#      send: [app-sync-succeeded]
#
#  template.app-sync-succeeded: |
#    email:
#      subject: Application {{.app.metadata.name}} has been successfully synced.
#    message: |
#      {{if eq .serviceType "slack"}}:white_check_mark:{{end}} Application {{.app.metadata.name}} has been successfully synced at {{.app.status.operationState.finishedAt}}.
#      Sync operation details are available at: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true .
#EOF

#kubectl replace -f - << EOF
#apiVersion: v1
#kind: ConfigMap
#metadata:
#  name: argocd-notifications-cm
#data:
#  service.teams: |
#    recipientUrls:
#      channelName: \$channel-teams-url
#
#  trigger.on-sync-succeeded: |
#    - when: true
#      send: [app-sync-succeeded]
#
#  template.app-sync-succeeded: |
#    teams:
#      facts: |
#        [{
#          "name": "Sync Status",
#          "value": "{{.app.status.sync.status}}"
#        },
#        {
#          "name": "Repository",
#          "value": "{{.app.spec.source.repoURL}}"
#        }]
#EOF


  #template.app-sync-succeeded: |
  #  teams:
  #    facts: |
  #      [{
  #        "name": "Sync Status",
  #        "value": "{{.app.status.sync.status}}"
  #      },
  #      {
  #        "name": "Repository",
  #        "value": "{{.app.spec.source.repoURL}}"
  #      }]
  #
  

#kubectl replace -f - << EOF
#apiVersion: v1
#kind: ConfigMap
#metadata:
#  creationTimestamp: null
#  name: argocd-notifications-cm
#data:
#  service.teams: |
#    recipientUrls:
#      channelName: \$channel-teams-url
#
#  trigger.sync-succeeded: |
#    - description: Application syncing ...
#      when: app.status.operationState.phase == 'Succeeded'
#      send:
#      - app-sync-succeeded
#
#  template.app-sync-succeeded: |
#    teams:
#      themeColor: "#000000"
#      title: Application {{.app.metadata.name}} synced
#      text: Application {{.app.metadata.name}} sync has succeeded at {{.app.status.operationState.finishedAt}}.
#      summary: "{{.app.metadata.name}} synced"
#EOF
#

kubectl replace -f - << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: argocd-notifications-cm
data:
  service.teams: |
    recipientUrls:
      channelName: \$channel-teams-url

  trigger.on-sync-succeeded: |
    - description: Application syncing has succeeded
      send:
      - app-sync-succeeded
      when: app.status.operationState.phase == 'Succeeded'
  template.app-sync-succeeded: |
    teams:
      themeColor: "#000080"
      sections: |
        [{
          "facts": [
            {
              "name": "Sync Status",
              "value": "{{.app.status.sync.status}}"
            },
            {
              "name": "Repository",
              "value": "{{.app.spec.source.repoURL}}"
            }
          ]
        }]
      potentialAction: |
        [{
          "@type":"OpenUri",
          "name":"Operation Details",
          "targets":[{
            "os":"default",
            "uri":"{{.context.argocdUrl}}/applications/{{.app.metadata.name}}?operation=true"
          }]
        }]
      title: Application {{.app.metadata.name}} has been successfully synced
      text: Application {{.app.metadata.name}} has been successfully synced at {{.app.status.operationState.finishedAt}}.
      summary: "{{.app.metadata.name}} sync succeeded"
EOF
