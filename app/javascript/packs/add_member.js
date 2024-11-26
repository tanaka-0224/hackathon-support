export function addMember(userId) {
  // メンバー追加処理
  fetch("/home/add_member", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document
        .querySelector('meta[name="csrf-token"]')
        .getAttribute("content"), // CSRF対策
    },
    body: JSON.stringify({ user_id: userId }),
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        updateMemberList(userId); // メンバー一覧を更新
        alert("メンバーとして追加されました！");
      } else {
        alert("追加に失敗しました。");
      }
    })
    .catch((error) => {
      console.error("メンバー追加エラー:", error);
    });
}

function updateMemberList(userId) {
  fetch(`/users/${userId}`) // 新しいメンバー情報を取得
    .then((response) => response.json())
    .then((data) => {
      const memberList = document.querySelector("#tab1");
      const memberItem = document.createElement("div");
      memberItem.textContent = data.name;
      memberList.appendChild(memberItem);
    })
    .catch((error) => {
      console.error("メンバーリスト更新エラー:", error);
    });
}

// function addMember(userId, projectId) {
//   fetch(`/projects/${projectId}/project_members`, {
//     method: "POST",
//     headers: {
//       "Content-Type": "application/json",
//       "X-CSRF-Token": document
//         .querySelector('meta[name="csrf-token"]')
//         .getAttribute("content"),
//     },
//     body: JSON.stringify({ user_id: userId }),
//   })
//     .then((response) => response.json())
//     .then((data) => {
//       if (data.success) {
//         alert("メンバーが追加されました！");
//         updateTab1(data.user); // タブ1を更新
//       } else {
//         alert(data.message || "追加に失敗しました");
//       }
//     })
//     .catch((error) => console.error("追加エラー:", error));
// }

// function updateTab1(user) {
//   const tab1Container = document.getElementById("tab1-members");
//   const userElement = document.createElement("div");
//   userElement.textContent = user.name;
//   tab1Container.appendChild(userElement);
// }
