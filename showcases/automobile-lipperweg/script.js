const STOCK_URL = "./data/stock.json";
const MOBILE_PROFILE = "https://home.mobile.de/AUTOMOBILELIPPERWEGMARL";

const state = {
  stock: [],
  filter: "all",
};

function initHeroIntro() {
  document.body.classList.add("is-intro-active");

  window.setTimeout(() => {
    document.body.classList.add("is-intro-complete");
  }, 650);

  window.setTimeout(() => {
    document.body.classList.remove("is-intro-active");
  }, 1800);
}

function initHeroParallax() {
  const stage = document.querySelector("[data-hero-stage]");
  if (!stage || window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

  const targets = stage.querySelectorAll("[data-parallax]");

  stage.addEventListener("mousemove", (event) => {
    const bounds = stage.getBoundingClientRect();
    const offsetX = (event.clientX - bounds.left) / bounds.width - 0.5;
    const offsetY = (event.clientY - bounds.top) / bounds.height - 0.5;

    targets.forEach((target) => {
      const factor = Number(target.dataset.parallax || 0.08);
      const translateX = offsetX * 28 * factor * 10;
      const translateY = offsetY * 18 * factor * 10;
      target.style.transform = `translate3d(${translateX}px, ${translateY}px, 0)`;
    });
  });

  stage.addEventListener("mouseleave", () => {
    targets.forEach((target) => {
      target.style.transform = "";
    });
  });
}

function formatPrice(value) {
  return new Intl.NumberFormat("de-DE", {
    style: "currency",
    currency: "EUR",
    maximumFractionDigits: 0,
  }).format(value);
}

function createVehicleCard(vehicle) {
  const card = document.createElement("article");
  card.className = "vehicle-card reveal";
  card.dataset.brand = vehicle.brand;

  card.innerHTML = `
    <div class="vehicle-media">
      <img src="${vehicle.image}" alt="${vehicle.title}" loading="lazy" />
      <div class="vehicle-badges">
        <span class="vehicle-badge">${vehicle.brand}</span>
        <span class="vehicle-badge">${vehicle.badge}</span>
      </div>
    </div>
    <div class="vehicle-body">
      <h3>${vehicle.title}</h3>
      <p class="vehicle-price">${formatPrice(vehicle.price)}</p>
      <dl class="vehicle-specs">
        <div><dt>EZ</dt><dd>${vehicle.firstRegistration}</dd></div>
        <div><dt>KM</dt><dd>${vehicle.mileage}</dd></div>
        <div><dt>Leistung</dt><dd>${vehicle.power}</dd></div>
        <div><dt>Kraftstoff</dt><dd>${vehicle.fuel}</dd></div>
      </dl>
      <div class="vehicle-actions">
        <button class="button button-primary" type="button" data-open-modal>Details</button>
        <a class="button button-secondary" href="${MOBILE_PROFILE}" target="_blank" rel="noreferrer">mobile.de</a>
      </div>
    </div>
  `;

  card.querySelector("[data-open-modal]").addEventListener("click", () => openModal(vehicle));

  return card;
}

function renderStock(target, limit = null) {
  if (!target) return;
  const items = state.stock.filter((item) => state.filter === "all" || item.brand === state.filter);
  const visible = limit ? items.slice(0, limit) : items;
  target.innerHTML = "";
  visible.forEach((vehicle, index) => {
    const card = createVehicleCard(vehicle);
    card.style.transitionDelay = `${index * 60}ms`;
    target.appendChild(card);
  });
  observeReveals();
}

function openModal(vehicle) {
  const dialog = document.querySelector("[data-modal]");
  if (!dialog) return;

  dialog.querySelector("[data-modal-image]").src = vehicle.image;
  dialog.querySelector("[data-modal-image]").alt = vehicle.title;
  dialog.querySelector("[data-modal-brand]").textContent = vehicle.brand;
  dialog.querySelector("[data-modal-title]").textContent = vehicle.title;
  dialog.querySelector("[data-modal-price]").textContent = formatPrice(vehicle.price);
  dialog.querySelector("[data-modal-description]").textContent = vehicle.description;

  const specs = dialog.querySelector("[data-modal-specs]");
  specs.innerHTML = `
    <div><dt>EZ</dt><dd>${vehicle.firstRegistration}</dd></div>
    <div><dt>KM</dt><dd>${vehicle.mileage}</dd></div>
    <div><dt>Leistung</dt><dd>${vehicle.power}</dd></div>
    <div><dt>Getriebe</dt><dd>${vehicle.transmission}</dd></div>
    <div><dt>Kraftstoff</dt><dd>${vehicle.fuel}</dd></div>
    <div><dt>Status</dt><dd>${vehicle.badge}</dd></div>
  `;

  if (typeof dialog.showModal === "function") {
    dialog.showModal();
  } else {
    dialog.setAttribute("open", "open");
  }
}

function closeModal() {
  const dialog = document.querySelector("[data-modal]");
  if (!dialog) return;
  dialog.close?.();
  dialog.removeAttribute("open");
}

function observeReveals() {
  const elements = document.querySelectorAll(".reveal:not(.is-visible)");
  if (!("IntersectionObserver" in window)) {
    elements.forEach((element) => element.classList.add("is-visible"));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.14 }
  );

  elements.forEach((element) => observer.observe(element));
}

function initFilters() {
  const bar = document.querySelector("[data-filter-bar]");
  if (!bar) return;

  bar.addEventListener("click", (event) => {
    const button = event.target.closest("[data-filter]");
    if (!button) return;

    state.filter = button.dataset.filter;
    bar.querySelectorAll(".filter-chip").forEach((chip) => chip.classList.remove("is-active"));
    button.classList.add("is-active");

    renderAll();
  });
}

function renderAll() {
  renderStock(document.querySelector("[data-stock-preview]"), 4);
  renderStock(document.querySelector("[data-stock-grid]"));
}

async function boot() {
  initHeroIntro();
  initHeroParallax();

  try {
    const response = await fetch(STOCK_URL);
    state.stock = await response.json();
  } catch (error) {
    console.warn("Stock konnte nicht geladen werden:", error);
    state.stock = [];
  }

  renderAll();
  initFilters();
  observeReveals();

  document.querySelectorAll("[data-close-modal]").forEach((button) => {
    button.addEventListener("click", closeModal);
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeModal();
  });

  const modal = document.querySelector("[data-modal]");
  modal?.addEventListener("click", (event) => {
    if (event.target === modal) closeModal();
  });
}

boot();
