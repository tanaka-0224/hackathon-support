document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("skills-form");

  if (form) {
    form.addEventListener("ajax:success", (event) => {
      const [data, status, xhr] = event.detail;
      const messageDiv = document.getElementById("skills-message");

      // 成功メッセージの表示
      messageDiv.innerHTML = `<p style="color: green;">${data.message}</p>`;
    });

    form.addEventListener("ajax:error", (event) => {
      const [data, status, xhr] = event.detail;
      const messageDiv = document.getElementById("skills-message");

      // エラーメッセージの表示
      messageDiv.innerHTML = `<p style="color: red;">${data.message}</p>`;
    });
  }
});
