namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - hostname: 10.0.46.32
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        publish: []
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${hostname}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 444
        y: 243
      get_file:
        x: 442
        y: 402
      remote_secure_copy:
        x: 619
        y: 407
        navigate:
          9fc43153-4de3-d70c-b371-8f97a1fab563:
            targetId: e6cba3cb-3817-18e1-96a2-a09623b57eda
            port: SUCCESS
    results:
      SUCCESS:
        e6cba3cb-3817-18e1-96a2-a09623b57eda:
          x: 623
          y: 235
