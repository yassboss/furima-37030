document.addEventListener('DOMContentLoaded', function(){
  const postForm = document.getElementById('new_post');
  const previewList = document.getElementById('previews');
  if (!postForm) return null;

  const fileField = document.querySelector('input[type="file"][name="item[image]"]');

  fileField.addEventListener('change', function(e){
    // 古いプレビューが存在する場合は削除
    const alreadyPreview = document.querySelector('.preview');
    if (alreadyPreview) {
      alreadyPreview.remove();
    };
    
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    
    const previewWrapper = document.createElement('div');
    previewWrapper.setAttribute('class', 'preview');
    
    const previewImage = document.createElement('img');
    previewImage.setAttribute('class', 'preview-image');
    previewImage.setAttribute('src', blob);

    previewWrapper.appendChild(previewImage);
    previewList.appendChild(previewWrapper);
  });

});