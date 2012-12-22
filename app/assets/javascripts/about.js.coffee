jQuery ($)->
  return if $(".faces").length == 0

  Array::shuffle = -> @sort -> 0.5 - Math.random()

  photos_n = 23

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
        [0,0,0,0,0,0,0],
        [0,1,1,0,1,1,0],
        [1,1,1,1,1,1,1],
        [1,1,1,1,1,1,1],
        [0,1,1,1,1,1,0],
        [0,0,1,1,1,0,0],
        [0,0,0,1,0,0,0]
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
        [0,0,1,1,1,0,0],
        [0,1,1,1,1,1,0],
        [1,0,0,1,0,0,1],
        [1,0,0,1,0,0,1],
        [1,1,0,1,0,1,1],
        [0,1,1,1,1,1,0],
        [0,0,1,0,1,0,0]
      ],
      [
        [0,0,1,0,1,0,0],
        [0,1,1,1,1,1,0],
        [1,1,0,1,0,1,1],
        [0,1,1,0,1,1,0],
        [1,1,1,1,1,1,1],
        [0,1,1,0,1,1,0],
        [0,0,1,1,1,0,0]
      ]
    ]

  make_face = (pattern_n)->
    two_arrays = ([1..(photos_n - 1)].shuffle()).concat([1..(photos_n - 1)].shuffle())
    i = 0
    ret = "<table>"
    for row in face_patterns[pattern_n]
      ret += "<tr>"
      for cell in row
        if cell == 0
          ret += '<td class="empty">&nbsp;</td>'
        else
          ret += "<td class='f#{two_arrays[i++]}'>&nbsp;</td>"

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


    face_n = Math.round(Math.random()*(face_patterns.length - 1))
    html = make_face(face_n)
    $(".photo-box .photo > a").css("background-position-y",-100*face_n)
    $(".photo-box .faces").html(html)

  insert_face()
  $(".photo-box .photo > a").click ->
    insert_face()
    false
  
