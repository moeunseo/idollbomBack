package com.example.idollbom.controller.board;

import com.example.idollbom.domain.dto.boarddto.ParentCommentDTO;
import com.example.idollbom.domain.dto.boarddto.ParentCommentListDTO;
import com.example.idollbom.service.boardservice.ParentCommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/comments")
@RequiredArgsConstructor
public class ParentCommentRestController {

    private final ParentCommentService parentCommentService;

    // 댓글 조회 (특정 게시글의 모든 댓글 조회하기)
    @GetMapping("/{parentPostNumber}")
    public ResponseEntity<?> getComments(@PathVariable Long parentPostNumber) {
        return ResponseEntity.ok(parentCommentService.getCommentById(parentPostNumber));
    }

    // 댓글 추가
    @PostMapping
    public ResponseEntity<?> addComment(@RequestBody ParentCommentDTO commentDTO) {
        parentCommentService.saveComment(commentDTO);
        return ResponseEntity.ok().build();
    }

}
