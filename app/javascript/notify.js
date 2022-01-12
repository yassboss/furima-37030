window.addEventListener('load', function(){

  const commentLetter = document.getElementById("comment-letter");
  const noticeLists = document.getElementById("notice-lists");
  
  commentLetter.addEventListener('mouseover', function(){
    this.setAttribute("style", "font-weight: bold;");
  })

  commentLetter.addEventListener('mouseout', function(){
    this.removeAttribute("style", "font-weight: bold;");
  })

  commentLetter.addEventListener('click', function(){
    if (noticeLists.getAttribute("style") == "display: block;") {
      noticeLists.removeAttribute("style", "display: block;")
    } else {
      noticeLists.setAttribute("style", "display: block;")
    }
  })
})