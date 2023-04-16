
#let cover_letter(
  author: (:),
  recipient: "",
  date: "", 
  // Information about the localisation of the document
  localisation: (paper: "us-letter", lang : "en", region: "us"),
  sizing: (
    line_spacing: 0.45em, par_spacing: 0.5em, 
    side_margin: 0.5in, top_margin: 0.5in,
    inner_margin_factor: 1.6
  ),
  body
) = {

  let author_name = author.firstname + " " + author.lastname
  set document(
    author: author_name, 
    title: author.lastname + ", " + author.firstname + " - Cover Letter",
  )

  set page(
    paper: localisation.paper,
    margin: (
        left: sizing.side_margin, 
        right: sizing.side_margin, 
        top: sizing.top_margin, 
        bottom: sizing.top_margin
    )
  )
      
  // set paragraph spacing
  show par: set block(spacing: sizing.par_spacing)
  set par(leading: sizing.line_spacing, justify: true)
  
  // customize headings
  set heading(
    numbering: none,
    outlined: false,
  )
  show heading: it => [
    #set text(
      size: 18pt,
      weight: "regular",
    )
    #set align(left)

    #block[
      #smallcaps(it.body)
      #box(width: 1fr, line(length: 100%))
    ]
  ]

  // set font settings
  set text(
    font: ("New Computer Modern"),
    lang: localisation.lang,
    region: localisation.region,
    size: 11pt,
    fill: black,
    fallback: false
  )

    // render letter head
    [
    #set align(right)
    *#author_name* \
    #author.phone \
    #author.email
    ]
    [
    #grid(columns: (1fr, 1fr))[
      #set align(left)
      #recipient
    ][
      #set align(right)
      #date
    ]
    #v(2em)
    ]

    // render document body
    body

    // render signature
    [
      #image("../assets/signature.png", width: 25%)
      *#author_name*
    ]
}
