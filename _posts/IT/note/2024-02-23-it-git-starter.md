---
title: "git/github 컨닝페이퍼"
author: dapin1490
date: 2024-02-23 17:57:00 +09:00
categories: [IT, note]
tags: [지식, IT, git, github]
render_with_liquid: false
---

### Table of Contents
- [개요](#개요)
- [레포지토리 생성](#레포지토리-생성)
  - [github에서 생성 후 로컬에 clone](#github에서-생성-후-로컬에-clone)
  - [로컬에서 생성 후, github에 동일 레포지토리 생성 후 push](#로컬에서-생성-후-github에-동일-레포지토리-생성-후-push)
  - [Github CLI를 이용해 로컬에서 생성 후 원격에 push](#github-cli를-이용해-로컬에서-생성-후-원격에-push)
- [커밋하기](#커밋하기)
  - [status](#status)
  - [add](#add)
  - [reset](#reset)
  - [checkout](#checkout)
  - [commit](#commit)
  - [push](#push)
- [가져오기](#가져오기)
  - [clone](#clone)
  - [fetch](#fetch)
  - [pull](#pull)
- [참고 자료](#참고-자료)

## 개요
기본 전제 사항
* 로컬에 git이 설치되어 있음
* github 계정이 있음
* git 이외에 터미널의 기본 사용법을 알고 있음
* 윈도우 기준

## 레포지토리 생성
크게 세 가지 방법이 있다.

1. github에서 생성 후 로컬에 clone
2. 로컬에서 생성 후, github에 동일 레포지토리 생성 후 push
3. Github CLI를 이용해 로컬에서 생성 후 원격에 push

### github에서 생성 후 로컬에 clone
가장 쉽다. github 웹사이트에서 레포지토리를 생성하고 링크를 복사해 로컬 터미널에서 다음과 같이 입력하면 된다. `{owner}` 대신 자신의 깃허브 아이디를, `{repository-name}` 대신 레포지토리 이름을 쓴다. 이때, 웹사이트의 레포지토리에는 최소 하나 이상의 커밋이 있어야 한다. 커밋이 뭔지 모른다면 레포지토리를 생성할 때 `Add a README file` 옵션에 체크해두자. 자동으로 파일을 생성하고 커밋해준다.

```shell
git clone https://github.com/{owner}/{repository-name}.git
```

실행하고 나면 명령어를 실행했던 폴더 내에 해당 레포지토리 이름으로 폴더가 추가되고(이미 있는 폴더라면 비어있어야 한다) 그 안에 파일들이 저장된다. 이후 cd 명령어로 폴더 안에 들어가 작업을 수행할 수 있다.

### 로컬에서 생성 후, github에 동일 레포지토리 생성 후 push
약간 번거로울 수 있지만 비교적 쉽다. 로컬에서 먼저 레포지토리를 생성한다. 이때 생성되는 레포지토리는 현재 터미널이 위치한 폴더를 기준으로 하며, 레포지토리 이름은 폴더명과 같다.

```shell
git init
```

만약 레포지토리를 생성한 폴더가 비어있다면 아무 파일을 하나 추가하자. 간단하게 `README.md`라는 이름으로 텍스트 파일을 만드는 것을 추천한다.  
폴더 내에 파일을 만들었다면 터미널로 돌아가 다음 명령어를 입력한다.

```shell
git status
```

현재 레포지토리의 상태를 확인하는 명령어로, 빨간 글씨로 아까 추가한 파일명이 뜰 것이다. 아래 명령어를 쓰면 그 글씨가 초록색으로 바뀐다.

```shell
git add .
git status
```

add는 커밋할 파일을 추가하는 명령어로, 빨간 글씨는 아직 추가되지 않은(unstaged) 파일, 초록색 글씨는 추가된(staged) 파일이다. `git add .`이라고 쓰면 모든 unstaged 파일을 커밋할 파일로 추가한다. 골라서 추가하려면 `.` 대신 파일명을 직접 쓰면 된다.  
다음으로 아래와 같이 커밋한다.

```shell
git commit -m "(커밋 메시지)"
```

커밋 메시지는 선택사항이긴 하지만 쓰는 것을 권장한다. 보통 무엇을 변경하거나 무슨 작업을 했는지 간단하게 쓴다. 지금과 같은 경우에는 `init`이라고만 써도 된다.

이제 로컬에서 할 일은 거의 다 끝났다. github에서 로컬과 똑같은 이름으로 빈 레포지토리를 만들고(`Add a README file` 옵션이 해제되어 있어야 한다) 터미널로 돌아오자. 아래와 같이 명령어를 입력하고, `{owner}`와 `{repository-name}`은 각각 레포지토리 소유자의 깃허브 닉네임과 레포지토리 이름이다.

```shell
git remote add origin https://github.com/{owner}/{repository-name}.git
git branch -M main
git push -u origin main
```

여기까지 마치면 로컬에서 생성한 레포지토리가 github에도 똑같이 업로드된다.

### Github CLI를 이용해 로컬에서 생성 후 원격에 push
위의 두 가지 방법은 레포지토리를 순수하게 명령어만으로 생성할 수는 없다는 점에서 덜 멋져보일 수 있다 *<span class="grey">(내가 그럼)</span>*.

일단 Github CLI를 설치해야 한다. <https://cli.github.com/>에서 msi 파일을 다운받아 설치한다. exe 파일 설치와 똑같이 하면 된다. 설치가 끝나면 터미널에 `gh` 명령어를 입력해 도움말이 나오는 것으로 확인할 수 있다.  
설치 후에는 다음과 같이 로그인한다. 터미널 경로는 어디든 상관 없고, 시키는 대로 잘 따르면 된다. 자세한 내용은 [이곳](https://ittrue.tistory.com/89#:~:text=%24%20gh-,%EB%A1%9C%EA%B7%B8%EC%9D%B8%20%ED%95%98%EA%B8%B0,-%EB%8B%A4%EC%9D%8C%20%EB%AA%85%EB%A0%B9%EC%96%B4%EB%A5%BC%20%EC%9E%85%EB%A0%A5%ED%95%98%EB%A9%B4)을 참고하자.

```shell
$ C:\Users\user_name> gh auth login
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations on this host? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: YOUR-CODE
Press Enter to open github.com in your browser...
✓ Authentication complete.
- gh config set -h github.com git_protocol https
✓ Configured git protocol
✓ Logged in as user_name
```

이제 `gh` 명령어로 로컬에서도 원격 레포지토리를 생성할 수 있다. 먼저 로컬 레포지토리 생성 과정은 [로컬에서 생성 후, github에 동일 레포지토리 생성 후 push](#로컬에서-생성-후-github에-동일-레포지토리-생성-후-push) 단락과 같다. `commit`까지만 하면 된다. 그 다음엔 아래 명령어 중 원하는 것을 적당히 찾아서 입력하자.

```shell
# template
gh repo create [<name>] [flags]

# create a repository interactively
gh repo create

# create a new remote repository and clone it locally
gh repo create my-project --public --clone

# create a remote repository from the current directory
gh repo create my-project --private --source=. --remote=upstream
```

지금과 같은 경우 로컬에 이미 생성된 레포지토리가 있으므로 네 번째 명령어와 같이 입력하면 된다. `--private`은 비공개 레포지토리를 생성하게 하고, `--source=.`은 현재 폴더를 레포지토리로 만들게 한다. `--remote` 옵션은 생략 가능하다. `repo create` 실행을 완료하면 아래와 같이 원격 레포지토리도 자동으로 연결해준다.

```shell
$ C:\repo-name> gh repo create --private --source=.
✓ Created repository user-name/repo-name on GitHub
  https://github.com/user-name/repo-name
✓ Added remote https://github.com/user-name/repo-name.git
```

이 다음 과정은 다른 문단과 같다. 최소 하나의 커밋을 만들고, `git branch -M main && git push -u origin main`으로 원격에 올리면 된다.

Github CLI 및 레포지토리 생성에 대한 자세한 참고 자료는 [cli.github.com/manual/gh_repo_create](https://cli.github.com/manual/gh_repo_create)에서 볼 수 있다.

## 커밋하기
레포지토리 생성 과정에서 썼던 `commit`, `push` 명령어가 가장 기본이 되는 과정이다. 수정하거나 새로 추가한 파일을 확정하고 레포지토리에 올린다.

### status
현재 레포지토리의 상태를 확인한다. 현재 사용 중인 브랜치 이름, 원격과 비교하여 최신인지 보여주고, 만약 커밋하지 않은 파일이 있다면 해당 파일들의 정보도 보여준다. 다음은 파일 변경이 있는 경우의 출력 예시이다.

```shell
$ C:\repo-name> git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   temp.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

### add
커밋할 파일을 목록에 추가한다. 이를 'stage한다'고 이른다. 스테이지된 파일은 staged, 그렇지 않은 것은 not staged 또는 unstaged라고 한다. 사용할 때는 파일명을 직접 입력하여 추가하거나, `.`을 이용해 변동사항이 있는 모든 파일을 한번에 추가할 수 있다.

```shell
# 모든 파일 stage
git add .

# 특정 파일 stage
git add file-name.txt
```

### reset
잘못된 파일을 `add`했거나, 취소하고 싶을 때 사용한다. [git 가이드](https://git-scm.com/book/ko/v2/Git%EC%9D%98-%EA%B8%B0%EC%B4%88-%EB%90%98%EB%8F%8C%EB%A6%AC%EA%B8%B0)에 따르면 이 명령어는 잘못 사용하면 위험하다고 하니 주의하자.

```shell
git reset HEAD
```

### checkout
파일의 변동사항 자체를 삭제하고 싶을 때 사용한다. 삭제한 내용은 되돌릴 수 없으니 주의해야 한다. 명령어 실행 후 파일은 마지막 커밋 시점의 상태로 돌아간다. 중요하니까 강조한다. 한번 실행하면 되돌릴 수 없다.

```shell
git checkout -- filename.txt
```

### commit
stage한 파일을 확정(commit)한다. `-m` 옵션으로 커밋 메시지를 추가할 수 있으며, 일반적으로 커밋 메시지를 적는 것을 권장한다.

```shell
git commit -m "commit message"
```

커밋 메시지에는 간략하게 이 커밋이 무엇을 수정/변경한 것인지 쓰면 된다.

### push
로컬에서 커밋한 내용을 원격에 보낸다. 로컬과 원격의 상황에 따라 push가 불가한 상황이 있을 수 있지만 일단은 가볍게 push할 수 있는 상황을 전제하자 *<span class="grey">(나도 잘 모르니까)</span>*.

```shell
# 기본
git push

# 레포지토리 생성 및 원격 연결 후 처음 push할 때
git push -u origin main
```

## 가져오기
위에서는 모두 추가하고 작성하는 것에 대한 내용이었다. 이번에는 작성된 것을 가져와보자.

### clone
원격 레포지토리를 로컬에 가져올 때 쓴다. 공개된 레포지토리는 간단히 가져올 수 있다.

```shell
git clone https://github.com/user-name/repo-name.git
```

비공개 레포지토리는 추가 절차가 필요하다. github에서 perssonal access token을 생성해야 한다. 생성 방법은 [깃허브 github personal access token 발급하는 방법](https://lifefun.tistory.com/161)을 참고하자. 클래식이든 아니든 별 상관 없다. 권한 설정이 어렵다면 그냥 모든 권한을 허용하면 일단은 사용 가능하다. 지금 당장 실무에 투입되어야 하는 게 아닌 이상, 쓰면서 배워도 된다.

토큰이 생성되었으면 토큰 텍스트를 복사해서 어딘가에 적어두고 아래와 같이 clone 명령어를 쓰면 된다.

```shell
git clone https://perssonal-access-token-text@github.com/user-name/private-repo-name.git
```

### fetch
원격 레포지토리의 커밋 기록을 가져온다. 가져오기만 할 뿐, 로컬의 파일은 변경하지 않는다.

```shell
git fetch
```

### pull
원격 레포지토리의 커밋 기록을 가져오고, 로컬 레포지토리를 최신 상태로 업데이트한다. 로컬의 파일을 변경한다.

```shell
git pull
```

## 참고 자료
* [명령줄을 사용하여 Git 리포지토리 가져오기](https://docs.github.com/ko/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github#importing-a-git-repository-with-the-command-line)
* [stage 상태에서 unstaged 상태로 되돌리기](https://heeyeonjeong.tistory.com/15)
* [2.4 Git의 기초 - 되돌리기](https://git-scm.com/book/ko/v2/Git%EC%9D%98-%EA%B8%B0%EC%B4%88-%EB%90%98%EB%8F%8C%EB%A6%AC%EA%B8%B0)
* [gh repo create](https://cli.github.com/manual/gh_repo_create)
* [perssonal access token으로 비공개 레포 git clone 하기](https://chinsun9.github.io/2021/07/06/git-clone-using-pat/)
* [깃허브 github personal access token 발급하는 방법](https://lifefun.tistory.com/161)
