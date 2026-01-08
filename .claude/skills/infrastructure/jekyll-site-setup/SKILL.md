---
name: jekyll-site-setup
description: Set up and configure Jekyll static site generator for blogs, documentation sites, and portfolios. Covers installation, directory structure, Liquid templates, Front Matter, layouts, includes, posts, collections, plugins, deployment to GitHub Pages, and best practices.
tags: [jekyll, static-site, markdown, ruby, blogging, documentation]
platforms: [Claude, ChatGPT, Gemini]
allowed-tools: [read, grep, write, shell]
---

# Jekyll Site Setup

## 목적 (Purpose)

Jekyll 정적 사이트 생성기를 설치, 설정, 콘텐츠 구조를 만들고 배포합니다. 블로그, 포트폴리오, 문서 사이트에 이상적인 솔루션입니다.

## 사용 시점 (When to Use)

- **새로운 Jekyll 사이트 생성**할 때
- **기존 Jekyll 사이트 설정**을 최적화할 때
- **Jekyll 블로그**를 구축할 때
- **문서 사이트**를 Jekyll로 마이그레이션할 때
- **Liquid 템플릿 문법**을 학습할 때
- **Jekyll 플러그인**을 추가할 때

## 사전 요구사항 (Prerequisites)

### 필수 조건
- **Ruby 2.7.0 이상** 설치됨
- **RubyGems** (Ruby 패키지 매니저) 설치됨
- **Bundler** (Gem 의존성 관리자)

### 확인 명령어
```bash
# Ruby 버전 확인
ruby --version  # 2.7.0+ 필요

# Bundler 설치 확인
bundle --version

# GCC와 Make 확인 (일부 플러그인 필요)
gcc --version
make --version
```

## 작업 절차 (Procedure)

### 1단계: 프로젝트 유형 파악

사용자 요청을 분석하여:
- **새로운 사이트**인지, 기존 사이트 설정인지
- **블로그**, **포트폴리오**, **문서 사이트** 중 어느 유형인지
- **호스팅 환경**: GitHub Pages, GitLab Pages, Netlify, Vercel 등

**사용자에게 질문** (명확하지 않을 때):
```
1. 새로운 사이트를 생성하시겠습니까? 아니면 기존 사이트 설정을 변경하시겠습니까?
2. 사이트의 주요 목적은 무엇인가요?
   - [ ] 블로그
   - [ ] 포트폴리오
   - [ ] 기술 문서
   - [ ] 기업 사이트
   - [ ] 기타 (설명): ______
3. 호스팅 환경은 어떻게 되나요?
   - [ ] GitHub Pages
   - [ ] GitLab Pages
   - [ ] Netlify
   - [ ] Vercel
   - [ ] 기타: ______
```

### 2단계: Jekyll 설치

#### 2.1. 시스템에 설치
```bash
# Jekyll과 Bundler 전역 설치
gem install jekyll bundler

# 확인
jekyll --version
bundle --version
```

#### 2.2. 새 프로젝트 생성
```bash
# 새 Jekyll 사이트 생성
jekyll new my-awesome-site
cd my-awesome-site

# 또는 블로그 템플릿 사용
jekyll new myblog --blank

# Gemfile에 webrick 추가 (Ruby 3.0+ 필요)
bundle add webrick
```

#### 2.3. 로컬 서버 실행
```bash
# 기본 서버 실행
bundle exec jekyll serve

# Live Reload 기능 활성화
bundle exec jekyll serve --livereload

# 포트 변경
bundle exec jekyll serve --port 4001

# 빌드 파일 제거 후 실행
bundle exec jekyll serve --incremental
```

**브라우저 접속**: http://localhost:4000

### 3단계: 디렉토리 구조 설정

Jekyll 사이트의 표준 구조를 생성합니다.

```bash
# 기본 구조 생성
mkdir -p _includes _layouts _posts _drafts _data _sass assets images
```

