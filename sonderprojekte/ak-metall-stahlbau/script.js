const revealElements = document.querySelectorAll(".reveal");

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.12 }
);

revealElements.forEach((element) => observer.observe(element));

document.querySelectorAll("[data-live-form]").forEach((form) => {
  form.addEventListener("submit", (event) => {
    const button = form.querySelector("button[type='submit']");

    if (button) {
      button.textContent = "Anfrage wird gesendet...";
      button.disabled = true;
    }
  });
});

document.querySelectorAll("[data-tilt]").forEach((element) => {
  element.addEventListener("mousemove", (event) => {
    const rect = element.getBoundingClientRect();
    const x = (event.clientX - rect.left) / rect.width;
    const y = (event.clientY - rect.top) / rect.height;
    const rotateY = (x - 0.5) * 10;
    const rotateX = (0.5 - y) * 8;
    element.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-4px)`;
  });

  element.addEventListener("mouseleave", () => {
    element.style.transform = "";
  });
});
