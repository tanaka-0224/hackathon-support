document.addEventListener("DOMContentLoaded", () => {
  const hiddenInputPercentages = document.getElementById("percentages");
  if (!hiddenInputPercentages) return;
  const taskPercentages = JSON.parse(hiddenInputPercentages.value);

  const sliderContainer = document.querySelector(".multi-slider-container");
  const track = document.createElement("div");
  track.classList.add("slider-track");
  sliderContainer.appendChild(track);

  const output = document.querySelector(".output");

  // 色を区間ごとに設定
  // const sectionColors = ["#ff0000", "#00ff00", "#0000ff", "#ffa500"]; // 必要に応じて追加

  // 累積計算によるハンドルの位置決定
  const handlePositions = [];
  let accumulatedPercentage = 0;

  taskPercentages.forEach((percentage) => {
    accumulatedPercentage += percentage;
    handlePositions.push(Math.min(accumulatedPercentage, 100)); // 累積して100%を超えないようにする
  });

  const updateTrack = () => {
    if (handlePositions.length < 2) return;

    // 既存の区間を削除
    const existingSections = document.querySelectorAll(".slider-section");
    existingSections.forEach((section) => section.remove());

    const sections = [];

    // 各区間を計算
    for (let i = 0; i < handlePositions.length - 1; i++) {
      const sectionStart = handlePositions[i];
      const sectionEnd = handlePositions[i + 1];
      sections.push({ start: sectionStart, end: sectionEnd });
    }

    const generateColors = (count) => {
      const colors = [];
      for (let i = 0; i < count; i++) {
        const hue = (360 / count) * i; // 色相を均等に分割
        colors.push(`hsl(${hue}, 70%, 50%)`); // 彩度70%、輝度50%を固定
      }
      return colors;
    };

    // 使用例
    const sectionColors = generateColors(handlePositions.length - 1);

    // 区間ごとに色を設定
    sections.forEach((section, index) => {
      const sectionElement = document.createElement("div");
      sectionElement.classList.add("slider-section");
      sectionElement.style.left = `${section.start}%`;
      sectionElement.style.width = `${section.end - section.start}%`;
      sectionElement.style.backgroundColor =
        sectionColors[index % sectionColors.length];
      sliderContainer.appendChild(sectionElement);
    });
  };

  const createHandle = (position, index) => {
    const handle = document.createElement("div");
    handle.classList.add("handle");
    handle.style.left = `${position}%`;
    sliderContainer.appendChild(handle);

    let isDragging = false;

    const onMouseMove = (e) => {
      if (!isDragging) return;
      const rect = sliderContainer.getBoundingClientRect();
      let newPosition = ((e.clientX - rect.left) / rect.width) * 100;

      // ハンドルの範囲制限
      if (index > 0) {
        newPosition = Math.max(handlePositions[index - 1], newPosition); // 前のハンドル以上
      }
      if (index < handlePositions.length - 1) {
        newPosition = Math.min(handlePositions[index + 1], newPosition); // 次のハンドル以下
      }
      newPosition = Math.max(0, Math.min(100, newPosition));

      handle.style.left = `${newPosition}%`;
      handlePositions[index] = newPosition; // 更新

      updateTrack(); // トラックの更新
    };

    const onMouseUp = () => {
      isDragging = false;
      document.removeEventListener("mousemove", onMouseMove);
      document.removeEventListener("mouseup", onMouseUp);
    };

    handle.addEventListener("mousedown", () => {
      isDragging = true;
      document.addEventListener("mousemove", onMouseMove);
      document.addEventListener("mouseup", onMouseUp);
    });
  };

  const createMemoryMarks = () => {
    const memoryContainer = document.createElement("div");
    memoryContainer.classList.add("memory-container");
    sliderContainer.appendChild(memoryContainer);

    for (let i = 0; i <= 100; i += 10) {
      // メモリの小さなマーク
      const memory = document.createElement("div");
      memory.classList.add("memory-mark");
      memory.style.left = `${i}%`;
      memoryContainer.appendChild(memory);

      // メモリラベル
      const label = document.createElement("span");
      label.classList.add("memory-label");
      label.style.left = `${i}%`;
      label.textContent = i;
      memoryContainer.appendChild(label);
    }
  };

  // ハンドルの作成
  handlePositions.forEach((position, index) => {
    createHandle(position, index);
  });

  // メモリとラベルを作成
  createMemoryMarks();

  // 色分けを更新
  updateTrack();
});
