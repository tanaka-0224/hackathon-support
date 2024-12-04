// app/javascript/controllers/product_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["name", "description", "bar"];

  connect() {
    this.productId = this.element.dataset.productId;
  }

  // プロダクト名・概要の編集
  updateField(event) {
    const field = event.target
      .getAttribute("data-product-target")
      .replace("Target", "");
    const value = event.target.textContent;

    this.saveChanges({ [field]: value });
  }

  // スケジュールバーのドラッグ操作
  dragBar(event) {
    const bar = event.target;
    const rect = bar.parentElement.getBoundingClientRect();
    const newWidth = ((event.clientX - rect.left) / rect.width) * 100;

    // 値を範囲内に制限
    const percentage = Math.min(Math.max(newWidth, 0), 100);

    bar.style.width = `${percentage}%`;
    this.saveChanges({ schedule: { [bar.dataset.task]: percentage } });
  }

  // データをバックエンドに送信
  saveChanges(data) {
    fetch(`/products/${this.productId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: JSON.stringify({ product: data }),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "error") {
          alert("更新に失敗しました: " + data.errors.join(", "));
        }
      });
  }
}
