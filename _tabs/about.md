---
# the default layout is 'page'
icon: fas fa-info-circle
order: 4
---

<div id="github-readme-loading">
  GitHub 프로필 README를 불러오는 중입니다...
</div>
<div id="github-readme"></div>

<script>
  const GITHUB_README_URL = 'https://raw.githubusercontent.com/dapin1490/dapin1490/refs/heads/main/README.md';

  document.addEventListener('DOMContentLoaded', function () {
    const target = document.getElementById('github-readme');
    const loading = document.getElementById('github-readme-loading');

    fetch(GITHUB_README_URL)
      .then(function (res) {
        if (!res.ok) {
          throw new Error('Network response was not ok');
        }
        return res.text();
      })
      .then(function (markdown) {
        if (loading) {
          loading.style.display = 'none';
        }
        // marked 라이브러리를 사용해 마크다운 → HTML로 변환
        target.innerHTML = marked.parse(markdown);
      })
      .catch(function (err) {
        console.error(err);
        if (loading) {
          loading.textContent = 'README를 불러오지 못했습니다.';
        }
      });
  });
</script>