document.addEventListener('DOMContentLoaded', function(){

  const postForm = document.getElementById('new_post');
  const previewList = document.getElementById('previews');
  if (!postForm) return null;

  // 投稿できる枚数の制限を定義
  const imageLimits = 5;

  const buildPreviewImage = (dataIndex, blob) =>{
    const previewWrapper = document.createElement('div');
    previewWrapper.setAttribute('class', 'preview');
    previewWrapper.setAttribute('data-index', dataIndex);
    
    const previewImage = document.createElement('img');
    previewImage.setAttribute('class', 'preview-image');
    previewImage.setAttribute('src', blob);

    // 削除ボタンを生成
    const deleteButton = document.createElement("div");
    deleteButton.setAttribute("class", "image-delete-button");
    deleteButton.innerText = "削除";

    // 削除ボタンをクリックしたらプレビューとfile_fieldを削除させる
    deleteButton.addEventListener("click", () => deleteImage(dataIndex));

    previewWrapper.appendChild(previewImage);
    previewWrapper.appendChild(deleteButton);
    previewList.appendChild(previewWrapper);
  };

  const buildNewFileField = () => {
    // 2枚目用のfile_fieldを作成
    const newFileField = document.createElement('input');
    newFileField.setAttribute('type', 'file');
    newFileField.setAttribute('name', 'item[images][]');

    // 最後のfile_fieldを取得
    const lastFileField = document.querySelector('input[type="file"][name="item[images][]"]:last-child');
    // nextDataIndex = 最後のfile_fieldのdata-index + 1
    const nextDataIndex = Number(lastFileField.getAttribute('data-index')) +1;
    newFileField.setAttribute('data-index', nextDataIndex);

    // 追加されたfile_fieldにchangeイベントをセット
    newFileField.addEventListener("change", changedFileField);

    // 生成したfile_fieldを表示
    const fileFieldsArea = document.querySelector('.click-upload');
    fileFieldsArea.appendChild(newFileField);
  };

  // 指定したdata-indexを持つプレビューとfile_fieldを削除する
  const deleteImage = (dataIndex) => {
    const deletePreviewImage = document.querySelector(`.preview[data-index="${dataIndex}"]`);
    deletePreviewImage.remove();
    const deleteFileField = document.querySelector(`input[type="file"][data-index="${dataIndex}"]`);
    deleteFileField.remove();

    // 画像の枚数が最大のときに削除ボタンを押した場合、file_fieldを1つ追加する
    const imageCount = document.querySelectorAll(".preview").length;
    if (imageCount == imageLimits - 1) buildNewFileField();
  };

  const changedFileField = (e) => {
    const dataIndex = e.target.getAttribute('data-index');
    
    const file = e.target.files[0];

    // fileが空 = 何も選択しなかったのでプレビュー等を削除して終了する
    if (!file) {
      deleteImage(dataIndex);
      return null;
    };

    const blob = window.URL.createObjectURL(file);

    // data-indexを使用して、既にプレビューが表示されているかを確認する
    const alreadyPreview = document.querySelector(`.preview[data-index="${dataIndex}"]`);

    if (alreadyPreview) {
      // クリックしたfile_fieldのdata-indexと、同じ番号のプレビュー画像が既に表示されている場合は、画像の差し替えのみを行う
      const alreadyPreviewImage = alreadyPreview.querySelector("img");
      alreadyPreviewImage.setAttribute("src", blob);
      return null;
    };

    buildPreviewImage(dataIndex, blob);

    // 画像の枚数制限に引っかからなければ、新しいfile_fieldを追加する
    const imageCount = document.querySelectorAll(".preview").length;
    if (imageCount < imageLimits) buildNewFileField();
  };

  const fileField = document.querySelector('input[type="file"][name="item[images][]"]');

  fileField.addEventListener('change', changedFileField);
});