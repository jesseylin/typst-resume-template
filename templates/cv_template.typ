#let cv(
  // A dictionary providing the author fields
  author: (
    firstname: "", lastname: "", email: "", phone: "", 
    positions: [], github: "", linkedin: ""
  ),
  // The date, as a string or as content verbatim how it will be printed
  date: "", 
  // Information about the localisation of the document
  localisation: (paper: "us-letter", lang : "en", region: "us"),
  // Sizing arguments
  sizing: (
    line_spacing: 0.45em, par_spacing: 0.5em, 
    side_margin: 0.5in, top_margin: 0.5in,
    inner_margin_factor: 1.6
  ),
  body
) = {

  // convenience parameters and global state
  let author_name = author.firstname + " " + author.lastname
  set document(
    author: author_name, 
    title: author.lastname + ", " + author.firstname + " - CV",
  )

  set page(
    paper: localisation.paper,
    margin: (
      left: sizing.side_margin, 
      right: sizing.side_margin, 
      top: sizing.top_margin, 
      bottom: sizing.top_margin
    ),
    footer: [
      #set text(
        size: 8pt,
        weight: "light"
      )
      // align to left and right
      #grid(columns: (1fr, 1fr)
      )[
        // set date
        #set align(left)
        #date
      ][
        // display name
        #set align(right)
        #author_name #h(0em, weak: true) #sym.dot.c #h(0em, weak: true) CV
      ]
    ]
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
  let font_size = 11pt
  set text(
    font: ("New Computer Modern"),
    lang: localisation.lang,
    region: localisation.region,
    size: font_size,
    fill: black,
    fallback: false
  )
  show link: it => [#h(0pt, weak: true); #set text(blue); #underline(it.body);]

  // set about me
  let name = {
    set align(center)
    set pad(bottom: 5pt)
    block[
      #set text(size: 25pt)
      #author.firstname #author.lastname
    ]
  }

  let positions = {
    set text(
      size: 14pt,
      ligatures: false,
    )
    show: smallcaps
    set align(center)
    // list positions
    if author.positions.len() > 1 {
      author.positions.join()[ #sym.dot.c ]
    }
    else { 
      author.positions.at(0) 
    }
  }

  let contacts = {
    set text(size: font_size)
    set box(height: font_size)
    set align(center + horizon)

    let linkedin_icon = box(image("../assets/icons/linkedin.svg"))
    let github_icon = box(image("../assets/icons/square-github.svg"))
    let email_icon = box(image("../assets/icons/square-envelope-solid.svg"))
    let phone_icon = box(image("../assets/icons/square-phone-solid.svg"))
    let separator = h(0.5em)
    
    [
      #phone_icon 
      #box[#text(author.phone)] 
      #separator
    ]
    [
      #email_icon
      #box[#link("mailto:" + author.email)[#author.email]]
      #separator
    ]
    if author.keys().contains("github") [
      #github_icon
      #box[#link(author.github)[#author.github]]
      #separator
    ]
    if author.keys().contains("linkedin") [
      #linkedin_icon
      #box[
        #link("https://www.linkedin.com/in/" + author.linkedin
        )[#author.linkedin]
      ]
    ]

  }

  // display about me
  [
    #set align(center)
    #block(breakable: false)[
      #name #positions #contacts
      // label to retrieve the global state of sizing arguments
      #state("sizing").update(x => sizing)
      #<preamble>
    ]
  ]

  // render document body
  body
}

// general style
#let section(title) = {
  // this function is here only because we have nostalgia for Latex
  return heading[#title]
}

#let entry_heading(
  org, location, time, title, 
  // _extra_line is for internal use only
  _extra_line: ()
) = {
  // retrieve state of sizing parameters in locate block
  locate(loc => {
    let sizing = state("sizing").at(
      query(<preamble>, loc).last().location())

    // formatting functions
    let fmt_org(org) = [
      #set text(size: sizing.org_size)
      #show: strong
      #org
    ]
    let fmt_location(location) = [
      #set text(size: sizing.location_size)
      #location
    ]
    let fmt_time(time) = [
      #set text(size: 11pt)
      #time
    ]
    let fmt_title(title) = [
      #set text(size: 11pt)
      #show: smallcaps
      #set par(hanging-indent: sizing.inner_margin_factor*1em)
      #title
    ]

  // assemble column data
  let left_column = (fmt_org(org), fmt_title(title))
  let right_column = (fmt_location(location), fmt_time(time))
  let num_lines = 2

  // dynamically adjust based on whether there is an extra line
  if _extra_line.len() > 0 {
    num_lines = num_lines + 1
    left_column.push(_extra_line.at(0))
    right_column.push(_extra_line.at(1))
  }
  let entry_height = num_lines * 1.35em

  // create the blocks
  let left_block = [
    #set align(left)
    #block(
      breakable: false,
      clip: true,
      height: entry_height,
    )[
      #stack(dir: ttb, spacing: sizing.line_spacing, ..left_column)
    ]
  ]
  let right_block = [
    #set align(right)
    #block(
      breakable: false,
      clip: true,
      height: entry_height,
    )[
      #stack(dir: ttb, spacing: sizing.line_spacing, ..right_column)
    ]
  ]

  // render the heading
  return block(breakable: false)[
    #grid(
      columns: (2fr, 1fr),
      left_block,
      right_block
      )
  ]
  })
}

#let entry(
  org: "", location: "", time: "", title: "", 
  _extra_line: (), ..body
) = {
  if body.pos().len() == 0 {
    return entry_heading(org, location, time, title, _extra_line: _extra_line)
  }

  // combine body variadic argument into a single block
  let body = body.pos().join("")
  // retrieve state of sizing parameters
  return locate(loc => {
    let par_spacing = state("sizing").at(
      query(<preamble>, loc).first().location()).par_spacing
    let inner_margin_factor = state("sizing").at(
      query(<preamble>, loc).first().location()).inner_margin_factor

    stack(dir: ttb, spacing: par_spacing,
      entry_heading(org, location, time, title, _extra_line: _extra_line),
      block[
        #pad(
          left: inner_margin_factor*1em,
          right: inner_margin_factor*1em,
          body
        )
      ]
    )
  })
}

// wrapper for education entries
#let education_entry(
  school: "", location: "", time: "", 
  degree: "", gpa: "", details: "", ..body
) = {
  // retrieve state of sizing parameters
  return locate(loc => {
    let inner_margin_factor = state("sizing").at(
      query(<preamble>, loc).first().location()).inner_margin_factor

    // custom formatting for GPA
    let fmt_gpa(gpa) = [
      #set text(size: 11pt)
      #gpa
    ]
    let _extra_line
    if gpa.len() > 0 {
      _extra_line = (
        [
          #h(inner_margin_factor*1em) #details
        ], 
        [#fmt_gpa(gpa)]
      )
    } else {
      _extra_line = ()
    }

    // call normal entry function
    entry(
      org: school, location: location, time: time, title: degree, 
      _extra_line: _extra_line, ..body
    )

  })
}

// wrapper for skill entries
#let skill_entry(num_cols: 1, ..body) = {
  // need to specify column sizes so they take up entire page width
  let col_arr = range(num_cols).map(x => 1fr)
  return table(
    columns: col_arr, 
    stroke: none, 
    ..body)
}
