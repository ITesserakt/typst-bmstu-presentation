#import "@preview/touying:0.8.0": *

#let colors = (
  primary-light: oklch(60%, 0.2, 256.5deg),
  primary: oklch(54.7%, 0.184, 256.5deg),
  primary-dark: oklch(41.7%, 0.14, 256.5deg),
  secondary-light: oklch(60%, 0.2, 142deg),
  secondary: oklch(54.7%, 0.184, 142deg),
  secondary-dark: oklch(41.7%, 0.14, 142deg),
  tertiary-light: oklch(60%, 0.2, 20deg),
  tertiary: oklch(54.7%, 0.184, 20deg),
  tertiary-dark: oklch(41.7%, 0.14, 20deg),
  neutral: luma(100%, 100%),
)

#let bmstu-theme(
  aspect-ratio: "16-9",
  ..args,
  body,
) = {
  let preambule(doc) = {
    set text(15pt, font: "Fira Sans", weight: "light", lang: "ru")
    show text.where(weight: "bold"): set text(weight: "light")

    set align(horizon)

    show math.equation: set text(weight: "light", font: "New Computer Modern Math")
    set math.equation(numbering: "(1)")

    show highlight: set text(fill: colors.primary)

    set list(
      marker: (
        text(fill: colors.primary, math.circle.filled),
        text(fill: colors.primary, math.triangle.filled.r),
      ),
      indent: 1em,
    )
    set enum(
      indent: 1em,
      numbering: n => text(fill: colors.primary-dark)[#n.],
    )

    show figure.caption: set text(size: 0.75em)
    show link: set text(fill: colors.tertiary)
    show figure.where(kind: raw): set figure.caption(position: top)
    show figure.where(kind: raw): set figure(supplement: "Исходный код")

    doc
  }

  let slide(title: auto, page_number: true, ..args) = touying-slide-wrapper(self => {
    if title != auto {
      self.store.title = title
    }

    let header(self) = layout(size => {
      set align(bottom + left)
      set text(size: 1.18em)
      show: pad.with(left: self.page.margin.left, right: self.page.margin.right / 2)

      let title_content = if self.store.title != none {
        utils.call-or-display(self, self.store.title)
      } else {
        utils.display-current-heading(level: 1)
      }

      let subtitle_arrow = context if utils.current-heading(level: 2) != none {
        [#h(0.5em) $arrow.curve$ #h(0.5em)]
      } else {
        none
      }
      let subtitle_content = context if utils.current-heading(level: 2) != none {
        set text(size: 0.9em)
        set par(leading: 0.2em)
        set align(left + horizon)
        box(inset: (y: 0.3em), utils.display-current-heading(level: 2))
      } else {
        none
      }
      let max_subtitle_width = (
        size.width
          - 5em.to-absolute()
          - self.page.margin.left
          - self.page.margin.right / 2
          - measure(subtitle_arrow).width
      )
      let subtitle_height = measure(text(1.18em, subtitle_content), width: max_subtitle_width).height

      grid(
        columns: (auto, auto, 4em),
        rows: (auto, subtitle_height, 3pt),
        grid.cell(inset: (y: 0.2em), x: 0, colspan: 2, smallcaps(title_content)),
        grid.cell(align: horizon, x: 0, y: 1, subtitle_arrow),
        grid.cell(x: 1, y: 1, subtitle_content),
        grid.cell(x: 0, colspan: 2, line(stroke: self.colors.primary + 3pt, length: 100%)),
        grid.cell(rowspan: 3, x: 2, image("../assets/Logo_Blue_No-BG.png")),
      )
    })

    let footer(self) = {
      set align(right + top)
      set text(fill: self.colors.primary, size: 0.8em)
      show: pad.with(x: 1.5cm)

      if page_number {
        context utils.slide-counter.display() + " / " + utils.last-slide-number
      }
    }

    let background = {
      place(center + horizon, scale(66%, image("../assets/bmstu_rk6_logo3.png")))
      place(center + horizon, rect(fill: self.colors.neutral.transparentize(2%), width: 100%, height: 100%))
    }

    self = utils.merge-dicts(
      self,
      config-page(
        header: header,
        footer: footer,
        background: background,
      ),
    )

    touying-slide(self: self, ..args)
  })

  show: preambule

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (left: 1cm, right: 1.3cm, bottom: 2.5cm, top: 7em),
    ),
    config-colors(..colors),
    config-common(
      slide-fn: slide,
    ),
    config-store(
      title: none,
    ),
    ..args,
  )

  body
}

