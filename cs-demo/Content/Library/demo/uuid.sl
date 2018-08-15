namespace: cs_demo.content.library.demo

operation:
    name: uuid
    
    inputs:
        - input_1
        - input_2
    
    java_action:
        gav: 'group:artifact:version'
        class_name: uuid
        method_name: execute
        
    outputs:
        - output_1
        
    results:
        - SUCCESS: ${returnCode == '0'}
        - FAILURE

###################################################

namespace: io.cloudslang.demo

operation:
    name: uuid

    python_action:
        script: |
            import uuid
            uuid = str(uuid.uuid1())

    outputs:
        - uuid: ${uuid}

    results:
        - SUCCESS
        - FAILURE