**권장 디렉토리 구조**:
```
my-awesome-site/
├── _config.yml              # 전역 설정 (필수)
├── _config_dev.yml          # 개발 환경 설정
├── _config_prod.yml         # 프로덕션 환경 설정
├── _data/                   # YAML/JSON 데이터 파일
├── _drafts/                 # 아직 게시되지 않은 포스트
├── _includes/               # 재사용 가능한 HTML 조각
├── _layouts/                # 페이지 템플릿
├── _posts/                  # 블로그 포스트
├── _sass/                   # Sass 부분 파일
├── assets/                  # 이미지, CSS, JS 등 정적 자산
├── 404.html                # 커스텀 404 페이지
├── index.html               # 홈페이지
├── README.md                # 프로젝트 문서
├── .gitignore               # Git 무시 파일
└── Gemfile                  # Ruby 의존성 관리
```

### 4단계: _config.yml 설정

필수 및 권장 설정을 _config.yml에 작성합니다.

```yaml
# _config.yml

# 기본 설정
title: "My Awesome Site"
description: "A site built with Jekyll"
author: "Your Name"
lang: "ko"
timezone: "Asia/Seoul"

# URL 설정
url: "https://username.github.io"  # 배포 URL
baseurl: ""                          # 사이트 루트 경로

# Markdown 설정
markdown: kramdown
highlighter: rouge
kramdown:
  input: GFM
  syntax_highlighter_opts:
    default_lang: text

# 포스트 설정
permalink: /:year/:month/:day/:title/
excerpt_separator: "<!--more-->"
paginate: 10
paginate_path: "/blog/page:num/"

# 플러그인 및 설정
plugins:
  - jekyll-paginate
  - jekyll-sitemap
  - jekyll-seo-tag
  - jekyll-feed

# 제외 파일
exclude:
  - Gemfile
  - Gemfile.lock
  - node_modules
  - .gitignore
  - README.md

# 기본값 설정
defaults:
  - scope:
      path: ""           # 모든 파일
      type: "posts"      # 포스트에 적용
    values:
      layout: "post"     # 기본 레이아웃
      author: "Default Author"
      read_time: true

# 컬렉션 설정
collections:
  projects:
    output: true
    permalink: /project/:path/

# Sass/SCSS 설정
sass:
  style: compressed
  load_paths:
    - _sass/
    - node_modules/
```

### 5단계: 템플릿 시스템 구축

#### 5.1. 기본 레이아웃 (_layouts/default.html)

```html
<!doctype html>
<html lang="{{ site.lang }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{% if page.title %}{{ page.title }} | escape }} - {% endif %}{{ site.title }}</title>
    
    <!-- 스타일시트 -->
    <link rel="stylesheet" href="{{ site.baseurl }}/assets/css/main.css">
    
    <!-- SEO 태그 -->
    {% seo title=false %}
    
    <!-- RSS 피드 -->
    <link rel="alternate" type="application/rss+xml" title="{{ site.title }}" href="{{ site.baseurl }}/feed.xml">
</head>
<body>
    {% include header.html %}
    
    <main>
        {{ content }}
    </main>
    
    {% include footer.html %}
    
    <!-- JavaScript -->
    <script src="{{ site.baseurl }}/assets/js/main.js" async></script>
</body>
</html>
```

#### 5.2. 포스트 레이아웃 (_layouts/post.html)

