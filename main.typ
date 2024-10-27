/*
 Based of the work of Daniel Morawetz, Mai 2023
 Continued by Katharina Sternbauer, October 2024
 */

#import "jku.typ": *
#import "utils.typ": show_endnotes, note

#show: coverpage.with( //What is what, see jku.typ
  title: "<Your Title>",
  submitters: ("<Your name>",),
  department: "<JKU Department>",
  supervisors: ("<Supervisor name>",), //When no Co-Supervisor is present, you MUST keep the comma or Typst will not interpret this as an array
  date: "<date>",
  typeOfWork: -1,
  state: 0,
  version: "<Nr>",
  degree: "<Degree>",
  study: "<Study>"
)

#show "OTMEvolver": text(font: font.sans, hyphenate: false)[OTM#super([Evolver])]

#let zusammenfassung = include "content/preface/zusammenfassung.typ"

#let abstract = include "content/preface/abstract.typ"

#show: preface.with(
  zusammenfassung: zusammenfassung,
  abstract: abstract,
)


#show: mainContent.with(
  //page-margin: (x: 4cm, y: 5cm),
)

#show link: set text(fill: blue, hyphenate: true)
#show cite: it => text(fill: blue, style: "normal", it)
#show ref: it => text(weight: "medium", style: "italic", it)

#heading(supplement: "Chapter")[Content] <chap-content-label>
#include "content/01-introduction.typ"
#pagebreak()

#show bibliography: set text(size: 8pt)
#show link: it => box(clip: true, it)

#counter(heading.where(level: 1)).update(it => 0) // workaround for header, to NOT show an incorrect numbering at the bibliography
#counter(heading).update(0)
#bibliography("bibliography.bib")

#show_endnotes() //Comment this out if you have no endnotes

#counter(heading.where(level: 1)).update(it => 0) // workaround for header, to NOT show an incorrect numbering at the bibliography
#counter(heading).update(0)
#pagebreak(weak: true)

#set heading(numbering: "A.1.")
#set page(flipped: false) //To go in landscape mode, set to true if needed for attachments
#heading("Attachments") <attachments>
#include "content/attachment-a.typ"

