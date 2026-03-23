const STOCK_URL = "./data/stock.json";
const MOBILE_PROFILE = "./kontakt.html";

const STOCK_DATA = [
  {
    id: "konzept-01",
    brand: "Volkswagen",
    title: "Volkswagen Konzeptfahrzeug 01 | Komfortpaket | Panorama",
    price: 12500,
    mileage: "151.000 km",
    firstRegistration: "12/2015",
    power: "92 kW (125 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Konzept",
    image: "./images/preview-stock.svg",
    description:
      "Beispiel für einen komfortablen Kompaktvan mit ruhiger Präsentation und klarer Bestandslogik.",
  },
  {
    id: "konzept-02",
    brand: "Volkswagen",
    title: "Volkswagen Konzeptfahrzeug 02 | Sport & Styling",
    price: 11499,
    mileage: "137.000 km",
    firstRegistration: "04/2013",
    power: "147 kW (200 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Beispiel",
    image: "./images/preview-stock.svg",
    description:
      "Emotionales Konzeptfahrzeug mit auffälliger Silhouette und klarer Händlerpräsentation.",
  },
  {
    id: "konzept-03",
    brand: "Hyundai",
    title: "Hyundai Konzeptfahrzeug 03 | Connectivity",
    price: 7299,
    mileage: "124.000 km",
    firstRegistration: "12/2012",
    power: "103 kW (140 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Ausstattung",
    image: "./images/preview-stock.svg",
    description:
      "Moderner Einstieg in die Bestandslogik mit klarer Bedienung und konzentrierter Präsentation.",
  },
  {
    id: "konzept-04",
    brand: "Mazda",
    title: "Mazda Konzeptfahrzeug 04 | Licht & Assistenz",
    price: 12999,
    mileage: "45.000 km",
    firstRegistration: "09/2017",
    power: "66 kW (90 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Kompakt",
    image: "./images/preview-stock.svg",
    description:
      "Kompaktes Beispiel für einen gepflegten Einstieg mit klarer Bestandswirkung.",
  },
  {
    id: "konzept-05",
    brand: "Renault",
    title: "Renault Konzeptfahrzeug 05 | Alltag",
    price: 5499,
    mileage: "133.000 km",
    firstRegistration: "11/2016",
    power: "54 kW (73 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Einstieg",
    image: "./images/preview-stock.svg",
    description:
      "Preislich zugängliches Konzeptfahrzeug mit klarer Alltagsorientierung.",
  },
  {
    id: "konzept-06",
    brand: "BMW",
    title: "BMW Konzeptfahrzeug 06 | Touring",
    price: 1799,
    mileage: "209.000 km",
    firstRegistration: "09/2006",
    power: "110 kW (150 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Portfolio",
    image: "./images/preview-stock.svg",
    description:
      "Touring-Konzept mit Fokus auf Reichweite und Vielfalt im Händlerportfolio.",
  },
  {
    id: "konzept-07",
    brand: "Volkswagen",
    title: "Volkswagen Konzeptfahrzeug 07 | Kompakt",
    price: 1999,
    mileage: "232.000 km",
    firstRegistration: "03/2002",
    power: "37 kW (50 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Einstieg",
    image: "./images/preview-stock.svg",
    description:
      "Kompakter Einstieg mit klarer Präsentation und starkem Preisanker.",
  },
];

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

  const targets = stage.querySelectorAll("[data-depth]");

  stage.addEventListener("mousemove", (event) => {
    const bounds = stage.getBoundingClientRect();
    const offsetX = (event.clientX - bounds.left) / bounds.width - 0.5;
    const offsetY = (event.clientY - bounds.top) / bounds.height - 0.5;

    targets.forEach((target) => {
      const factor = Number(target.dataset.depth || 0.08);
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

function initScrollShift() {
  const update = () => {
    const progress = window.scrollY / Math.max(1, document.documentElement.scrollHeight - window.innerHeight);
    const shift = Math.min(1, Math.max(0, progress)) * 18;
    document.documentElement.style.setProperty("--scroll-shift", `${shift}px`);
  };

  update();
  window.addEventListener("scroll", update, { passive: true });
  window.addEventListener("resize", update);
}

function initSceneRail() {
  const root = document.querySelector("[data-story-rail]");
  const stage = document.querySelector("[data-scene-stage]");
  const steps = [...document.querySelectorAll("[data-scene-step]")];
  const slides = [...document.querySelectorAll("[data-scene-slide]")];

  if (!root || !stage || !steps.length || !slides.length) return;

  const setActive = (key) => {
    stage.dataset.activeScene = key;

    steps.forEach((step) => {
      step.classList.toggle("is-active", step.dataset.sceneStep === key);
    });

    slides.forEach((slide) => {
      slide.classList.toggle("is-active", slide.dataset.sceneSlide === key);
    });
  };

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          setActive(entry.target.dataset.sceneStep);
        }
      });
    },
    {
      rootMargin: "-30% 0px -48% 0px",
      threshold: 0.35,
    }
  );

  steps.forEach((step) => observer.observe(step));

  root.addEventListener("click", (event) => {
    const button = event.target.closest("[data-scene-jump]");
    if (!button) return;

    const next = document.querySelector(`[data-scene-step="${button.dataset.sceneJump}"]`);
    next?.scrollIntoView({ behavior: "smooth", block: "center" });
    setActive(button.dataset.sceneJump);
  });

  setActive(steps[0].dataset.sceneStep);
}

