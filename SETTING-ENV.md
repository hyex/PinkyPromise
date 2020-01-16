# CocoaPods
> 서치해보니 깃에 올리면 라이브러리 버전충돌로 애를 먹는다고함... 각자의 pc에서 설치해야합니다.

#### Required Library
+ Calendar Framework
<br/>

## [# 초기 세팅]()

### Installation
```
$ sudo gem install cocoapods
```

### Initial Setting
```
$ cd `ProjectPath`
$ pod init
```

### Update Podfile
```
target 'PinkyPromise' do
    // Calendar Library 아래 라인 추가
    pod 'FSCalendar'
end
```

### Install
```
$ pod install
```

### Run
`project name`.xcworkspace 파일 실행

<br/>

## [# Podfile Update]()
> 이미 위의 세팅이 되어있을때 Podfile 변경 하고 아래 명령어 수행
### update
```
$ pod update
```

<br/>

## [# Reference]()
+ [cocoapods-tips](https://github.com/ClintJang/cocoapods-tips/blob/master/README.md)
