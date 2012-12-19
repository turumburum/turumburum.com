jQuery ($)->
  return if $(".faces").length == 0

  photos_n = 22

  face_patterns =
    [
      [
        [0,0,1,1,1,0,0],
        [0,1,1,1,1,1,0],
        [1,1,0,1,0,1,1],
        [1,1,1,1,1,1,1],
        [1,0,1,0,1,0,1],
        [0,1,0,0,0,1,0],
        [0,0,1,1,1,0,0]
      ],
      [
        [0,0,1,1,1,0,0],
        [0,1,0,0,0,1,0],
        [1,0,1,0,1,0,1],
        [1,0,0,0,0,0,1],
        [1,0,1,1,1,0,1],
        [0,1,0,0,0,1,0],
        [0,0,1,1,1,0,0]
      ],
      [
        [0,0,1,1,1,0,0],
        [0,1,1,1,1,1,0],
        [1,0,0,1,0,0,1],
        [1,1,1,1,1,1,1],
        [1,0,1,1,1,0,1],
        [0,1,0,0,0,1,0],
        [0,0,1,1,1,0,0]
      ],
      [
        [0,0,1,1,1,0,0],
        [0,1,0,1,0,1,0],
        [1,0,0,1,0,0,1],
        [1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1],
        [0,1,1,0,1,1,0],
        [0,0,1,1,1,0,0]
      ],
      [
        [0,0,1,1,1,0,0],
        [0,1,1,0,1,1,0],
        [1,1,1,1,1,1,1],
        [1,1,1,0,0,0,0],
        [1,1,1,1,1,1,1],
        [0,1,1,1,1,1,0],
        [0,0,1,1,1,0,0]
      ],
      [
        [0,0,1,0,1,0,0],
        [0,1,1,1,1,1,0],
        [1,1,0,1,0,1,1],
        [0,1,1,0,1,1,0],
        [1,1,1,1,1,1,1],
        [0,1,1,0,1,1,0],
        [0,0,1,1,1,0,0]
      ],
      [
        [0,0,1,1,1,0,0],
        [0,1,1,1,1,1,0],
        [1,0,0,1,0,0,1],
        [1,0,0,1,0,0,1],
        [1,1,0,1,0,1,1],
        [0,1,1,1,1,1,0],
        [0,0,1,0,1,0,0]
      ]
    ]

  make_face = (pattern_n)->
    ret = "<table>"
    for row in face_patterns[pattern_n]
      ret += "<tr>"
      for cell in row
        if cell == 0
          ret += '<td class="empty">&nbsp;</td>'
        else
          rand = Math.round(Math.random()*(photos_n - 1) + 1)
          ret += "<td class='f#{rand}'>&nbsp;</td>"

    ret += "</table>"
    ret

  insert_face = ->
    if $("body > .faces").length == 0
      #move images to cache
      temp = "<table><tr>"
      for num in [1..photos_n+1]
        temp += "<td class='f#{num}'></td><td class='f#{num}-color'></td>"
      temp += "</tr></table>"
      $("body").append($("<div></div>").addClass("faces").css({position: "absolute", left:"-9999px"}).append(temp))


    html = make_face(Math.round(Math.random()*(face_patterns.length - 1)))
    $(".photo-box .faces").html(html)

  insert_face()
  $(".photo-box .photo > a").click ->
    insert_face()
    false
  