function formatPrice(value) {
  return new Intl.NumberFormat("de-DE", {
    style: "currency",
    currency: "EUR",
    maximumFractionDigits: 0,
  }).format(value);
}

function appendTextElement(parent, tag, text, className = "") {
  const element = document.createElement(tag);
  if (className) element.className = className;
  element.textContent = text;
  parent.appendChild(element);
  return element;
}

function appendSpecRow(parent, label, value) {
  const wrapper = document.createElement("div");
  const dt = document.createElement("dt");
  const dd = document.createElement("dd");
  dt.textContent = label;
  dd.textContent = value;
  wrapper.append(dt, dd);
  parent.appendChild(wrapper);
}

function createVehicleCard(vehicle) {
  const card = document.createElement("article");
  card.className = "vehicle-card reveal";
  card.dataset.brand = vehicle.brand;

  const media = document.createElement("div");
  media.className = "vehicle-media";

  const image = document.createElement("img");
  image.src = vehicle.image;
  image.alt = vehicle.title;
  image.loading = "lazy";
  media.appendChild(image);

  const badges = document.createElement("div");
  badges.className = "vehicle-badges";
  appendTextElement(badges, "span", vehicle.brand, "vehicle-badge");
  appendTextElement(badges, "span", vehicle.badge, "vehicle-badge");
  media.appendChild(badges);

  const body = document.createElement("div");
  body.className = "vehicle-body";
  appendTextElement(body, "p", "High-Signal Inventory", "vehicle-kicker");
  appendTextElement(body, "h3", vehicle.title);
  appendTextElement(body, "p", formatPrice(vehicle.price), "vehicle-price");

  const specs = document.createElement("dl");
  specs.className = "vehicle-specs";
  appendSpecRow(specs, "EZ", vehicle.firstRegistration);
  appendSpecRow(specs, "KM", vehicle.mileage);
  appendSpecRow(specs, "Leistung", vehicle.power);
  appendSpecRow(specs, "Kraftstoff", vehicle.fuel);
  body.appendChild(specs);

  const actions = document.createElement("div");
  actions.className = "vehicle-actions";

  const detailsButton = document.createElement("button");
  detailsButton.className = "button button-primary";
  detailsButton.type = "button";
  detailsButton.dataset.openModal = "";
  detailsButton.textContent = "Details";
  detailsButton.addEventListener("click", () => openModal(vehicle));

  const profileLink = document.createElement("a");
  profileLink.className = "button button-secondary";
  profileLink.href = MOBILE_PROFILE;
  profileLink.target = "_blank";
  profileLink.rel = "noreferrer";
  profileLink.textContent = "Weitere Infos";

  actions.append(detailsButton, profileLink);
  body.appendChild(actions);

  card.append(media, body);

  return card;
}

function renderStock(target, limit = null) {
  if (!target) return;

  const items = state.stock.filter((item) => state.filter === "all" || item.brand === state.filter);
  const visible = limit ? items.slice(0, limit) : items;
  target.replaceChildren();

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
  specs.replaceChildren();
  appendSpecRow(specs, "EZ", vehicle.firstRegistration);
  appendSpecRow(specs, "KM", vehicle.mileage);
  appendSpecRow(specs, "Leistung", vehicle.power);
  appendSpecRow(specs, "Getriebe", vehicle.transmission);
  appendSpecRow(specs, "Kraftstoff", vehicle.fuel);
  appendSpecRow(specs, "Status", vehicle.badge);

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

async function loadStock() {
  try {
    const response = await fetch(STOCK_URL, { cache: "no-store" });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return await response.json();
  } catch (error) {
    console.warn("Stock konnte nicht geladen werden, fallback auf Inline-Daten:", error);
    return STOCK_DATA;
  }
}

function renderAll() {
  renderStock(document.querySelector("[data-stock-preview]"), 4);
  renderStock(document.querySelector("[data-stock-grid]"));
}

async function boot() {
  initHeroIntro();
  initHeroParallax();
  initScrollShift();
  initSceneRail();

  state.stock = await loadStock();
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
