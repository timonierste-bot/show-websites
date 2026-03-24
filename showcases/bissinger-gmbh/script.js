const navToggle = document.querySelector("[data-nav-toggle]");
const nav = document.querySelector("[data-nav]");

if (navToggle && nav) {
  navToggle.addEventListener("click", () => {
    nav.classList.toggle("open");
  });

  nav.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      nav.classList.remove("open");
    });
  });
}

const revealItems = document.querySelectorAll("[data-reveal]");
const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

if (!reducedMotion && "IntersectionObserver" in window) {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.18 }
  );

  revealItems.forEach((item) => observer.observe(item));
} else {
  revealItems.forEach((item) => item.classList.add("is-visible"));
}

const shineTargets = document.querySelectorAll("[data-shine]");

shineTargets.forEach((target) => {
  const resetShine = () => {
    target.style.setProperty("--shine-x", "50%");
    target.style.setProperty("--shine-y", "36%");
  };

  resetShine();

  target.addEventListener("pointermove", (event) => {
    const rect = target.getBoundingClientRect();
    const x = ((event.clientX - rect.left) / rect.width) * 100;
    const y = ((event.clientY - rect.top) / rect.height) * 100;
    target.style.setProperty("--shine-x", `${Math.max(0, Math.min(100, x))}%`);
    target.style.setProperty("--shine-y", `${Math.max(0, Math.min(100, y))}%`);
  });

  target.addEventListener("pointerleave", resetShine);
});
