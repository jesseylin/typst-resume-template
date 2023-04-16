// TODO: only this way because the third-party LSP has a bug
// https://github.com/nvarner/typst-lsp/issues/90
#import "./templates/cv_template.typ": *

#show: cv.with(
  author: (
      firstname: "Bill", 
      lastname: "Billingson",
      email: "BB@gmail.com", 
      phone: "(+1) 123-456-7890",
      github: "github.com/jesseylin",
      // linkedin: "ab",
      positions: (
        "Research Engineer",
        "AI and Biophysics",
      )
  ),
  // no \today in typst yet,
  // TODO: https://github.com/typst/typst/issues/204
  date: "April 16, 2023"
)

#section[Education]
#education_entry(
  "UCLA",
  "Los Angeles, CA",
  "September 2018 -- June 2020",
  "BS in Fake News",
  gpa: "GPA: 3.9/4.0",
)
#education_entry(
  "University of California, Berkeley", 
  "Berkeley, CA", 
  "September 2020 -- December 2022",
  "BA in This is a Test",
  gpa: "GPA: 4.0/4.0",
  details: [
    with spec in ML
  ],
  body: [
  #let get_width(styles, body) = {
    let size = measure(body, styles)
    size.width
  }
  #grid(
    columns: 2,
    "Academic Honors:"
  )[
    #set list(marker: [])
    - smart
    - smarter
    - smartest
  ]
]
)

#section[Experience]
#entry(
  "Livre de visage", 
  "Paris, France", 
  "November 2022 -- November 2023",
  "Ingénieur",
  body: [
    #lorem(20)
    #lorem(20)
    #lorem(40)
  ]
)

#entry(
  "Walmart", 
  "Ohio, USA", 
  "November 2022 -- November 2023",
  "Engineer",
  body: [
    #lorem(20)
    #lorem(20)
  ]
)


#section[Skills & Interests]
#skill_entry(num_cols: 2)[
  *Computer:* #lorem(20)
  ][
  *Data:* #lorem(20)
  ][
  *Languages:* #lorem(20)
  ][
  *Philosophy:* #lorem(20)
]