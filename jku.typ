/*
 Based of the work of Daniel Morawetz, Mai 2023
 Continued by Katharina Sternbauer, October 2024
 */
 
// Save heading and body font families in variables.
#let font = (
  roman: "New Computer Modern",
  sans: "New Computer Modern Sans",
  mono: "New Computer Modern Mono",
)
#let font-base-size = 11pt
#let font-sizes = (
  footnote: font-base-size * 0.818,
  body: font-base-size,
  large: font-base-size * 1.091,
  Large: font-base-size * 1.2727,
)
#let heading-sizes = (
  h1: font-base-size * 1.8818,
  h2: font-base-size * 1.4181,
  h3: font-base-size * 1.2363,
)


#let _abbreviations = state("abbreviations", (:))

#let abbreviate(long, abbr, desc: "", showAbbr: true) = {
  _abbreviations.update(d => { d.insert(abbr, (long: long, abbr: abbr, desc: desc)); d })
  if showAbbr [#long \(#abbr\)]
  else [#long]
}

// custom numbering definitions
#let _definitionCounter = counter(figure.where(kind: "definition"))

#let definition(lbl, title: "", content) = {
  [
    #figure(kind: "definition", supplement: [Definition], numbering: "1")[]
    #label("def-" + lbl)
  ]
  if title.len() == 0 [
    / #[_Definition #_definitionCounter.display():_]: #content
  ] else [
    / #[_Definition #_definitionCounter.display() (#title):_]: #content
  ]
}

/**
 * Coverpage
 */
