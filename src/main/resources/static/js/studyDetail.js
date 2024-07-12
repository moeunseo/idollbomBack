// 이미지 슬라이드 관련 변수 및 이벤트
const sliderBox = document.querySelector(".slider-box");
const sliderItems = document.querySelectorAll(".slider-item");
const btns = document.querySelectorAll(".slider-btn");

// transition 동작이 끝나고 난 뒤, 실행되는 메서드
// 트랜지션 효과가 끝날때마다 실행되므로 두 번 실행됨. -> 트랜지션 효과 제거해서 1번만 실행하도록 한다.
sliderBox.ontransitionend = ()=>{
  
  // 기준 위치인 transform(-100%) 에서 왼쪽 버튼은 0%로 이동, 오른쪽 버튼은 -200% 이동한다.
  if(sliderBox.style.transform === 'translateX(-200%)'){
    // 오른쪽을 클릭한 경우, 트랜지션이 끝난 후 실행됨.
    let copy = sliderBox.children[0].cloneNode(true); // 첫째 이미지 복제
    sliderBox.children[0].remove(); // 첫째 이미지 삭제
    sliderBox.appendChild(copy); // 첫번째 이미지를 마지막 이미지로 추가
    
  }else{
    // 왼쪽을 클릭한 경우, 트랜지션이 끝난 후 실행됨.
    let copy = sliderBox.lastElementChild.cloneNode(true); // 이미지 복제
    sliderBox.lastElementChild.remove(); // 기존 이미지 삭제
    sliderBox.firstElementChild.before(copy); // 마지막 이미지를 가장 앞쪽에 배치
  }

  // 공통 코드 ( 반드시 if문 아래쪽에 입력해야 한다!! )
  sliderBox.style.transition = '0s'; // 트랜잭션 제거
  sliderBox.style.transform = 'translateX(-100%)'; // 원래 기준위치로 이동

}

// 이미지 슬라이드 관련됨.
btns.forEach(btn=>{
  btn.addEventListener("click", ()=>{

    // 위에서 트랜지션 효과가 없어졌으므로 클릭할 때마다 다시 트랜지션을 추가해야 한다.
    if(btn.classList.contains("right")){
      sliderBox.style.transform = 'translateX(-200%)';
      sliderBox.style.transition = '1s';

    }

    if(btn.classList.contains("left")){
      sliderBox.style.transform = `translateX(0%)`;
      sliderBox.style.transition = '1s';
      
    }
  });
})

// ===========================================================
// 더 보기 버튼 및 내용에 관련된 js.

const hiddenContent = document.querySelector(".hidden-content");
const moreBtn = document.querySelector(".study-more-btn");

moreBtn.addEventListener('click', ()=>{

  // open 클래스 여부에 따라 다른 화살표가 나타나도록 css 설정
  moreBtn.classList.toggle("open");
  // hidden 클래스 여부에 따라 height를 다르게 설정 
  hiddenContent.classList.toggle("hidden");

  // 버튼의 내용을 클릭할 때마다 변경
  if(moreBtn.children[0].textContent === '수업 더 보기'){
    moreBtn.children[0].textContent = "접기";
  }else{
    moreBtn.children[0].textContent = "수업 더 보기";
  }
});

// =========================================================
// 리뷰 수정
function goUpdate() {
  if (!confirm('리뷰를 수정하시겠습니까?')) {
    return; // 사용자가 취소를 선택한 경우 아무 것도 하지 않습니다.
  }

  let reviewNumber = document.querySelector('input[name="reviewNumber"]').value;
  window.location.href = '/reviews/' + reviewNumber;
}

// 리뷰 삭제
function goDelete() {
  if (confirm('리뷰를 삭제하시겠습니까?')) {
    // 사용자가 '확인'을 선택했을 경우, 삭제 절차 진행
    let reviewNumber = document.querySelector('input[name="reviewNumber"]').value;

    const form = document.createElement('form');
    form.method = 'post';
    form.action = '/reviews/' + reviewNumber;
    document.body.appendChild(form);
    form.submit();
  }
  // 사용자가 '취소'를 선택한 경우, 함수를 종료하고 아무것도 하지 않습니다.
}

const loginId = $('input[name="loginId"]').val();

// 날짜 포맷
function formatDate(dateString) {
  const now = new Date();
  const commentDate = new Date(dateString); // 문자열을 Date 객체로 변환

  const nowYear = now.getFullYear();
  const nowMonth = now.getMonth();
  const nowDate = now.getDate();

  const commentYear = commentDate.getFullYear();
  const commentMonth = commentDate.getMonth();
  const commentDateDate = commentDate.getDate();

  let displayText = "";

  // 년, 월, 일이 모두 같은 경우 "오늘"로 표시
  // if (nowYear === commentYear && nowMonth === commentMonth && nowDate === commentDateDate) {
  //     displayText = "오늘";
  // } else {
  // 그 외의 경우, 정해진 포맷으로 표시
  const yy = commentYear.toString().slice(-2); // 마지막 두 자리를 가지고 옴.
  const M = commentMonth + 1; // 월은 0부터 시작하므로 1을 더해줍니다.
  const d = commentDateDate;
  const HH = commentDate.getHours().toString().padStart(2, '0');
  const mm = commentDate.getMinutes().toString().padStart(2, '0'); // 두자리 수 일 때 앞에 0을 붙임.

  displayText = `${yy}년 ${M}월 ${d}일 ${HH}시 ${mm}분`;
  // }
  return displayText;
}



