document.addEventListener("DOMContentLoaded", function () {
  const buttons = document.querySelectorAll(".tab-button");
  const contents = document.querySelectorAll(".tab-content");

  buttons.forEach((button) => {
    button.addEventListener("click", () => {
      // すべてのボタンから active クラスを削除
      buttons.forEach((btn) => btn.classList.remove("active"));
      // クリックされたボタンに active クラスを追加
      button.classList.add("active");

      // すべてのコンテンツを非表示にする
      contents.forEach((content) => (content.style.display = "none"));
      // 対応するコンテンツを表示
      document.getElementById(button.getAttribute("data-tab")).style.display =
        "block";
    });
  });
});
