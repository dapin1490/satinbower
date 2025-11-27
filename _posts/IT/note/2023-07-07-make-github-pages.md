---
title: "우분투에서 chirpy 테마 github pages 만들기"
author: dapin1490
date: 2023-07-07 15:41:00 +09:00
categories: [IT, note]
tags: [지식, IT]
render_with_liquid: false
---

<style>
  figure { text-align: center; }
</style>

### Table of Contents
- [Environment and Desktop](#environment-and-desktop)
- [사전 설치](#사전-설치)
- [깃허브 블로그 만들고 올리기](#깃허브-블로그-만들고-올리기)
- [깃허브 블로그의 특징](#깃허브-블로그의-특징)

## Environment and Desktop
* OS: Ubuntu 20.04 desktop
* Browser: Chrome 버전 114.0.5735.199(공식 빌드) (64비트)
* jekyll-theme-chirpy: v6.1.0

## 사전 설치
`*` 전체적인 과정은 Chirpy 테마 데모 블로그의 [Getting Started](https://chirpy.cotes.page/posts/getting-started/)를 따랐다.

Chirpy 테마는 새 블로그를 만드는 두 가지 방법을 제공하는데, 하나는 깃허브에 별도로 공개된 [chirpy-starter](https://github.com/cotes2020/chirpy-starter) 레포지토리를 포크/클론해서 만드는 것이고, 다른 하나는 데모 블로그를 구성한 [jekyll-theme-chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) 레포지토리를 포크/클론하는 것이다. 나는 이전에 스타터 레포지토리를 클론해서 사용하고 있었는데([legacy 블로그](https://dapin1490.github.io/satinbower-legacy/)), Chirpy 최신 릴리즈 버전(현재 시점에서 `v6.1.0`) 블로그 디자인이 마음에 들어서 새로 만들고 데이터를 옮기기로 했다. 그러니 후자의 방법으로 블로그를 만든다. 먼저 말하자면 그 결과물이 지금 이 블로그이다.

jekyll 테마를 이용해 블로그를 (정석대로) 만들려면 ruby가 먼저 필요하다. 윈도우는 아무래도 이런 거 하기엔 위험부담이 좀 있어서 우분투 노트북을 따로 썼다<span class="grey">(윈도우로 해보고 괜찮았던 사람이 있다면 후기 바란다)</span>.

ruby 설치는 [jekyllrb.com](https://jekyllrb.com/)의 [Jekyll on Ubuntu](https://jekyllrb.com/docs/installation/ubuntu/) 가이드를 따랐다. [한글 번역본](https://jekyllrb-ko.github.io/docs/installation/ubuntu/)도 있다. 설치 명령은 다음과 같다.

```shell
sudo apt-get install ruby-full build-essential zlib1g-dev
```

일단 저 명령어를 쓰면 루비가 설치되는데, 이게 끝이 아니고 환경변수를 설정해서 gem을 설치해야 한다. 가이드에서 이르길, root 사용자로 gem 패키지를 설치하지 말라고 하니 그것만 신경쓰면 문제 없다. 아래의 명령은 `~/.bashrc`에 gem 설치 경로를 구성한다.

```shell
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

이 다음에 jekyll과 Bundler를 설치하면 된다.

```shell
gem install jekyll bundler
```

여기까지 하고 나면 내 우분투 노트북에서는 뭔가가 버전이 안맞는다고 ERROR를 띄우긴 했는데 설치는 완료되었다고 하는 앞뒤가 안맞는 결과가 떴다. 그거 고쳐본다고 오류 메시지가 시키는 대로 추가 설치를 시도했었는데 하도 오래걸려서 포기했다. 그거 안 해도 블로그는 잘만 올라가더라. 설치가 잘 되었는지 확인하려면 터미널에 `ruby -v`, `gem -v`를 써보면 된다. 루비는 버전이 2.5.0 이상이어야 한다.

그리고 보통은 우분투를 쓴다면 당연히 있을 거라고 생각하지만 GCC와 Make도 필요하다. 이들이 설치되어 있는지 확인하려면 터미널에 `gcc -v`, `g++ -v`, `make -v`을 써보면 된다.

이제 Node.js도 설치해야 한다. Node.js를 설치하는 방법은 여러 가지 있지만 그중에 내가 시도해본 것은 세 가지이다([참고 링크](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04)). 하나는 데모 블로그의 가이드가 안내하는 대로 Node.js 사이트에서 파일을 다운받아 직접 설치하는 것이고, 두 번째는 `sudo apt install` 명령으로 설치하는 것이고, 세 번째는 노드 버전 관리자를 사용하는 것이다.

첫 번째, 파일 직접 설치하기. Node.js 사이트에 가보면 두 가지 선택지를 제공한다. 하나는 현재 기준으로 최신 LTS 버전인 18.16.x 버전, 다른 하나는 LTS가 아닌 최신 버전인 20.4.x이다. 나는 LTS 버전을 골라 다운받았었다. 파일은 `.tar.gz` 형태로 압축되어 있었고, 설치하는 방법은 [How do I install a .tar.gz (or .tar.bz2) file?](https://askubuntu.com/questions/25961/how-do-i-install-a-tar-gz-or-tar-bz2-file)을 참고했었다. 간단히 요약하면 (1) 압축을 풀고 (2) 해당 폴더로 들어가서 `./configure`와 `make`를 실행하고 (3) `sudo make install`로 설치하면 된다. 나는 `make`를 실행하다가 너무 오래걸려서 포기했다.

두 번째, `sudo apt install` 쓰기. 내가 알아본 방법 중 가장 간단하다. 터미널에 `sudo apt install nodejs`를 쓰면 끝난다. 대신 버전 선택권이 없다. 무조건 ubuntu 20.04에 포함된 버전인 10.19로 설치되고, 현재는 더이상 유지보수가 안 되는 버전이라고 한다. 그래서 업그레이드 할 방법을 찾다가 적어도 npm이나 nvm이 있어야 가능한 것 같아서 아예 처음부터 nvm을 이용해서 설치하기로 했다. 이미 설치한 Node.js는 `sudo apt remove nodejs`로 삭제하면 된다.

세 번째, Node Version Manager(nvm)으로 설치하기. 버전 관리자를 통해서 설치하는 것이다. 원하는 버전을 골라서 설치할 수 있다. 명령어는 다음과 같다. 여기서 마지막 부분의 `| bash`는 `curl`로 받은 내용을 바로 bash에 연결한다는 건데, 이 부분을 빼고 실행하면 `curl`에서 받아오는 내용 중에 원치 않는 부분이 있는지 먼저 확인할 수 있다.

```shell
# 확인만
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh
# 실행과 동시에 bash 연결
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
```

위 명령이 완료되면 `source ~/.bashrc`를 실행한다. 그 후 `nvm list-remote`를 실행하면 설치 가능한 버전을 확인할 수 있다. 이 중 LTS 버전은 추가로 별칭과 함께 표기되니 따로 공식 사이트에 가서 확인할 필요가 없다. 설치할 버전을 골랐다면 `nvm install v18.16.1` 명령으로 설치한다. 내가 설치한 버전은 `18.16.1`이다. 여기까지 하면 Node.js도 설치가 끝났다. 터미널에 `node -v`를 쓰면 설치가 되었는지 확인할 수 있다.

## 깃허브 블로그 만들고 올리기
이제부터 [jekyll-theme-chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) 레포지토리를 포크/클론해서 `자신의 깃허브 이름.github.io`라는 이름으로 새 레포지토리를 만들면 된다. 개인적으로 클론보다 포크를 추천한다. 클론은 원본 레포지토리에 흔적을 남기지 않을 수 있지만 이후 업데이트를 받기 어렵고(직접 베껴와야 함), 포크는 원본 레포지토리에서 포크한 레포지토리 목록을 확인할 수 있게 되지만 원본 레포지토리에서 이루어지는 업데이트를 지속적으로 간단하게 merge 받을 수 있다.

깃허브에 블로그 이름으로 새 레포지토리를 만들고 나면 로컬에 클론한다. 그 다음 터미널에서 클론한 레포지토리 경로로 들어간 다음 아래 명령을 실행한다. 참고로 이 명령을 실행하기 위해 Node.js를 설치한 거고, 레포지토리가 아닌 다른 경로에서 실행하면 명령어가 없다며 실행되지 않는다.

```shell
bash tools/init
```

가이드에서 말하길, 위 명령을 실행하면 코드가 최신 버전인지 확인하고, 필요 없는 샘플 파일을 정리하고 깃허브 관련 파일을 관리하고, 자바스크립트 관련 파일을 빌드하고 깃허브에서 관리할 수 있도록 하고, 앞선 변경사항을 자동으로 커밋한다고 한다.

이제부터 새로 만든 블로그는 로컬에서 테스트할 수 있게 되었다. 다만 첫 실행 전에는 의존성 설치를 위해 루트 디렉토리로 가서 `$ bundle` 명령을 실행해야 한다고 한다.

여기까지 블로그를 올릴 기본적인 준비는 끝났다. `_config.yml` 파일에서 `url`, `timezone`, 블로그 타이틀 및 프로필 등을 수정하면 블로그 세팅도 어느정도 끝난다.

앞선 과정을 모두 끝내고 터미널에서 `$ bundle exec jekyll s`를 실행하면 [http://127.0.0.1:4000](http://127.0.0.1:4000)에서 블로그가 실제로 어떻게 보여질지 로컬로 확인할 수 있다.

이 [블로그](https://dapin1490.github.io/satinbower/)처럼 웹에서도 블로그를 볼 수 있게 하려면 어떤 내용이든 상관 없으니 블로그 레포지토리에 새 커밋을 올리면 된다. 그러면 자동으로 깃허브 액션이 실행되어 알아서 블로그를 빌드하고 배포해준다.

다만 커밋을 올리기 전에 마지막으로 할 일이 있다. 깃허브 웹에서 블로그 레포지토리의 설정에 들어간 다음, 왼쪽 사이드바에서 `Pages` 탭을 클릭하고, 거기서 나오는 메뉴 중 `Source`에서 `Deploy from a branch`라고 쓰여 있는 것을 `Github Actions`로 바꿔야 한다. 이제 진짜로 커밋을 올리면 블로그가 완성된다.

참고로 `_config.yml` 파일에서 `baseurl`을 설정하면 원하는 이름으로 블로그를 만들 수 있다. 내 블로그의 `baseurl`은 `/satinbower`이다. 이외에 다양한 커스텀과 세부사항은 [Writing a New Post](https://chirpy.cotes.page/posts/write-a-new-post/)를 참고하자.

## 깃허브 블로그의 특징
깃허브 블로그는 사용자가 직접 html부터 css, 자바스크립트까지 거의 모든 걸 커스텀할 수 있어서 jekyll 테마를 쓰더라도 세부 디자인은 천차만별로 달라질 수 있다는 자유도가 참 좋지만, 정적 호스팅 방식으로 생성되다 보니 매번 내용을 업데이트할 때마다 블로그도 새로고침을 잘 해줘야 한다.

이 '새로고침을 잘 한다'라는 게 무슨 말이냐면, 캐시를 지우고 '강력하게' 새로고침을 해야 한다는 말이다. 내가 쓰는 Chirpy 테마의 경우 블로그가 업데이트 된 후에 블로그 사이트를 들어가보면, 사이트가 로딩되고 몇 초 후에 블로그가 업데이트되었다면서 '업데이트' 버튼이 달린 팝업이 뜬다. 이 버튼을 누르면 깃허브에서 올렸던 새 업데이트 내용이 적용된 페이지로 블로그가 새로고침된다. 이게 한 가지 '강력 새로고침' 방법이고, 그 몇 초를 기다리기가 귀찮다면 `Ctrl+Shift+R`을 누르면 된다. 강력 새로고침에 대한 자세한 사항은 구글에 강력 새로고침을 검색하거나 [브라우저 캐시 비우기 및 강력 새로고침 활용하기](https://imweb.me/faq?mode=view&category=29&category2=47&idx=71559)를 참고하자.