# Chirpy Starter

[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)][gem]&nbsp;
[![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

A minimal, ready-to-use template for creating a blog with the [**Chirpy**][chirpy] Jekyll theme. Get up and running in minutes with all critical files pre-configured.

## Why This Starter Exists

When installing Chirpy through [RubyGems.org][gem], Jekyll can only read a subset of theme files (`_data`, `_layouts`, `_includes`, `_sass`, `assets`) and limited `_config.yml` options from the gem. As a result, users cannot enjoy the full out-of-the-box experience that Chirpy offers.

To unlock all features, the following files must be present in your Jekyll site:

```shell
.
├── _config.yml
├── _plugins
├── _tabs
└── index.html
```

This starter bundles those files from the latest **Chirpy** release along with a [CD][CD] workflow, so you can start writing immediately.

## Usage

Check out the [theme's docs](https://github.com/cotes2020/jekyll-theme-chirpy/wiki).

## Contributing

This repository is automatically updated with new releases from the theme repository. If you encounter any issues or want to contribute to its improvement, please visit the [theme repository][chirpy] to provide feedback.

## License

This work is published under [MIT][mit] License.

[gem]: https://rubygems.org/gems/jekyll-theme-chirpy
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[CD]: https://en.wikipedia.org/wiki/Continuous_deployment
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE

## 로컬 실행
`bundle exec jekyll serve`

## Docker 실행

### 1) 빌드 + 실행
```powershell
docker compose up --build
```

기본 실행은 `tools/init`을 실행하지 않으므로, 커밋되지 않은 변경사항이 있어도 로컬 렌더링 테스트가 가능하다.

### 2) 백그라운드 실행
```powershell
docker compose up --build -d
```

### 3) 종료
```powershell
docker compose down
```

### 4) 접속 주소
`http://localhost:4000/satinbower/`

### 5) init이 필요할 때만 1회 실행
```powershell
docker compose run --rm -e RUN_INIT=1 blog
```

## 더보기 적용

태그 위아래로 한 줄씩 띄고 쓰기

```html
<details markdown="1">

    ...

</details>
```

## 머메이드 차트 작성

```html
<div class="mermaid">
    flowchart ...
</div>
```