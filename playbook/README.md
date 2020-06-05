<h1 align="center"> 👋 [AWX] Terraform을 A to Z까지 구성해보자~!  </h1>
<p>
  <a href="https://sed-gitlab.hanpda.com/jhjeong/test/blob/master/README.md">
    <img src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
  </a>
  <a href="https://sed-gitlab.hanpda.com/jhjeong/test/blob/master/README.md">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" target="_blank" />
  </a>
  <a href="https://github.com/kefranabg/readme-md-generator/graphs/commit-activity">
    <img alt="Maintenance" src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" target="_blank" />
  </a>
</p>


## 개요
> ㅁ Terraform을 마이크로 단위의 AWS 리소스를 AWX를 활용하여 Workflow로 구성하여 자동화하는 것을 목표로 합니다.

## 디렉토리 구조
```sh
./playbook/
├── README.md
├── site.yaml
├── hosts
├── alb
│   ├── defaults
│   ├── handlers
│   ├── meta
│   ├── tasks
│   ├── tests
│   └── vars
├── asg
│   ├── defaults
│   ├── handlers
│   ├── meta
│   ├── tasks
│   ├── tests
│   └── vars
├── aurora
│   ├── defaults
│   ├── handlers
│   ├── meta
│   ├── tasks
│   ├── tests
│   └── vars
├── bastion
│   ├── defaults
│   ├── handlers
│   ├── meta
│   ├── tasks
│   ├── tests
│   └── vars
├── cloudfront
│   ├── defaults
│   ├── handlers
│   ├── meta
│   ├── tasks
│   ├── tests
│   └── vars
├── route53
│   ├── defaults
│   ├── handlers
│   ├── meta
│   ├── tasks
│   ├── tests
│   └── vars
├── s3
│   ├── defaults
│   ├── handlers
│   ├── meta
│   ├── tasks
│   ├── tests
│   └── vars
├── slack
│   ├── defaults
│   ├── handlers
│   ├── meta
│   ├── tasks
│   ├── tests
│   └── vars
└── vpc
    ├── defaults
    ├── handlers
    ├── meta
    ├── tasks
    ├── tests
    └── vars
```

## 작성자
👤 **Jaehwan Jeong**

***