```html
---
layout: default
---

<article class="post">
    <header class="post-header">
        <h1 class="post-title">{{ page.title }}</h1>
        
        <div class="post-meta">
            <time datetime="{{ page.date | date_to_xmlschema }}">
                {{ page.date | date: "%Y년 %m월 %d일" }}
            </time>
            
            {% if page.author %}
            <span class="post-author">
                by {{ page.author }}
            </span>
            {% endif %}
            
            {% if page.categories %}
            <span class="post-categories">
                in
                {% for category in page.categories %}
                    <a href="{{ category | slugify }}/">{{ category }}</a>{% unless forloop.last %}, {% endunless %}
                {% endfor %}
            </span>
            {% endif %}
            
            {% if page.read_time %}
            <span class="post-read-time">
                {{ content | reading_time }} min read
            </span>
            {% endif %}
        </div>
    </header>
    
    <div class="post-content">
        {{ content }}
    </div>
    
    {% if page.tags %}
    <footer class="post-tags">
        <h4>Tags</h4>
        <ul>
            {% for tag in page.tags %}
            <li><a href="/tags/{{ tag | slugify }}/">#{{ tag }}</a></li>
            {% endfor %}
        </ul>
    </footer>
    {% endif %}
    
    <!-- 이전/다음 포스트 네비게이션 -->
    <nav class="post-navigation">
        <div class="prev-post">
            {% if page.previous %}
            <a href="{{ page.previous.url }}" rel="prev">&larr; {{ page.previous.title }}</a>
            {% endif %}
        </div>
        <div class="next-post">
            {% if page.next %}
            <a href="{{ page.next.url }}" rel="next">{{ page.next.title }} &rarr;</a>
            {% endif %}
        </div>
    </nav>
</article>
```

#### 5.3. Includes 생성

**_includes/header.html**:
```html
<header class="site-header">
    <nav class="site-nav">
        <a href="{{ site.baseurl }}/" class="site-logo">
            {{ site.title }}
        </a>
        
        <div class="nav-links">
            <a href="{{ site.baseurl }}/">Home</a>
            <a href="{{ site.baseurl }}/blog/">Blog</a>
            <a href="{{ site.baseurl }}/about/">About</a>
            <a href="{{ site.baseurl }}/projects/">Projects</a>
        </div>
    </nav>
</header>
```

**_includes/footer.html**:
```html
<footer class="site-footer">
    <p>&copy; {{ site.time | date: "%Y" }} {{ site.author }}. All rights reserved.</p>
    
    <div class="social-links">
        <a href="https://github.com/{{ site.github_username }}" target="_blank">GitHub</a>
        <a href="https://twitter.com/{{ site.twitter_username }}" target="_blank">Twitter</a>
    </div>
</footer>
```

### 6단계: 포스트 작성 가이드

#### 6.1. 파일명 규칙

```
YYYY-MM-DD-title.md
```

예시: `2024-01-15-welcome-to-jekyll.md`

#### 6.2. Front Matter 형식

```markdown
---
layout: post
title: "Welcome to Jekyll!"
date: 2024-01-15 10:30:00 +0900
categories: tutorial
tags: [jekyll, markdown, blogging]
author: "Jane Doe"
excerpt: "Learn how to set up Jekyll for your static site..."
image: /assets/images/jekyll-preview.jpg
---

이곳에 실제 내용을 작성합니다...
```

#### 6.3. 이미지 포함

```markdown
<!-- 방법 1: 절대 경로 -->
![My helpful screenshot]({{ site.baseurl }}/assets/images/screenshot.jpg)

<!-- 방법 2: page 변수 -->
![{{ page.title }} preview]({{ site.baseurl }}{{ page.image }})

<!-- 방법 3: assets 폴더 -->
[Download the PDF]({{ site.baseurl }}/assets/documents/mydoc.pdf)
```

#### 6.4. 코드 블록

````markdown
```javascript
function hello() {
    console.log("Hello, Jekyll!");
}
```
```

### 7단계: 플러그인 추가

#### 7.1. Gemfile에 추가

```ruby
# Gemfile

source "https://rubygems.org"

gem "jekyll", "~> 4.3"

# SEO 플러그인
gem "jekyll-seo-tag"

# 사이트맵 생성
gem "jekyll-sitemap"

# RSS 피드
gem "jekyll-feed"

# 검색
gem "jekyll-algolia"

# 문법 강조
gem "jekyll-rouge"

