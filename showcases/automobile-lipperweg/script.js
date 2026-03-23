const STOCK_URL = "./data/stock.json";
const MOBILE_PROFILE = "https://home.mobile.de/AUTOMOBILELIPPERWEGMARL";

const STOCK_DATA = [
  {
    id: "golf-sportsvan",
    brand: "Volkswagen",
    title: "Volkswagen Golf Sportsvan VII Highline 1.4 | ACC | Pano | Bi-Xeno",
    price: 12500,
    mileage: "151.000 km",
    firstRegistration: "12/2015",
    power: "92 kW (125 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Unfallfrei",
    image: "https://img.classistatic.de/api/v1/mo-prod/images/c8/c8233576-bb4c-448d-b605-a20ced4bb292?rule=mo-1600",
    description:
      "Komfortabler Kompaktvan mit Highline-Ausstattung, Panoramadach und klarer mobile.de-Präsenz. Ideal als vielseitiges Familienfahrzeug mit hochwertiger Anmutung.",
  },
  {
    id: "beetle-sport",
    brand: "Volkswagen",
    title: "Volkswagen Beetle Sport 2.0 | Bi-Xenon | Fender | TurboBlack | 8x",
    price: 11499,
    mileage: "137.000 km",
    firstRegistration: "04/2013",
    power: "147 kW (200 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Unfallfrei",
    image: "https://img.classistatic.de/api/v1/mo-prod/images/1c/1c0b8a31-11b7-413a-9e09-35bb07fdc71c?rule=mo-1600",
    description:
      "Charakterstarker Beetle Sport mit starken Ausstattungsdetails und emotionalem Auftritt. Perfekt für eine aufmerksamkeitsstarke Händlerpräsentation.",
  },
  {
    id: "hyundai-veloster",
    brand: "Hyundai",
    title: "Hyundai Veloster Style 1.6 | CarPlay | AndroidAuto | 8xbereift",
    price: 7299,
    mileage: "124.000 km",
    firstRegistration: "12/2012",
    power: "103 kW (140 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "TÜV und Service neu",
    image: "https://img.classistatic.de/api/v1/mo-prod/images/47/4712ea86-222c-4ff1-8abe-67dba2495d42?rule=mo-1600",
    description:
      "Auffälliger, moderner Einstieg in die Bestandslogik mit Android Auto, CarPlay und frischem Servicepaket.",
  },
  {
    id: "mazda-2",
    brand: "Mazda",
    title: "Mazda 2 Lim. Kizoku 1.5 | LED | Lane | DAB | Tempomat | 8Fach",
    price: 12999,
    mileage: "45.000 km",
    firstRegistration: "09/2017",
    power: "66 kW (90 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Unfallfrei",
    image: "https://img.classistatic.de/api/v1/mo-prod/images/11/11e8d345-7828-4211-8088-26161d8befd8?rule=mo-1600",
    description:
      "Sehr gepflegter Kleinwagen mit niedriger Laufleistung und starker Ausstattung. Ideal für einen wertigen Bestands-Hotspot.",
  },
  {
    id: "renault-clio",
    brand: "Renault",
    title: "Renault Clio 1.2 16V 75 Life | DAB | Bluetooth | Allwetter",
    price: 5499,
    mileage: "133.000 km",
    firstRegistration: "11/2016",
    power: "54 kW (73 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "HU neu",
    image: "https://img.classistatic.de/api/v1/mo-prod/images/b2/b239aacd-a6c2-4955-8f53-d94e4108cfd7?rule=mo-1600",
    description:
      "Preislich zugänglicher, sauber präsentierter Kleinwagen mit klarer Alltagsorientierung und guter Vertrauenswirkung.",
  },
  {
    id: "bmw-320i",
    brand: "BMW",
    title: "BMW 320i Touring | LPG | AHK | Panorama",
    price: 1799,
    mileage: "209.000 km",
    firstRegistration: "09/2006",
    power: "110 kW (150 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Preis-Einstieg",
    image: "https://img.classistatic.de/api/v1/mo-prod/images/88/881a10d2-bfe8-4a33-b8c0-b876dcac4fa3?rule=mo-1600",
    description:
      "Günstiger Touring als Bestandsbeispiel für Reichweite und Vielfalt im Händlerportfolio.",
  },
  {
    id: "vw-lupo",
    brand: "Volkswagen",
    title: "Volkswagen Lupo 1.0 Cambridge | Panorama | CarPlay | AndroidAuto",
    price: 1999,
    mileage: "232.000 km",
    firstRegistration: "03/2002",
    power: "37 kW (50 PS)",
    fuel: "Benzin",
    transmission: "Schaltgetriebe",
    badge: "Kompakt",
    image: "https://img.classistatic.de/api/v1/mo-prod/images/cd/cdf12e99-b722-4711-a765-fcfa54ce8339?rule=mo-1600",
    description:
      "Kompakter Einstieg mit moderner Connectivity und starkem Preisanker für die Website-Inszenierung.",
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
      <p class="vehicle-kicker">High-Signal Inventory</p>
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
