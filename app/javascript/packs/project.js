document.addEventListener("DOMContentLoaded", () => {
  const suggestButton = document.getElementById("suggest-button");

  if (!suggestButton) {
    console.error("Suggest button not found");
    return;
  }

  suggestButton.addEventListener("click", async () => {
    const projectId = suggestButton.dataset.projectId;

    // RailsのCSRFトークンを取得
    const csrfToken = document.querySelector("meta[name='csrf-token']").content;

    try {
      const response = await fetch(`/projects/${projectId}/suggest`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken, // トークンをヘッダーに追加
        },
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error("Response error:", response.status, errorText);
        alert(`Error: ${response.statusText}`);
        return;
      }

      const data = await response.json();

      if (data.project_id) {
        window.location.href = `/${data.project_id}`;
      } else {
        alert("Failed to save the suggestion.");
      }
    } catch (error) {
      console.error("Fetch error:", error);
      alert("An error occurred while suggesting a project.");
    }
  });
});
