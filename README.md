# AWS AMI Resource

Concourse resource to create AWS AMI's using [Hashicorp Packer](https://www.packer.io/intro/)

https://hub.docker.com/r/aequitas/aws-ami-resource/

## Source Configuration

Currently there is no source configuration required. AWS credentials can be provider using [IAM roles](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html).

## Behavior

### `out`: Build AMI from template

Performs a `packer build` using specified template and build variables. Template should specify a `amazon-ebs` type builder. Exports AMI ID and region as version and files (file names: `id` and `region`).

#### Parameters

* `template_path`: *Required.* Path to the packer template file.

* `build_vars`: *Optional.* Build vars passed to packer build, specified as key/value pairs.

* `build_vars_from_file`: *Optional.* Build vars passed to packer build. Instead of specifying the value the path to a file is specified from which value should be read. For example, to pass in another AWS AMI resource as the `source_ami`.

### `in`: Fetch AMI details to file

Uses AWS CLI to verify specified AMI id/region exists and writes `id` and `region` files.

#### Parameters

None right now.

## Examples

Example template might look like this:

```json
{
    "variables": {
        "role": "{{env `role`}}",
    },
    "builders": [
        {
            "type": "amazon-ebs",
            "ami_name": "new-ami",
            "source_ami": "ami-12345678",
            "ssh_username": "ec2-user",
        }
    ],
    "provisioners": [
        {
            "type": "shell",
            "inline": [
                "echo hello world"
            ]
        }
    ]
}
````

Concourse config

```yaml
resource_types:
    - name: aws-ami
      type: docker-image
      source:
        repository: aequitas/aws-ami-resource

resources:
  - name: ami:integrationtest
    type: aws-ami

jobs:
  - name: build-ami
    plan:
      - get: src
      - put: ami:test
        params:
          template_path: src/packer_template.json
          build_vars:
            role: test
````
