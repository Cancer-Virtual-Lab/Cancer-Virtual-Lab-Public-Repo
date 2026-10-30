// Theme switch: toggles light/dark and remembers the choice (the system theme applies until then)
(() => {
  const root = document.documentElement;
  const button = document.querySelector(".theme-toggle");
  if (!button) return;
  const current = () => root.dataset.theme
    || (matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light");
  const label = () => button.setAttribute("aria-label",
    current() === "dark" ? "Switch to light theme" : "Switch to dark theme");
  label();
  button.addEventListener("click", () => {
    const next = current() === "dark" ? "light" : "dark";
    root.dataset.theme = next;
    try { localStorage.setItem("cvl-theme", next); } catch { /* storage unavailable: theme lasts for this page */ }
    label();
  });
})();
