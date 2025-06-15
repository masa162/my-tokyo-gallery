document.addEventListener("DOMContentLoaded", () => {
  // ボタンを押すと対象ブロックをトグル
  document.querySelectorAll(".toggle-btn").forEach(btn => {
    btn.addEventListener("click", () => {
      const target = document.getElementById(btn.dataset.target);
      if (target) target.classList.toggle("open");
    });
  });

  /* --- 追加：ページ読み込み時に最新年＆月を自動で開く --- */
  // 年ブロックの最初のボタン（＝最新年）
  const firstYearBtn = document.querySelector(".year-block .toggle-btn");
  if (firstYearBtn) firstYearBtn.click();

  // その年ブロック内の最初の月ボタン（＝最新月）
  const firstMonthBtn = document.querySelector(".year-block .month-block .toggle-btn");
  if (firstMonthBtn) firstMonthBtn.click();
});