// 페이지가 처음 로드 될 때 댓글 목록 조회 함수가 실행되도록 한다.
$(document).ready(function () {
  let reviewNumber = $('input[name="reviewNumber"]').val();
  getComments(reviewNumber);
})

// 댓글 목록 조회 함수
function getComments(reviewNumber) {
  $.ajax({
    method : 'get',
    url : '/reivews/' + reviewNumber,
    success : function(reviews) {
      let reviewListArea = $('.review-list')

      // 댓글이 작성될 해당 섹션 비우기.
      reviewListArea.empty();

      // 댓글 없을 때 표시할 html
      if(reviews.length === 0){
        reviewListArea.append(
            `<div>첫번째 댓글을 남겨주세요!</div>`
        );
      }

      // 리뷰 있을 때 목록을 뿌려줄 반복문.
      reviews.forEach(function(review) {
        let reviewDate = formatDate(review.reviewRegisterDate);
        let buttons = '';
        let editStr = '';

        // 작성일과 수정일을 비교해서 html 에 다른 모양으로 표시.
        if(review.reviewUpdateDate !== review.reviewRegisterDate){
          commentDate = formatDate(review.reviewUpdateDate);
          editStr = ' (수정)';
        }

        // 현재 로그인된 계정과 리뷰 작성자가 동일하다면 만들어줄 버튼
        if(loginId === review.providerId){
          buttons = `
                        <div class="comment-actions">
                            <button onclick="updateComment(${review.commentId})" class="btn btn-primary">수정</button>
                            <button onclick="deleteComment(${review.commentId})" class="btn btn-danger">삭제</button>
                        </div>
                    `
        }

        // 종합적으로 뿌려줄 html
        let commentElement = `
                    <div class="comment-card" id="comment-${comment.commentId}">
                        <div class="comment-body">
                            <div class="comment-title">${comment.name}</div>
                            <div class="comment-subtitle">${commentDate}${editStr}</div>
                            <p class="comment-text">${comment.commentContent}</p>
                            <!-- 수정, 삭제 버튼 -->
                            ${buttons}
                        </div>
                    </div>
                `
        // 해당 섹션에 추가
        // 댓글의 갯 수 만큼 차례대로 추가될 것이다.
        commentListArea.append(commentElement);
      })
    },
    error : function(data) {
      console.error(data, "불러오기 실패");
    }
  })
}

// 댓글 추가
function addComment(){
  let boardId = $('input[name="boardId"]').val();
  let commentContent = $('#commentContent').val();

  // textarea 비어 있으면 경고
  if(!commentContent){
    alert('내용을 입력하세요!');
    return
  }

  $.ajax({
    method : 'post',
    url: '/comments',
    contentType: 'application/json',
    data: JSON.stringify({
      boardId: boardId,
      commentContent: commentContent,
      providerId : loginId
    }),
    success : function(data) {
      $('#commentContent').val('')
      getComments(boardId);
    },
    error : function(data) {
      console.error(data);
    }
  })
}

// 댓글 삭제
function deleteComment(commentId){
  // 매개 변수로 pk 잘 넘어왔는지 확인.
  // alert(commentId)
  // console.log(commentId)

  if(!confirm('정말로 삭제하시겠습니까?')){
    return;
  }

  $.ajax({
    method : 'delete',
    url : '/comments/' + commentId,
    success : function(data) {
      console.log(data, '삭제 성공')
      getComments($('input[name="boardId"]').val());
    },
    error : function(data) {
      console.error(data, '삭제 실패')
    }
  })
}

// 댓글 수정 폼 생성 함수
function createEditForm(commentId, currentContent){
  return `
        <div class="mb-3">
            <textarea class="form-control comment-edit-content" rows="3">${currentContent}</textarea>
        </div>
        <button class="btn btn-primary" onClick="editComment(${commentId})">수정완료</button>
        <button class="btn btn-secondary" onClick="cancelEdit()">취소</button>
    `;
}

// 수정 삭제 버튼 중 수정을 눌렀을 때
function updateComment(commentId) {
  // 기존 댓글 내용을 가지고 와서, 수정 폼에 넣는다.
  let comment = $(`#comment-${commentId}`);
  let content = comment.find('.comment-text').text()
  comment.find('.comment-body').html(createEditForm(commentId, content))
}

// 수정 완료 버튼 눌렀을 때
function editComment(commentId){
  let comment = $(`#comment-${commentId}`);
  // textarea 는 속성이 두개 있다.
  // 데이터를 뿌려줄 때는 text, 입력한 데이터를 가져올 때는 value.
  let updateContent = comment.find('.comment-edit-content').val();

  $.ajax({
    method : 'put',
    url : '/comments/' + commentId,
    contentType: 'application/json',
    data: JSON.stringify({
      commentContent : updateContent
    }),
    success : function(data) {
      console.log('수정 성공')
      getComments($('input[name="boardId"]').val());
    },
    error : function(data) {
      console.log('수정 삭제')
    }
  })
}

// 취소 버튼 눌렀을 때
function cancelEdit(){
  getComments($('input[name="boardId"]').val());
}



