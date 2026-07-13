// Presentation: Паралелно генерисање фракталних стабала
// Ana Poparić, SV 74/2021, FTN Novi Sad

#import "metadata.typ": naslov, autor, mentor, studijski_program, indeks

#set text(lang: "sr", font: "Liberation Serif")
#set page(
  width: 33.87cm,
  height: 19.05cm,
  margin: (x: 1.8cm, y: 1.4cm),
  fill: white,
  numbering: none,
)

// ── Боје ──────────────────────────────────────────────────────────────────────
#let zelena    = rgb("#166534")
#let svetlozelena = rgb("#c8e6c9")
#let menta = rgb("#ecf7ed")
#let zelena    = rgb("#166534")
#let svetloljubicasta = rgb("#f1ecf7")
#let srednjeljubicasta = rgb("#9e84c6")
#let ljubicasta = rgb("#4c1d95")
#let svetlo    = rgb("#e8f0f9")
#let siva      = rgb("#6b7280")

// ── Помоћне функције ──────────────────────────────────────────────────────────

// Наслов слајда
#let slide-title(t) = {
  rect(
    fill: svetlozelena, width: 100%, height: 1.5cm, radius: (top-left: 6pt, top-right: 6pt),
    inset: (x: 1cm, y: 0pt),
    align(left + horizon, text(fill: black, size: 22pt, weight: "bold", t))
  )
  v(0.4cm)
}

// Тело слајда (простор испод наслова)
#let slide(title: none, body) = {
  if title != none { slide-title(title) }
  body
  pagebreak(weak: true)
}

// Кутија за колону
#let box-col(fill: svetlo, height: auto, body) = rect(
  fill: fill, radius: 5pt, inset: 1cm, width: 100%, height: height, body
)

