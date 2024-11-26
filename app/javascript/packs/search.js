document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("search-form");

  form.addEventListener("submit", function (event) {
    event.preventDefault();

    const formData = new FormData(form);
    const queryParams = new URLSearchParams(formData).toString();

    const url = form.action + "?" + queryParams;

    fetch(url, {
      method: "GET", // GETリクエストを送信
    })
      .then((response) => response.json())
      .then((data) => {
        const resultsContainer = document.getElementById("search-results");
        resultsContainer.innerHTML = ""; // 以前の結果をクリア

        if (data.length > 0) {
          data.forEach((user) => {
            const resultItem = document.createElement("div");
            resultItem.textContent = `ID: ${user.id}, Name: ${user.name}`;

            const addButton = document.createElement("button");
            addButton.textContent = "Add";
            addButton.onclick = function () {
              addUserToProject(user.id);
            };
            resultItem.appendChild(addButton);

            resultsContainer.appendChild(resultItem);
          });
        } else {
          resultsContainer.innerHTML = "<p>No users found</p>";
        }
      })
      .catch((error) => {
        console.error("検索結果の取得エラー:", error);
      });
  });
  function addUserToProject(userId) {
    console.log("UserID、ProjectID", userId, currentProjectId); // ログでIDを確認
    fetch("/add_member", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ user_id: userId, project_id: currentProjectId }),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log("Response from server:", data); // サーバーからのレスポンスを確認
        const membersContainer = document.getElementById("members-list");
        const newMember = document.createElement("div");
        newMember.textContent = `ID: ${data.user.id}, Name: ${data.user.name}`;
        membersContainer.appendChild(newMember);
      })
      .catch((error) => console.error("Error adding user to project:", error));
  }
});
