# AWS Top 10 Mod for Steampipe

The AWS Top 10 mod provides curated sets of benchmarks and controls for security, cost, operations, and more.

Run checks in a dashboard:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-aws-top-10/main/docs/aws-top-10-dashboard-benchmark.png)

Or in a terminal:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-aws-top-10/main/docs/aws-top-10-terminal.png)

Includes support for:
- [Top 10 security items to improve in your AWS account](https://aws.amazon.com/blogs/security/top-10-security-items-to-improve-in-your-aws-account/)

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the AWS plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install aws
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-aws-top-10.git
cd steampipe-mod-aws-top-10
```

Install mod dependencies:

```sh
steampipe mod install
```

### Usage

Before running any benchmarks, it's recommended to generate your AWS credential report:

```sh
aws iam generate-credential-report
```

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at http://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all benchmarks:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.account_security
```

Run a benchmark for a specific item:

```sh
steampipe check benchmark.account_security_accurate_account_info
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

This mod uses the credentials configured in the [Steampipe AWS plugin](https://hub.steampipe.io/plugins/turbot/aws).

### Configuration

No extra configuration is required.

### Common Dimensions

The benchmark queries use common properties (like `account_id`, `connection_name` and `region`) and tags that are defined in the dependent [AWS Compliance mod](https://github.com/turbot/steampipe-mod-aws-compliance) and [AWS Perimeter mod](https://github.com/turbot/steampipe-mod-aws-perimeter) . These properties can be executed in the following ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:

  ```shell
  steampipe check benchmark.account_security_limit_security_groups --var 'common_dimensions=["account_id", "connection_name", "region"]'
  ```

  ```shell
  steampipe check benchmark.account_security_limit_security_groups --var 'tag_dimensions=["Environment", "Owner"]'
  ```

- Set an environment variable:

  ```shell
  SP_VAR_common_dimensions='["account_id", "connection_name", "region"]' steampipe check benchmark.account_security_limit_security_groups
  ```

  ```shell
  SP_VAR_tag_dimensions='["Environment", "Owner"]' steampipe check benchmark.account_security_limit_security_groups
  ```

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join #steampipe on Slack →](https://turbot.com/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-aws-top-10/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the a`help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [AWS Top 10 Mod](https://github.com/turbot/steampipe-mod-aws-top-10/labels/help%20wanted)