// Стрелица → за дијаграм
#let arrow = text(size: 20pt, weight: "bold", "→")


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 1 — НАСЛОВ
// ════════════════════════════════════════════════════════════════════════════
#slide[
  #grid(
    columns: (1fr, 1fr),
    gutter: 1cm,
    // Лево: текст
    align(left + horizon)[
      #v(0.5cm)
      #text(fill: black, size: 14pt, weight: "bold")[Факултет техничких наука · Нови Сад]
      #v(0.4cm)
      #text(fill: black, size: 21pt, weight: "bold", naslov)
      #v(0.6cm)
      #line(length: 80%, stroke: 2pt + black)
      #v(0.4cm)
      #text(size: 14pt)[#autor · #indeks]
      #v(0.2cm)
      #text(size: 13pt, fill: siva)[Ментор: проф. #mentor]
      #v(0.2cm)
      #text(size: 13pt, fill: siva)[#studijski_program]
      #v(0.2cm)
      #text(size: 13pt, fill: siva)[#datetime.today().year()]
    ],
    // Десно: слика
    align(center + horizon,
      image("slike/fractal-tree.png", width: 90%)
    ),
  )
]


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 2 — ФРАКТАЛНО СТАБЛО — ПРОБЛЕМ И МОТИВАЦИЈА
// ════════════════════════════════════════════════════════════════════════════
#slide(title: "Фрактално стабло — проблем и мотивација")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2cm,
    align(center + horizon,
      image("slike/fractals-in-nature.png", width: 95%)
    ),
    align(left + horizon)[
      #v(0.3cm)
      // НАПОМЕНА (рећи усмено, не приказивати на слајду):
      // Свака грана рекурзивно генерише две подгране скалиране фактором r.
      // Тиме је свако подстабло, по конструкцији, идентично целом стаблу.
      #text(size: 15pt, fill: black)[
        - Самосличност — свако подстабло је умањена копија целог стабла\
        - Рачунски интензиван (_CPU-bound_) задатак\
        - Python — једноставност\
        - Rust — перформансе
      ]
      #v(0.6cm)
      // НАПОМЕНА (рећи усмено, не приказивати на слајду):
      // Време извршавања при N = 1 (секвенцијално).
      #grid(
        columns: (1fr, 1fr),
        gutter: 0.8cm,
        [
          #text(size: 15pt, weight: "bold")[Симетрично стабло]
          #v(0.3cm)
          #{
            set text(size: 15pt)
            table(
              columns: (1fr, 1fr),
              align: left,
              inset: 8pt,
              fill: white,
              [$l_"min"$], [0.01],
              [Број грана], [8 388 607],
              [Python (N=1)], [*8,0 s*],
              [Rust (N=1)],   [*0,20 s*],
            )
          }
        ],
        [
          #text(size: 15pt, weight: "bold")[Асиметрично стабло]
          #v(0.3cm)
          #{
            set text(size: 15pt)
            table(
              columns: (1fr, 1fr),
              align: left,
              inset: 8pt,
              fill: white,
              [$l_"min"$], [0.0023],
              [Број грана], [8 464 173],
              [Python (N=1)], [*8,2 s*],
              [Rust (N=1)],   [*0,25 s*],
            )
          }
        ],
      )
    ],
  )
]


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 3 — СИМЕТРИЧНО VS АСИМЕТРИЧНО + SPLIT_DEPTH
// ════════════════════════════════════════════════════════════════════════════
#slide(title: "Типови стабла и стратегија паралелизације")[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.8cm,
    // Симетрично
    align(center)[
      #image("slike/simetricno-stablo.png", width: 88%)
      #v(0.2cm)
      #text(size: 15pt)[Симетрично]
      #v(0.2cm)
      #text(size: 15pt)[$r_l = r_d = 0.67$]
    ],
    // Асиметрично
    align(center)[
      #image("slike/asimetricno-stablo.png", width: 88%)
      #v(0.2cm)
      #text(size: 15pt)[Асиметрично]
      #v(0.2cm)
      #text(size: 15pt)[$r_l = 0.67,\ r_d = 0.57$]
    ],
    // split_depth
    align(left + horizon)[
      #box-col(fill: menta)[
        // НАПОМЕНА (рећи усмено, не приказивати на слајду):
        // Стабло се генерише секвенцијално до дубине split_depth, након чега се подстабла
        // испод те дубине генеришу паралелно и независно, без дељеног стања.
        #text(size: 15pt)[
          - split_depth $= ceil(log_2(N times 4))$
          #v(0.3cm)
          - Фактор 4 → _oversubscription_
        ]
      ]
    ],
  )
]


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 4 — PYTHON VS RUST: МЕХАНИЗМИ
// ════════════════════════════════════════════════════════════════════════════
#slide(title: "Python и Rust — различити механизми паралелизације")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 1.2cm,
    // Python
    rect(fill: white, radius: 6pt, inset: 1cm, width: 100%)[
      #align(center, text(size: 15pt, weight: "bold")[Python])
      #v(0.5cm)
      #align(center, text(size: 15pt)[GIL → паралелизација *процесима*])
      #v(0.3cm)
      #align(center, text(size: 15pt)[`Pool(processes=N)` + `pool.map`])
      #v(0.3cm)
      #align(center, text(size: 15pt)[`spawn`: нов интерпретер по процесу])
      #v(0.2cm)
      #align(center, text(size: 15pt)[`pickle`: серијализација])
      #v(0.2cm)
      #align(center, text(size: 15pt)[Статичка расподела])
    ],
    // Rust
    rect(fill: white, radius: 6pt, inset: 1cm, width: 100%)[
      #align(center, text(size: 15pt, weight: "bold")[Rust])
      #v(0.5cm)
      #align(center, text(size: 15pt)[Ownership → паралелизација *нитима*])
      #v(0.3cm)
      #align(center, text(size: 15pt)[`rayon::ThreadPool` + `par_iter()`])
      #v(0.3cm)
      #align(center, text(size: 15pt)[Нити деле меморијски простор])
      #v(0.2cm)
      #align(center, text(size: 15pt)[Без серијализације])
      #v(0.2cm)
      #align(center, text(size: 15pt)[*Крађа посла* (work-stealing)])
    ],
  )
  #v(0.5cm)
  #align(center)[
    #{
      set text(size: 15pt)
      table(
        columns: (auto, auto, auto, auto),
        align: center,
        inset: 8pt,
        fill: white,
        stroke: 0.5pt + siva,
        [*Процесор*], [*Језгра (физ./лог.)*], [*Меморија*], [*ОС*],
        [Intel Core i5-1035G1], [4 / 8 (Hyper-Threading)], [8 GB DDR4], [Windows 11 Pro],
      )
    }
  ]
]


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 5 — АМДАЛОВ И ГУСТАФСОНОВ ЗАКОН
// ════════════════════════════════════════════════════════════════════════════
#slide(title: "Теоријски оквир: Амдалов и Густафсонов закон")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 1cm,
    align(center + horizon,
      image("slike/amdalov-zakon.png", width: 95%)
    ),
    align(center + horizon,
      image("slike/gustafson-zakon.png", width: 97%)
    ),
  )
  #v(0.2cm)
  #grid(
    columns: (1fr, 1fr),
    gutter: 1cm,
    align(center)[
      #text(size: 15pt)[*Јако скалирање* — фиксан проблем]
      #{ set text(size: 15pt); $ S_max = frac(1, f + frac(1 - f, N)) $ }
    ],
    align(center)[
      #text(size: 15pt)[*Слабо скалирање* — растући проблем]
      #{ set text(size: 15pt); $ S_"scaled" = N + (1 - N) times f $ }
    ],
  )
]


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 6 — ЈАКО СКАЛИРАЊЕ: АСИМЕТРИЧНО СТАБЛО
// ════════════════════════════════════════════════════════════════════════════
#slide(title: "Јако скалирање — асиметрично стабло")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8cm,
    align(center + horizon,
      image("slike/asymmetric-strong-python.png", width: 98%)
    ),
    align(center + horizon,
      image("slike/asymmetric-strong-rust.png", width: 98%)
    ),
  )
  #v(0.2cm)
  #grid(
    columns: (1fr, 1fr),
    gutter: 0.8cm,
    align(center)[
      #text(size: 15pt, weight: "bold")[Python]
      #v(0.2cm)
      #text(size: 15pt)[Стагнација при $N=4$ — статичка расподела, неједнака подстабла]
    ],
    align(center)[
      #text(size: 15pt, weight: "bold")[Rust]
      #v(0.2cm)
      #text(size: 15pt)[$S=3.355 approx$ Амдал $3.361$ — крађа посла надокнађује асиметрију]
    ],
  )
]


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 7 — ДИЈАГРАМ: ЗАШТО PYTHON НЕ СКАЛИРА?
// ════════════════════════════════════════════════════════════════════════════
#slide(title: "Зашто Python не скалира? — spawn + pickle overhead")[
  #v(1fr)

  #let ohead(t, sub: none, heavy: false) = rect(
    fill: if heavy { rgb("#ddd0f0") } else { svetloljubicasta },
    stroke: if heavy { 2.5pt + ljubicasta } else { 1.5pt + srednjeljubicasta },
    radius: 5pt, inset: (x: 10pt, y: 14pt), width: 100%,
    align(center)[
      #text(size: 16pt, weight: "bold", fill: ljubicasta, t)
      #if sub != none { linebreak(); text(size: 13pt, fill: siva, sub) }
    ]
  )
  #let korisno(t, sub: none) = rect(
    fill: menta, stroke: 1.5pt + zelena, radius: 5pt,
    inset: (x: 10pt, y: 14pt), width: 100%,
    align(center)[
      #text(size: 16pt, weight: "bold", fill: zelena, t)
      #if sub != none { linebreak(); text(size: 13pt, fill: siva, sub) }
    ]
  )
  #let arr = pad(x: 0.3cm, text(size: 22pt, fill: siva, "→"))

  // Ред 1: spawn → pickle задатака → unpickle задатака
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr),
    gutter: 0pt,
    align(center + horizon, ohead("spawn × N", sub: [нови интерпретери, учитавање libs])),
    align(center + horizon, arr),
    align(center + horizon, ohead("pickle задатака", sub: [серијализација задатака])),
    align(center + horizon, arr),
    align(center + horizon, ohead("unpickle задатака", sub: [десеријализација у worker-у])),
    align(center, pad(top: 0.1cm, text(size: 12pt, style: "italic", tracking: 0.8pt, fill: srednjeljubicasta)[overhead])),
    [],
    align(center, pad(top: 0.1cm, text(size: 12pt, style: "italic", tracking: 0.8pt, fill: srednjeljubicasta)[overhead])),
    [],
    align(center, pad(top: 0.1cm, text(size: 12pt, style: "italic", tracking: 0.8pt, fill: srednjeljubicasta)[overhead])),
    [],
    [],
  )
  #v(0.5cm)
  // Ред 2: рачунање → pickle резултата → unpickle резултата
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr),
    gutter: 0pt,
    align(center + horizon, korisno("рачунање", sub: [генерисање подстабла])),
    align(center + horizon, arr),
    align(center + horizon, ohead("pickle резултата", sub: [NumPy низови — велики], heavy: true)),
    align(center + horizon, arr),
    align(center + horizon, ohead("unpickle резултата", sub: [десеријализација у главном])),
    align(center, pad(top: 0.1cm, text(size: 12pt, weight: "bold", tracking: 0.8pt, fill: zelena)[корисни рад])),
    [],
    align(center, pad(top: 0.1cm, text(size: 12pt, weight: "bold", style: "italic", tracking: 0.8pt, fill: ljubicasta)[overhead])),
    [],
    align(center, pad(top: 0.1cm, text(size: 12pt, style: "italic", tracking: 0.8pt, fill: srednjeljubicasta)[overhead])),
    [],
    [],
  )

  #v(1cm)
  #align(center)[
    #box(width: 24cm)[
      #grid(
        columns: (auto, 1fr),
        gutter: 1.2cm,
        align(horizon)[
          #{
            set text(size: 18pt)
            table(
              columns: (auto, auto),
              align: left,
              inset: 12pt,
              fill: white,
              [*$N$*], [*$T(N)$ (s)*],
              [4], [3,872],
              [8], [*4,294*],
            )
          }
        ],
        align(horizon)[
          #text(size: 15pt)[
            - *$N=8$ спорији од $N=4$* — _overhead_ надмашује корист
            #v(0.3cm)
            - $N=8$ → 8 нових интерпретера + 8 десеријализација
            #v(0.3cm)
            - Rust: дељена меморија → _overhead_ занемарљив
          ]
        ],
      )
    ]
  ]
  #v(1fr)
]


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 8 — ЗАКЉУЧАК
// ════════════════════════════════════════════════════════════════════════════
#slide(title: "Закључак")[
  #grid(
    columns: (1.1fr, 0.9fr),
    gutter: 1.2cm,
    // Главни налази
    [
      #text(size: 16pt, fill: black)[Главни налази]
      #v(0.3cm)
      #box-col(fill: menta)[
        #text(size: 15pt)[
          1. Механизам паралелизације је одлучујући\
          #v(0.3cm)
          2. `split_depth` стратегија\
          #v(0.3cm)
          3. _Hyper-Threading_
        ]
      ]
      // НАПОМЕНА (рећи усмено, не приказивати на слајду):
      // 1. ...— нити (Rust) скалирају, процеси (Python) не за CPU-bound задатке на Windows-у.
      // 2. ...је исправна за обе конфигурације стабла.
      // 3. ...ограничава скалирање обе имплементације при N=8 — 4 физичка језгра, не 8.
    ],
    // Сумарна табела
    [
      #text(size: 16pt, fill: black)[Убрзање при $N=8$]
      #v(0.3cm)
      #{
        set text(size: 15pt)
        table(
          columns: (1fr, 1fr, 1fr),
          align: center,
          inset: 10pt,
          stroke: 0.5pt + siva,
          [*$N=8$*], [*Python*], [*Rust*],
          [Симетрично ($S$)], [1.853], [*3.244*],
          [Асиметрично ($S$)], [1.741], [*3.355*],
          [Сим. ($S_"scaled"$)], [1.045], [*3.168*],
          [Асим. ($S_"scaled"$)], [1.154], [*3.878*],
        )
      }
    ],
  )
  #v(0.2cm)
  #text(size: 15pt, fill: black, weight: "bold")[Даљи рад:]
  #v(0.1cm)
  #text(size: 15pt, fill: black)[
    - `shared_memory` уместо `pickle`\
    - `fork` метода (Linux)\
    - Платформа без _Hyper-Threading_
  ]
]


// ════════════════════════════════════════════════════════════════════════════
// СЛАЈД 9 — ХВАЛА НА ПАЖЊИ
// ════════════════════════════════════════════════════════════════════════════
#slide(title: "Хвала на пажњи")[
  #v(1fr)
  #align(center, text(size: 28pt, weight: "bold")[Питања?])
  #v(1fr)
]
