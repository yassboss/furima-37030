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
      const html = `
        <div class="comment">
          <p>${data.user.nickname}</p>
          <div class="comment-frame">
            <p>${data.comment.text}</p>
            <p class="created">${data.comment.created_at}</p>
          </div>
        </div>`
      const comments = document.getElementById("comments")
      comments.insertAdjacentHTML('beforeend', html)
      const commentForm = document.getElementById("comment-form")
      commentForm.reset();
    }
  })
}
