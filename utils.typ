/*
 Based of the work of Daniel Morawetz, Mai 2023
 Continued by Katharina Sternbauer, October 2024
 */

#import "jku.typ": font

// Creates a box with a colourful background and an icon to
// highlight to-dos, warnings, etc.
#let note(content, type: "todo") = {
  let bg = rgb("#ebcc3433")
  let stroke = rgb("#ebcc3488")
  let sign = emoji.lightning
  
   box(
     baseline: .8em,
    fill: bg, inset: 8pt, radius: 4pt, stroke: stroke,
    grid(
      column-gutter: 8pt,
      columns: (10pt, auto),
      sign,
      text(font: font.sans, content)
    )
  )
}

#let _custom_endnote_counter = counter("custom_endnote")
#let _endnotes = state("endnotes", (:))

#let endnote = (text) => {
  _custom_endnote_counter.step()
  locate(loc => {
    let index = _custom_endnote_counter.at(loc).first()
    _endnotes.update(nts => {
      nts.insert(str(index), text)
      nts
    })
    super([#index])
  })
}

#let show_endnotes = () => {
  pagebreak(weak: true)
  layout(page-size => context {
    let endnotes = _endnotes.final()
    if endnotes.len() == 0 {
      return
    }
    heading(numbering: (..nums) => [], "Endnotes")
    for endnote in endnotes [
      #block(width: page-size.width - .9cm, stack(
        dir: ltr,
        spacing: .2cm,
        super(endnote.first()),
        endnote.last()
      )) #v(.4em)
    ]
  }
)
}