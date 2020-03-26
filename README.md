# reflex-aws-cloudwatch-logs-unencrypted
TODO: Write a brief description of your rule and what it does.

## Usage
To use this rule either add it to your `reflex.yaml` configuration file:  
```
rules:
  - reflex-aws-cloudwatch-logs-unencrypted:
      version: latest
```

or add it directly to your Terraform:  
```
...

module "reflex-aws-cloudwatch-logs-unencrypted" {
  source           = "github.com/cloudmitigator/reflex-aws-cloudwatch-logs-unencrypted"
}

...
```

## License
This Reflex rule is made available under the MPL 2.0 license. For more information view the [LICENSE](https://github.com/cloudmitigator/reflex-aws-cloudwatch-logs-unencrypted/blob/master/LICENSE) 