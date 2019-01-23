namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - hostname: 10.0.46.32
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
            - second_string: ''
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - hostname: '${hostname}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - hostname: '${hostname}'
            - username: '${username}'
            - password: '${password}'
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${hostname}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_file
          - FAILURE: delete_file
    - delete_file:
        do:
          Integrations.demo.aos.tools.delete_file:
            - hostname: '${hostname}'
            - username: '${username}'
            - password: '${password}'
            - filename: '${script_name}'
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${command_return_code}'
            - second_string: '0'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 493
        y: 59
      copy_artifact:
        x: 251
        y: 243
      copy_script:
        x: 635
        y: 252
      execute_script:
        x: 238
        y: 436
      delete_file:
        x: 592
        y: 449
      has_failed:
        x: 740
        y: 449
        navigate:
          d16d2e52-30db-07ca-51ac-358a9735fae9:
            targetId: 3a5c4f87-d918-d09a-75b8-e81c8d775d9d
            port: SUCCESS
          582828c1-5dd9-7f42-c0a1-ad07a8ab0e24:
            targetId: ecc1a1b9-f1ec-dee2-87fe-da27ec9e3fb0
            port: FAILURE
    results:
      FAILURE:
        ecc1a1b9-f1ec-dee2-87fe-da27ec9e3fb0:
          x: 841
          y: 534
      SUCCESS:
        3a5c4f87-d918-d09a-75b8-e81c8d775d9d:
          x: 818
          y: 316