# 설치
bundle install
```

#### 7.2. 플러그인 설정 (_config.yml)

```yaml
plugins:
  - jekyll-paginate
  - jekyll-seo-tag
  - jekyll-sitemap
  - jekyll-feed
  - jekyll-rouge
```

### 8단계: 스타일링 설정

#### 8.1. SCSS 구조

```
_sass/
├── main.scss          # 메인 파일 (모든 파일 import)
├── _variables.scss    # 변수 (색상, 폰트, 간격)
├── _mixins.scss      # 믹스인 (재사용 스타일)
├── _base.scss        # 기본 스타일
├── _layout.scss      # 레이아웃 스타일
└── _components.scss  # 컴포넌트 스타일
```

#### 8.2. main.scss

```scss
---
# Front Matter (파일 파서를 위해)
---

// 변수 임포트
@import 'variables';

// 믹스인 임포트
@import 'mixins';

// 부분 스타일 임포트
@import 'base';
@import 'layout';
@import 'components';
```

#### 8.3. 빌드 설정

```yaml
# _config.yml

sass:
  sass_dir: _sass
  style: compressed  # compressed, expanded, nested, compact
  load_paths:
    - _sass/
    - node_modules/
```

### 9단계: 배포 설정

#### 9.1. GitHub Pages 배포

**방법 1: gh-pages 브랜치 사용**

```bash
# 브랜치 생성
git checkout -b gh-pages

# Jekyll 빌드
jekyll build

# _site 폴더의 내용만 커밋
git add _site
git commit -m "Deploy to GitHub Pages"

# 푸시
git push origin gh-pages

# 다시 main 브랜치로
git checkout main
```

**방법 2: GitHub Actions 자동 배포**

`.github/workflows/jekyll.yml`:
```yaml
name: Build and deploy

on:
  push:
    branches: [main]

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true
      
      - name: Install dependencies
        run: |
          gem install bundler
          bundle install
      
      - name: Build site
        run: bundle exec jekyll build
      
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./_site
```

#### 9.2. Netlify 배포

```toml
# netlify.toml

[build]
  command = "bundle exec jekyll build"
  publish = "_site"

[build.environment]
  RUBY_VERSION = "3.2"
```

### 10단계: 최적화 및 모범 사례

#### 10.1. 성능 최적화

```yaml
# _config.yml

# 이미지 최적화
compress_html:
  clippings: all
  comments: all
  endings: all

# 캐시 제어
# _site/ 폴더는 Git에 포함하지 않음
```

#### 10.2. SEO 설정

```html
<!-- _includes/head.html -->

{% seo %}
<meta name="description" content="{{ page.excerpt | default: site.description | strip_html | normalize_whitespace | truncate: 160 }}">
<meta name="keywords" content="{% if page.tags %}{{ page.tags | array_to_sentence_string }}{% endif %}">
<link rel="canonical" href="{{ page.url | absolute_url }}">
```

#### 10.3. 접근성 향상

```html
<!-- 이미지 대체 텍스트 -->
<img src="{{ page.image }}" alt="{{ page.title }}" />

<!-- 키보드 네비게이션 -->
<button aria-label="메뉴 열기" onclick="toggleMenu()">
    <span aria-hidden="true">☰</span>
</button>

<!-- 색상 대비 -->
<style>
body {
    color: #333;
    background-color: #fff;
}
</style>
```

## 출력 포맷 (Output Format)

### 성공 시

```markdown
## ✅ Jekyll 사이트 설정 완료

### 생성된 구조
- ✅ _config.yml: 전역 설정 완료
- ✅ _layouts/: 템플릿 시스템 구축
- ✅ _includes/: 재사용 컴포넌트 생성
- ✅ _posts/: 포스트 폴더 구조 확인
- ✅ assets/: 정적 자산 폴더 준비
- ✅ Gemfile: 의존성 관리 설정

### 테스트 방법

```bash
cd my-awesome-site
bundle exec jekyll serve
```

