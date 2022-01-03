import consumer from "./consumer"

if(location.pathname.match(/\/items\/\d/)){

  consumer.subscriptions.create({
    channel: "CommentChannel",
    item_id: location.pathname.match(/\d+/)[0]
  }, {

    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      function getTime(timed) {
        var time = new Date(timed);
        var year = time.getFullYear();
        var mon = ("0"+(time.getMonth()+1)).slice(-2); //１を足すこと
        var day = ("0"+time.getDate()).slice(-2);
        var hour = ("0"+time.getHours()).slice(-2);
        var min = ("0"+time.getMinutes()).slice(-2);
        var sec = ("0"+time.getSeconds()).slice(-2);
      
        var s = year + "/" + mon + "/" + day + " " + hour + ":" + min + ":" + sec; 
        return s;
      }

      let html;
      if (data.user.id === data.item.user_id) {
        html = `
        <div class="comment">
          <p>${data.user.nickname}</p>
          <div class="comment-frame">
            <p>${data.comment.text}</p>
            <p class="created">${getTime(data.comment.created_at)}</p>
              <a id="comment-destroy" data-method="delete" href="/items/${data.comment.id}/comments/${data.comment.item_id}">
                <i class="fas fa-trash-alt"></i>
              </a>
          </div>
        </div>`
      } else {
        html = `
        <div class="comment">
          <p>${data.user.nickname}</p>
          <div class="comment-frame">
            <p>${data.comment.text}</p>
            <p class="created">${getTime(data.comment.created_at)}</p>
          </div>
        </div>`
      }
      const comments = document.getElementById("comments")
      comments.insertAdjacentHTML('beforeend', html)
      const commentForm = document.getElementById("comment-form")
      commentForm.reset();
    }
  })
}
