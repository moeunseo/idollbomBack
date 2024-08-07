package com.example.idollbom.controller.board;

import com.example.idollbom.domain.dto.boarddto.CommunityDTO;
import com.example.idollbom.domain.dto.boarddto.CommunityDetailDTO;
import com.example.idollbom.domain.dto.boarddto.ParentFileDTO;
import com.example.idollbom.domain.dto.logindto.CustomUserDTO;
import com.example.idollbom.domain.vo.ParentVO;
import com.example.idollbom.mapper.loginmapper.ParentMapper;
import com.example.idollbom.service.boardservice.CommunityService;
import com.example.idollbom.service.boardservice.ParentFileService;
import com.example.idollbom.service.boardservice.ParentReportService;
import com.example.idollbom.service.myPageservice.parentservice.noteService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Controller
@RequestMapping("/parentcommunity")
@RequiredArgsConstructor
@Slf4j
public class ParentcommunityController {

    private final CommunityService communityService;
    private final ParentFileService parentFileService;
    private final ParentReportService parentReportService;
    private final ParentMapper parentMapper;
    private final noteService noteService;

    // 게시글 목록 띄어주는 컨트롤러
    @GetMapping
    public String community(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if(authentication != null && authentication.getPrincipal() instanceof CustomUserDTO) {
            CustomUserDTO p = ((CustomUserDTO) authentication.getPrincipal());
            String parentId = p.getEmail();
            String role = p.getRole();

            if (p.getRole().equals("parent")) {
                System.out.println(role);
                ParentVO parent = parentMapper.selectOne(parentId);

                // 부모 정보를 받아와서 쪽지목록 개수를 계산해서 html로 전달
                int count = noteService.countParentNoteList(parent.getParentNumber());

                log.info("count : " + count);

                model.addAttribute("role", role);
                model.addAttribute("count", count);
                model.addAttribute("parentNumber", parent.getParentNumber());
            }
        }
        return "html/board/parent/community_parent";
    }

    // 게시글 작성폼 컨트롤러
    @GetMapping("/write")
    public String write(Model model){
        model.addAttribute("community", new CommunityDTO());
        return "/html/board/parent/freeBoardForm_parent";
    }

    // 현재 pk를 가지고 오는 메소드
    public Long findParentPK(){
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDTO p = ((CustomUserDTO) authentication.getPrincipal());
        String parentName = p.getUsername();

        ParentVO parent_info = parentMapper.selectOne(parentName);

        return parent_info.getParentNumber();
    }

    // 게시글 작성 및 수정 (같은 폼에서 할 거기 때문에)
    @PostMapping("/write")
    public String write(@ModelAttribute("community") CommunityDTO community,
                        @RequestParam("parentFiles") List<MultipartFile> files,
                        @RequestParam(value = "parentNumber", required = false) Long parentNumber){

        // 현재 로그인한 pk가지고옴
        Long parentId = findParentPK();
        int parentPostNumber = community.getParentPostNumber();

        // 현재 parentPostNumber 를 가지고 있다면 수정폼
        if(parentPostNumber != 0 && parentId.equals(parentNumber)){
            communityService.updateCommunity(community, files);
            return "redirect:/parentcommunity/detail/" + parentPostNumber;
        }

        // 작성 시에는 parentNumber 값이 안넘어오기 때문에 required=false값 줌
        communityService.saveCommunity(community, files, parentId);
        return "redirect:/parentcommunity";
    }

    // 게시글 상세보기
    @GetMapping("/detail/{parentPostNumber}")
    public String detail(@PathVariable("parentPostNumber") Long parentPostNumber, Model model){

        Long parentId = findParentPK();
        System.out.println(parentId);

        CommunityDetailDTO community = communityService.selectCommunityDetail(parentPostNumber, parentId);
        List<ParentFileDTO> files = parentFileService.selectFileList(parentPostNumber);

        System.out.println(community.getParentPostUpdateDate());

        model.addAttribute("community", community);
        model.addAttribute("files", files);
        // 현재 로그인한 정보와 게시글 작성자와의 확인 유무를 위함
        model.addAttribute("parentId", parentId);

        return "/html/board/parent/freeBoardDetail_parent";
    }

    // 게시글 삭제하기
    @PostMapping("/delete/{parentPostNumber}/{parentNumber}")
    public String delete(@PathVariable("parentPostNumber") Long parentPostNumber,
                         @PathVariable("parentNumber") Long parentNumber){
        System.out.println(parentNumber);
        Long parentId = findParentPK();

        // 현재 로그인한 pk와 작성한 pk가 같다면 삭제 실행
        if(parentId.equals(parentNumber)){
            communityService.deleteCommunity(parentPostNumber);
        }
        return "redirect:/parentcommunity";
    }

    // 게시글 수정하기
    @GetMapping("/edit/{parentPostNumber}/{parentNumber}")
    public String edit(@PathVariable("parentPostNumber") Long parentPostNumber,
                       @PathVariable("parentNumber") Long parentNumber,
                       Model model){

        Long parentId = findParentPK();

        // 현재 로그인한 pk와 작성한 pk가 같다면 수정 실행
        if(parentId.equals(parentNumber)){
            model.addAttribute("community", communityService.selectCommunityDetail(parentPostNumber, parentId));
            return "/html/board/parent/freeBoardForm_parent";
        }
        // 현재 로그인한 사람이 아니라면
        return "redirect:/parentcommunity";
    }

    // 신고하기 눌렀을 때
    @PostMapping("/report")
    public String parentReport(@RequestParam("parentPostNumber") Long parentPostNumber,
                               @RequestParam("reportType") String reportType,
                               @RequestParam("reportForm") String reportForm){

        System.out.println("==============" + parentPostNumber);
        System.out.println("==============" + reportType);
        System.out.println("==============" + reportForm);

        parentReportService.saveParentReport(parentPostNumber,reportType,reportForm);
        return "redirect:/parentcommunity";
    }
}

