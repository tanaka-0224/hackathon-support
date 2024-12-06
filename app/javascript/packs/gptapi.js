document.addEventListener("DOMContentLoaded", () => {
  const generateButton = document.getElementById("generate-suggestion");
  if (generateButton) {
    generateButton.addEventListener("click", async (event) => {
      event.preventDefault(); // デフォルトのリンク動作を無効化

      const projectId = generateButton.dataset.projectId; // プロジェクトIDを取得
      const response = await fetch(`/projects/${projectId}/suggest`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (response.ok) {
        const data = await response.json();
        // データをセッションストレージに保存
        sessionStorage.setItem("project_data", JSON.stringify(data));

        // プロジェクトページに遷移
        window.location.href = `/${projectId}`;
      } else {
        alert("提案の取得に失敗しました");
      }
    });
  }
});
