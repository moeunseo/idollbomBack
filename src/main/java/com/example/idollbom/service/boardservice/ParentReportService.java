package com.example.idollbom.service.boardservice;

import com.example.idollbom.domain.dto.boarddto.ParentReportDTO;
import org.springframework.stereotype.Service;

@Service
public interface ParentReportService {

    void saveParentReport(Long parentPostNumber, String reportType, String reportForm);
}