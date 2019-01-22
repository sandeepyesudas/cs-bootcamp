namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - hostname: 10.0.46.32
    - username: root
    - password: admin@123
    - filename: install_java.sh
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${hostname}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      ssh_command:
        x: 364
        y: 268
        navigate:
          893e8f5b-4732-fbbe-2c6c-347b5c11feb6:
            targetId: a9de3519-e75f-1706-3c31-6059683d1a69
            port: SUCCESS
    results:
      SUCCESS:
        a9de3519-e75f-1706-3c31-6059683d1a69:
          x: 611
          y: 253