**브라우저에서 접속**: http://localhost:4000

### 배포 방법

**GitHub Pages**:
```bash
# 방법 1: gh-pages 브랜치
git subtree push --prefix _site origin gh-pages

# 방법 2: GitHub Actions
# .github/workflows/jekyll.yml 자동 배포 설정됨
```

**Netlify**:
```bash
# Netlify 대시보드에서 빌드 명령어 설정
bundle exec jekyll build
```

### 다음 단계

1. **첫 포스트 작성**: `_posts/2024-MM-DD-title.md` 생성
2. **Liquid 템플릿 학습**: `site.`, `page.`, `content` 변수 활용
3. **플러그인 추가**: SEO, 사이트맵, 검색 기능 추가
4. **CI/CD 설정**: GitHub Actions로 자동 빌드/배포
```

### 오류 발생 시

```markdown
## ❌ Jekyll 설정 실패

### 원인
- [구체적인 원인 설명]

### 해결 방법
```bash
# 제안된 해결 방법
```

### 추가 도움
- [Jekyll 공식 문서](https://jekyllrb.com/docs/)
- [Jekyll 문제 해결](https://jekyllrb.com/docs/troubleshooting/)
- [GitHub Community](https://github.com/jekyll/jekyll/discussions)
```

## 제약사항 (Constraints)

### 필수 준수 사항

1. **파일명 규칙**: 포스트는 `YYYY-MM-DD-title.md` 형식 준수
2. **UTF-8 인코딩**: 모든 파일을 UTF-8 (BOM 없음)로 저장
3. **Front Matter 필수**: 모든 포스트/페이지에 최소 `layout`, `title` 포함
4. **_site/ 폴더 제외**: Git에 _site/ 폴더 포함 금지 (자동 생성됨)
5. **Git 저장소**: 버전 관리를 위해 Git 사용 필수

### 보안 규칙

1. **API 키 관리**: `_config.yml`에 API 키 절대 포함하지 않음
2. **환경 변수 사용**: 비밀 정보는 환경 변수 또는 `.env` 파일 활용
3. **암호화된 배포**: HTTPS 프로토콜 필수
4. **파일 권한**: 중요 파일에 적절한 권한 설정 (600, 644)

### 코딩 표준

1. **들여쓰기**: 4칸 들여쓰기 사용 (탭 금지)
2. **Liquid 문법**: `{% %}` 제어문, `{{ }}` 출력 구분
3. **HTML5 시멘틱**: 올바른 HTML5 태그 사용
4. **반응형 디자인**: 모바일 우선 접근성 보장

## 참고 자료 (References)

### 공식 문서
- [Jekyll 공식 문서](https://jekyllrb.com/docs/)
- [Liquid 템플릿 언어](https://shopify.github.io/liquid/)
- [Jekyll 플러그인](https://jekyllrb.com/docs/plugins/)

### 템플릿
- [Jekyll Themes](http://jekyllthemes.org/)
- [Jekyll Themes by Pages](https://github.com/pages/themes)
- [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/)

### 튜토리얼
- [Jekyll 시작하기](https://jekyllrb.com/docs/)
- [Liquid 템플릿 학습](https://shopify.github.io/liquid/)
- [GitHub Pages 사용법](https://docs.github.com/en/pages/)

### 커뮤니티
- [Jekyll GitHub Discussions](https://github.com/jekyll/jekyll/discussions)
- [Jekyll Stack Overflow](https://stackoverflow.com/questions/tagged/jekyll)
- [Jekyll Talk Slack](https://join.slack.com/jekyllrb)

## 예시 사용 사례 (Examples)

### 예시 1: 블로그 생성

**사용자 요청**: "기술 블로그 만들어줘"

**실행 절차**:
1. 새로운 사이트 확인
2. `_config.yml`에 블로그 관련 설정 추가
3. 포스트 레이아웃 생성
4. `_posts/` 폴더 구조 준비
5. 첫 포스트 샘플 작성

**결과**: 기술 블로그 기본 템플릿 완성

### 예시 2: 기업 문서 사이트

**사용자 요청**: "제품 문서 사이트 필요해"

**실행 절차**:
1. `documentation` 컬렉션 생성
2. 사이드바 레이아웃 작성
3. 검색 기능 (Algolia/Jekyll Search) 추가
4. 버전 선택기 (dropdown) 추가

**결과**: 기업 문서 사이트 구조 완성

### 예시 3: 포트폴리오 사이트

**사용자 요청**: "개발자 포트폴리오 만들어줘"

**실행 절차**:
1. `projects` 컬렉션 생성
2. 프로젝트 상세 페이지 레이아웃
3. 필터링 기능 (카테고리/기술 스택) 추가
4. 갤러리 그리드 레이아웃

**결과**: 포트폴리오 사이트 템플릿 완성

## 문제 해결 (Troubleshooting)

### 일반적인 문제

#### 문제 1: Jekyll 빌드 실패

**증상**:
```
Liquid Exception: Liquid syntax error
```

**원인**: Liquid 문법 오류, 파일명 문제

**해결**:
```bash
# 문법 검사
jekyll build --verbose

# 문제 파일 확인
grep -r "{%" . --include="*.html" --include="*.md"
```

#### 문제 2: 포스트가 표시되지 않음

**증상**: `_posts/`에 있는 파일이 사이트에 표시되지 않음

**원인**: 파일명 형식 오래짜 없음, `published: false`

**해결**:
```markdown
# 올바른 파일명
2024-01-15-my-post.md  # ✅
my-post.md  # ❌ (날짜 없음)
```

#### 문제 3: 이미지가 로드되지 않음

**증상**: `<img>` 태그의 이미지가 깨짐

**원인**: 경로 오류, `_site/`에 이미지 없음

**해결**:
```html
<!-- 올바른 경로 -->
<img src="{{ site.baseurl }}/assets/images/photo.jpg" alt="Photo" />
```

#### 문제 4: GitHub Pages 배포 안 됨

**증상**: GitHub Pages가 빌드 실패

**원인**: Ruby 버전 불일치, Gemfile 오류

**해결**:
```yaml
# Gemfile
source "https://rubygems.org"
ruby ">= 2.7.0"

gem "jekyll", "~> 4.3"
```

### 고급 문제 해결

#### 문제: 플러그인 충돌

**해결**:
```bash
# 플러그인 비활성화 후 순차적으로 활성화
bundle exec jekyll build --config _config_minimal.yml
```

#### 문제: 빌드 속도 느림

**해결**:
```bash
# 증분 빌드
bundle exec jekyll build --incremental

# 캐시 사용
bundle exec jekyll build --profile
```

## 성공 기준 (Success Criteria)

### 필수 조건

- [ ] Ruby 2.7.0+ 설치됨
- [ ] Jekyll 4.0+ 설치됨
- [ ] `_config.yml` 기본 설정 완료
- [ ] 최소 1개 레이아웃 생성됨
- [ ] 최소 1개 include 파일 생성됨
- [ ] 로컬 서버 실행 가능

### 권장 조건

- [ ] 포스트 폴더 구조 완성
- [ ] SCSS/Sass 스타일링 설정됨
- [ ] 최소 1개 플러그인 추가됨
- [ ] 배포 설정 완료
- [ ] 브라우저에서 접속 가능

## 버전 기록 (Version History)

| 날짜 | 버전 | 변경 내용 |
|------|------|---------|
| 2026-01-07 | 1.0.0 | 초기 스킬 생성 - Jekyll 사이트 설정 가이드 완성 |

---

**Platform**: Claude, ChatGPT, Gemini
**Skill Type**: Infrastructure
**Complexity**: Intermediate
**Estimated Time**: 30-60분 (프로젝트 규모에 따라)