#let title-slide(
  line_correction: 2%,
  ..args,
) = touying-slide-wrapper(self => {
  let info = utils.merge-dicts(
    (
      institution: [Московский государственный технический университет имени Н.Э. Баумана],
      title: [\@Название темы, в полной мере раскрывающее замысел...\@],
      subtitle: [\@Подробности темы, различные детали, неуместившиеся в названии темы\@],
      contact: [\@email\@domain\@],
      extra: (
        place: (location: [\@место проведения|online\@], country: [Россия], city: [Москва], duration: [10 минут]),
        speaker: (position: [\@должность\@, \@уч.ст.\@], name: [\@Фамилия И.О.\@], position_name: auto),
        supervisor: (position: [\@должность\@, \@уч.ст.\@], name: [\@Фамилия И.О.\@], position_name: auto),
      ),
    ),
    self.info,
    args.named(),
  )

  let exists(what, then) = if what != none { then(what) }
  let or_default(what, default) = if what == none or what == auto { default } else { what }

  let body = {
    let image_shift = 32%
    let line_shift = 67.6%
    let line_angle = 5deg
    let line_width = 1em
    let right_bound_high = line_shift * (1 + calc.sin(line_angle))
    let right_bound_low = line_shift * (1 - calc.sin(line_angle))

    place(
      dx: image_shift,
      image(height: 100%, "../assets/bmstu_building_lighter.jpeg"),
    )

    place(polygon(
      fill: self.colors.neutral,
      stroke: none,
      (0%, 0%),
      (right_bound_high, 0%),
      (right_bound_low, 100%),
      (0%, 100%),
    ))

    place(line(
      stroke: self.colors.primary + line_width,
      start: (right_bound_high, -1%),
      end: (right_bound_low, 101%),
    ))

    place(bottom + right, dx: -2%, image(width: 15%, "../assets/Logo_Color_No-BG.svg"))

    show: pad.with(left: self.page.margin.left, right: 100% - line_shift)

    stack(
      5fr,
      smallcaps(info.institution),
      3fr,
      text(size: 1.5em, info.title),
      3fr,
      exists(info.subtitle, it => emph(it)),
      2fr,
      exists(info.extra.place, it => [
        #exists(it.location, it => [Место проведения: #it]) \
        #exists(it.duration, it => [Продолжительность: #it])
      ]),
      2fr,
      pad(left: -1.5%, right: line_correction, line(
        stroke: self.colors.primary + 3pt,
        length: 100%,
      )),
      2fr,
      par[
        #exists(info.extra.speaker, it => [#or_default(it.position_name, "Должность"): #it.position, #it.name]) \
        #exists(
          info.extra.supervisor,
          it => [#or_default(it.position_name, "Научный руководитель"): #it.position, #it.name],
        )
      ],
      1fr,
      exists(info.contact, it => text(fill: self.colors.secondary, it)),
      1fr,
      exists(info.extra.place, it => text(
        size: 0.8em,
        (it.country, it.city, info.date).filter(it => it != none).join(", "),
      )),
      3fr,
    )
  }

  self.page.margin = 0pt
  touying-slide(self: self, body)
})

#let end-slide(content: auto, ..args) = touying-slide-wrapper(self => {
  let content = if content == auto {
    stack(
      3fr,
      text(size: 28pt, weight: "medium", fill: self.colors.neutral)[Спасибо за внимание!],
      1fr,
      text(size: 28pt, weight: "medium", fill: self.colors.neutral)[Вопросы?],
      3fr,
    )
  } else {
    content
  }

  let body = {
    place(rect(fill: self.colors.primary, width: 100%, height: 100%))
    place(dx: 63%, dy: 13%, image("../assets/Logo_White_No-BG.png"))
    place(rect(fill: self.colors.primary.transparentize(40%), width: 100%, height: 100%))

    set align(left + horizon)
    show: pad.with(left: self.page.margin.left)
    content
  }

  self.page.margin = 0pt
  touying-slide(self: self, body)
})

#let shaded(..args, body) = {
  show math.equation: set text(font: "New Computer Modern Math")
  text(fill: luma(0%, 50%), style: "italic", ..args, body)
}

#let block(title, body) = {
  text(fill: colors.primary-dark, title)
  parbreak()
  [#body]
}

#let arrow-list(..args) = list(
  marker: (
    text(fill: colors.primary, $->$),
    text(fill: colors.primary, math.triangle.filled.r),
  ),
  ..args,
)
