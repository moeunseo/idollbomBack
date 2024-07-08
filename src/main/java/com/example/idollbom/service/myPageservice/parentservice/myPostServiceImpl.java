package com.example.idollbom.service.myPageservice.parentservice;

import com.example.idollbom.domain.vo.myPostVO;
import com.example.idollbom.mapper.myPagemapper.parentmapper.myPostMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
@RequiredArgsConstructor
@Slf4j
public class myPostServiceImpl implements myPostService {

    private final myPostMapper myPostMapper;
    @Override
    public List<myPostVO> selectPostList() {
       return myPostMapper.selectAll();
    }
}
