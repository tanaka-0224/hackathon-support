document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("search-form");

  form.addEventListener("submit", function (event) {
    event.preventDefault(); // 通常のフォーム送信を無効にする

    // フォームのデータをURLエンコードしてクエリパラメータに変換
    const formData = new FormData(form);
    const queryParams = new URLSearchParams(formData).toString(); // クエリパラメータに変換

    // URLを作成
    const url = form.action + "?" + queryParams;

    // Fetch APIでGETリクエストを送信
    fetch(url, {
      method: "GET", // GETリクエストを送信
    })
      .then((response) => response.json())
      .then((data) => {
        const resultsContainer = document.getElementById("search-results");
        resultsContainer.innerHTML = ""; // 以前の結果をクリア

        if (data.length > 0) {
          data.forEach((member) => {
            const resultItem = document.createElement("div");
            resultItem.textContent = member.name;
            resultsContainer.appendChild(resultItem);
          });
        } else {
          resultsContainer.innerHTML = "<p>存在しないユーザーです</p>";
        }
      })
      .catch((error) => {
        console.error("検索結果の取得エラー:", error);
      });
  });
});
