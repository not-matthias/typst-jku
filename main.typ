/*
 Based on the work of Daniel Morawetz, May 2023
 Continued by Katharina Sternbauer, October 2024, April 2025
 */

#import "jku.typ": *
#import "utils.typ": show_endnotes, note

#show: coverpage.with( //What is what, see jku.typ
  title: "<Your Title>",
  submitters: ("<Your name>",),//Better to keep a comma if only on name is present
  department: "<JKU Department>",
  supervisors: ("<Supervisor name>",), //When no Co-Supervisor is present, you MUST keep the comma or Typst will not interpret this as an array
  date: datetime.today().display("[month repr:long] [year]"),
  typeOfWork: 2,
  state: 0,
  version: "<Nr>",
  degree: text()[Title],
  study: "<Study>"
)

#show "OTMEvolver": text(font: font.sans, hyphenate: false)[OTM#super([Evolver])]

#show: preface.with(
  statutoryDeclaration: true,
  // If you do not need abstract, zusammenfassung or ack, just comment them out or remove line
  abstract: include "content/preface/abstract.typ",
  zusammenfassung: include "content/preface/zusammenfassung.typ",
  acknowledgement: include "content/preface/acknowledgement.typ",
  tocDepth: 3, //Depth of headings shown in ToC; e.g. 1 = Only h1 shown, 3 = H1 to H3 shown
  tableOfFigures: true, //Set to false if any tableOf is not needed
  tableOfTables: true,
  tableOfCode: true,
)

// Add abbreviations with #abbreviate("Short", "Spelled out long form")
#abbreviate("TEST", "Totally Expected Stupid Test")


#show: mainContent.with(
  //heading-depth: 3 
)

#show link: set text(fill: blue, hyphenate: true)
#show cite: it => text(fill: blue, style: "normal", it)
#show ref: it => text(weight: "medium", style: "italic", it)

#heading(supplement: "Chapter")[Content] <chap-content-label>
#include "content/01-introduction.typ"
#pagebreak()


#counter(heading.where(level: 1)).update(it => 0) // workaround for header to not show a number for bib
#show bibliography: set text(size: 8pt)
#show link: it => box(clip: true, it)
#bibliography("bibliography.bib", style: "ieee") //Select your bib style here

// #show_endnotes() //Comment this out if you have no endnotes

#counter(heading).update(0)
#pagebreak(weak: true)

#set heading(numbering: "A.1.")
#set page(flipped: false) //To go in landscape mode, set to true if needed for attachments
#heading("Attachments") <attachments>
#include "content/attachment-a.typ"