#let coverpage(
  title: "",
  submitters: (),
  department: "",
  supervisors: (),
  date: "",
  // 0 ... Dissertation TODO
  // 1 ... Diplomarbeit / Masterarbeit f. Lehramt TODO
  // 2 ... Masterarbeit
  // 3 ... Bachelorarbeit
  typeOfWork: 3,
  // 0 ... final
  // 1 ... for review
  state: 0,
  version: "",
  degree: "",
  study: "",
  body
) = {
  let title-size = 29.86pt
  let body-size = 11pt
  let large-size = 12pt
  let vSpace = 4mm
  
  // Set the document's basic properties.
  set document(author: submitters, title: title)
  set page(header: "")

  // Set body font family.
  set text(font: font.sans, lang: "en", size: body-size)
  set page("a4", margin: (left: 2.9cm, right: 1.5cm, top: 1cm, bottom: 0cm))

  // JKU Logo
  align(top + right, image("img/jkuen.png", width: 5cm))
  v(1cm)

  let mainSupervisor = ""
  let coSupervisors = ()
  if supervisors.len() <= 1 {
    mainSupervisor = supervisors.first()
  } else {
    (mainSupervisor, ..coSupervisors) = supervisors
  }

  grid(
    columns: (1fr, 3.89cm),
    gutter: 12pt,
    box(height: 9.38cm)[
      #set par(justify: true)
      #align(bottom + left,
          text(size: title-size, weight: 700, hyphenate: false)[#title]
      )
    ],
    text(size: 9pt)[
      Submitted by\
      #submitters.map(s => strong(s)).join(", ")
      #v(vSpace)
      Submitted at\
      *#department*
      #v(vSpace)
      Supervisor\
      *#mainSupervisor*
      #coSupervisors.map(supervisor => [
        #v(vSpace)
        Co-Supervisor\
        *#supervisor*
      ]).join("\n")
      
      #v(vSpace)

      #{
        if state == 0 {
          date
        } else if state == 1 {
          text(fill: red)[To-do: #date]
          v(vSpace)
          text(fill: red, size: 12pt, weight: 600)[
            For review
            
            Version: #version
          ]
        }
      }
    ],
  )

  v(.8cm)
  image("img/arr.png", width: 4.4cm)
  v(0.5cm)
  
  let large(txt) = {
    text(size: large-size)[#txt]
    v(-1mm)
  }
  let small(txt) = {
    text(size: body-size)[#txt]
    v(-1mm)
  }
  
  let type-thesis = if typeOfWork == 3 [Bachelor] else if typeOfWork == 2 [Master]
  let type-program = if typeOfWork == 3 [Bachelor's] else if typeOfWork == 2 [Master's]
  
  large[#type-thesis Thesis]
  small[to obtain the academic degree of]
  large[#degree]
  small[in the #type-program Program]
  large[#study]

  v(1.7cm)

  align(right, box(width: 4cm, align(left)[
    #set par(leading: .4em)
    #text(size: 9pt, weight: 700, "JOHANNES KEPLER UNIVERSITY LINZ")
    #v(-2mm)
    #text(size: 9pt)[
      Altenbergerstraße 69\
      4040 Linz, Österreich
      #v(-2.68mm)
      www.jku.at
      #v(-2mm)
      DVR 0093696
    ]
  ]))

  set page(
    footer: align(center + horizon, text(fill: rgb(100,100,100))[
      \[For review\]
      #sym.circle.filled.tiny
      Version: #version
      #sym.circle.filled.tiny
      Created at: #datetime.today().display()
    ]),
    footer-descent: 2cm, // make extra page appear empty
  ) if state == 1

  set page(
    footer: [],
    footer-descent: 0cm,
  ) if state == 0

  if state == 1 {
    pagebreak(weak: true)
    align(center + horizon, 
      text(fill: gray)[intentionally blank])
  }
  
  
  body
}


/**
 * Preface
 */
#let preface(
  statutoryDeclaration: true,
  tableOfContents: true,
  tableOfFigures: true,
  listDefinitions: true,
  zusammenfassung: [],
  abstract: [],
  body-size: 11pt,
  heading-sizes: heading-sizes,
  page-margin: (left: 2.9cm, right: 2.9cm, top: 3cm, bottom: 3cm),
  body
) = {
  counter(page).update(1)
  set page(
    "a4",
    margin: page-margin,
    numbering: "i",
    footer-descent: 0cm,
    
    header: context {
      // reset footnote counter
      counter(footnote).update(0)
    
      let priorElems = query(
        selector(heading.where(level: 1)).before(here())
      )
      let laterElems = query(
        selector(heading.where(level: 1)).after(here())
      )

      let num = here().page-numbering()
      if num == none {
        num = "1"
      }
      let page = numbering(num, counter(page).at(here()).first())
  
      if laterElems != () and laterElems.first().location().page() == here().page() {
        let elm = laterElems.first()
        let c = counter(heading.where(level: 1)).at(elm.location()).first()
        if c != 0 {
          num = elm.numbering
          if num == none {
            num = "1."
          }
          let n = numbering(num, c)
          emph(n) + " " + emph(elm.body) + h(1fr) + page
        } else {
          emph(elm.body) + h(1fr) + page
        }
        
        line(length: 100%, stroke: .5pt)
      } else if priorElems != () {
        let elm = priorElems.last()
        let c = counter(heading.where(level: 1)).at(elm.location()).first()
        if c != 0 {
          num = elm.numbering
          if num == none {
            num = "1."
          }
          let n = numbering(num, c)
          emph(n + " " + elm.body) + h(1fr) + page
        } else {
          emph(elm.body) + h(1fr) + page
        }
        
        line(length: 100%, stroke: .5pt)
      } else {
        align(right, page)
        line(length: 100%, stroke: .5pt)
      }
    }
  )

  set text(font: font.roman)
  set par(justify: true)
  set footnote(numbering: "*")
  show heading: set text(font: font.sans)
  show heading.where(level: 1): set text(size: heading-sizes.h1)
  show heading.where(level: 2): set text(size: heading-sizes.h2)
  show heading.where(level: 3): set text(size: heading-sizes.h3)
  show heading.where(level: 1): it => {
    v(.9cm)
    it
    v(.6cm)
  }


  if statutoryDeclaration {
    heading(outlined: false)[Statutory declaration]
  
    text(size: body-size)[
      I hereby declare that the thesis submitted is my own unaided work, that I have
      not used other than the sources indicated, and that all direct and indirect sources
      are acknowledged as references. This printed thesis is identical with the electronic
      version submitted.
    ]

    v(2cm)
    grid(
      columns: (1fr, 1fr),
      gutter: 6cm,
      box[
        #line(length: 100%)
        #v(-2mm)
        #text(size: 9pt)[Place, Date]
      ],
      box[
        #line(length: 100%)
        #v(-2mm)
        #text(size: 9pt)[Signature]
      ]
    )
  }

  pagebreak()

  if tableOfContents {
    outline(target: heading, depth: 2, indent: 2em)
  }

  if tableOfFigures {
    outline(
      target: figure.where(kind: image).or(figure.where(kind: "table")),
      title: "Figures and Tables")
  }

  if listDefinitions {
//    pagebreak(weak: true)
    heading(outlined: false)[Abbreviations]
    context _abbreviations.final()
                  .values()
                  .map(def => [/ #def.long (#def.abbr): #def.desc])
                  .fold([], (sum, it) => sum + it)
  }

    if zusammenfassung != [] {
    pagebreak()
    heading(outlined: false)[Zusammenfassung]
    zusammenfassung
  }

  if abstract != [] {
    pagebreak()
    heading(outlined: false)[Abstract]
    abstract
  }

  pagebreak()
  
  body
}

/**
 * Main content
 */
#let mainContent(
  body-size: 11pt,
  heading-sizes: heading-sizes,
  page-margin: (left: 3.2cm, right: 3.2cm, top: 3.8cm, bottom: 2.5cm),
  body
) = {
  counter(page).update(1)

  // Page setup
  set page(
    "a4",
    margin: page-margin,
    numbering: "1"
  )

  set text(font: font.roman)
  set par(leading: 0.55em, first-line-indent: 1.3em)
  show terms: set par(first-line-indent: 0em)
  show raw: set text(font: font.mono)
  set math.equation(numbering: "(1)")

  // Headings
  set heading(numbering: "1.")
  show heading: set text(font: font.sans)
  show heading.where(level: 1): set text(size: heading-sizes.h1)
  show heading.where(level: 2): set text(size: heading-sizes.h2)
  show heading.where(level: 3): set text(size: heading-sizes.h3)
  show heading.where(level: 2): it => {
    v(.1cm)
    it
    v(.1cm)
  }

  body
}