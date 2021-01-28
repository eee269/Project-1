package com.Travel.controller;

import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.Travel.domain.CategoryBean;
import com.Travel.domain.OrderBean;
import com.Travel.domain.OrderDetailBean;
import com.Travel.domain.PointBean;
import com.Travel.domain.ProductBean;
import com.Travel.service.SaleService;

@Controller
public class SaleController {
	
	@Inject
	private SaleService saleService ;
	
	//http://localhost:8080/go/sale　　
	@RequestMapping(value = "/sale", method = RequestMethod.GET)
	public String sale(Model model, HttpServletRequest request) {
		
		
		String ctg_type = request.getParameter("ctg_type");
		if(ctg_type == null) { // 받아온 카테고리 타입값이 없다면?
			ctg_type ="1";  // 디폴트 상품 카테고리 가져오기위해서 1 세팅
		}
		
		List<CategoryBean> ctgList = saleService.getCategoryList(ctg_type); // 타입에 따른 카테고리 리스트 가져오기
		List<ProductBean> pdtList = saleService.getProductList(); // 상품 리스트 가져오기
		
		model.addAttribute("ctgList",ctgList); 
		model.addAttribute("pdtList",pdtList); // 챙기기
		return "sub1/sale";
	}
	
	//http://localhost:8080/go/payment　
	@RequestMapping(value = "/payment", method = RequestMethod.POST)
	public String payment(Model model, HttpServletRequest request) {
		// 판매자 정보받아오기
		int stf_id = Integer.parseInt(request.getParameter("stf_id"));
		
		// 배열로 보낸 파라미터 값들 받아오기
		String[] pdt_idList = request.getParameterValues("pdt_idList");
		String[] pdt_countList = request.getParameterValues("pdt_countList");
		String[] pdt_priceList = request.getParameterValues("pdt_priceList");
			
		// 이건 아직 안씀 쓸일없을수도.. 근데 orderDetail 보고있으면 이거 넣어야될것같기도..
		String[] pdt_nameList = request.getParameterValues("pdt_nameList"); 
			
		int total = 0;
		// 총 금액 계산
		for(String i : pdt_priceList) {
			total += Integer.parseInt(i);
		}
			
		OrderBean ordBean = new OrderBean();
		ordBean.setOrd_date(new Timestamp(System.currentTimeMillis())); // 시간생성
		ordBean.setOrd_total(total+""); // 스트링으로 변경해줌
		ordBean.setPmt_name("카드"); // 추후에 제어할 예정
		ordBean.setStf_id(stf_id);
		saleService.insertOrder(ordBean); // order insert
		String order_id = saleService.getOrderId(ordBean); // orderdetail에 들어갈 ord_id값 찾아오기
		for(int i = 0 ; i < pdt_idList.length ; i++) {  // orderdetail에 구매한 상품들 넣기
			OrderDetailBean odtBean = new OrderDetailBean();
			odtBean.setOrd_id(order_id);
			odtBean.setPdt_id(pdt_idList[i]);
			odtBean.setOdt_count(pdt_countList[i]);
			odtBean.setPdt_name(pdt_nameList[i]);
			saleService.insertDetail(odtBean);
		}
		String pot_id = request.getParameter("pot_id");
		if(pot_id != "") {
			String pot_point = request.getParameter("pot_point");
			PointBean potBean = new PointBean();
			if(pot_point.equals("아이디 없음")) {
				potBean.setPot_id(pot_id);
				potBean.setPot_point(total/50); //2% 적립
				saleService.insertPointId(potBean);
			}
			else {
				potBean.setPot_id(pot_id);
				potBean.setPot_point(Integer.parseInt(pot_point) + total/50);
				potBean.setOrd_id(order_id);
				saleService.updatePoint(potBean);
			}
			saleService.updateOrdPoint(potBean);
		}
		return "sub1/sale"; 
	}
	//http://localhost:8080/go/sale　　
	@RequestMapping(value = "/pointCheck", method = RequestMethod.POST,produces = "application/json; charset:utf-8")
	@ResponseBody
	public String pointCheck(Model model, HttpServletRequest request) {
		String phoneNumber = request.getParameter("phoneNumber");
		PointBean potBean = new PointBean();
		potBean.setPot_id(phoneNumber);
		String point = saleService.getPoint(potBean);
		return point;
	}
}
