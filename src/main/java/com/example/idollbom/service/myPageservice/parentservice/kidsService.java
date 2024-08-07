package com.example.idollbom.service.myPageservice.parentservice;

import com.example.idollbom.domain.dto.myPagedto.parentdto.kidDTO;
import com.example.idollbom.domain.vo.kidVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface kidsService {
    public void insertKids(kidDTO kidDTO);

    List<kidVO> selectKidsList();

    public void deleteKids(Long kidNumber);

    public kidVO selectKidById(Long kidNumber);

    public void updateByKidId(kidDTO kid);
}
