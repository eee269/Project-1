<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:import url="/header"/>
<link rel="stylesheet" href="<c:url value="/resources/css/staff.css"/>">

<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>직원관리</h1>
      <ol class="breadcrumb">
        <li><a href="<c:url value='main'/>"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">직원관리</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
	      <!-- Default box -->
      <div class="box">
	  	<div class="box-header with-border">
          <h3 class="box-title"></h3>
          <div class="box-tools pull-right">
	          <a href="javascript:;" id="csvDownloadButton" class="btn btn-success btn-sm">엑셀파일다운로드</a>
	          <a href="<c:url value='staffInsert'/>" class="btn btn-success btn-sm"><i class="fa fa-plus"></i> 직원등록</a></div>
        </div>

        <div class="box-body mg_t20">
  	       <div id="my_all">
			<div class="form-group clearfix">
				
				<form  method="get" action="<c:url value='/staffList'/>" class="float_right clearfix" style="width: 24%;">
					<div class="col-md-5 float_left">
						<select name="pst_id" id="position_id" class="form-control">
							<option value="" selected>직급을 선택해주세요. </option>
							<c:forEach var="psl" items="${positionList}" varStatus="status">
								<option value="${psl.pst_id}">${psl.pst_name}</option>
							</c:forEach>
						</select>
				  	</div>
					<div class="col-md-5 float_left" >
						<input type="text"  class="form-control" name="stf_name" placeholder="직원명검색">
					</div>
					<input type="submit" class="col-md-2 btn btn-success btn-xxs float_left" value="검색">
				</form>
 			</div>
			
		
	        <div class="table-responsive no-padding mg_t15">
	          <table class="table table-striped table-responsive tbl_narrow" id="staffList">
	          	<colgroup>
	          		<col style="width:5%;">
	          		<col style="width:12%;">
	          		<col style="width:8%;">
	          		<col style="width:15%;">
	          		<col style="width:18%;">
	          		<col style="width:15%;">
	          		<col style="width:16%;">
	          		<col style="width:11%;">
	          	</colgroup>
	            <thead>
	                <tr>
	                	<th class="tac">#</th>
	                    <th class="tac">직원이름</th>
	                    <th class="tac">직원ID</th>
						<th class="tac">직급</th>
						<th class="tac">직원폰번호</th>
						<th class="tac">근로일수</th>
						<th class="tac">근로시간</th> 
						<th class="tac"></th> 
	                </tr>
	  				</thead>
	  				<tbody id="stf_tb">
	  				<c:choose>
					    <c:when test="${fn:length(staffList) == 0}">
				        <tr>
					        <td colspan="11"  class="tac">조회된 직원이 없습니다.</td>
						</tr>
					    </c:when>
					    <c:otherwise>
					        <c:forEach var="stl" items="${staffList}" varStatus="status">
					        	<tr data-pstid="${stl.pst_id}">
					        		<td class="tac">${status.index+1}</td>
					        		<td class="tac">${stl.stf_name} <!-- 직원이름 출력 --></td>
					        		<td class="tac">${stl.stf_id} <!-- 직원ID 출력 --></td>
					        		<td class="tac">${stl.pst_name} <!-- 직급 출력 --></td>
					        		<td class="tac">${stl.stf_phone} <!-- 직원폰번호 출력 --></td>
					        		<td class="tac">${stl.cnt_go} </td>
					        		<td class="tac">${stl.total_time} 분</td>
					        		<td class="text-right">					        			
										 <a href="<c:url value='staffModify?stf_id=${stl.stf_id}'/>"  class="btn btn-default btn-xs"  title="Update Detail">
					        			 	<span class="glyphicon glyphicon-pencil"></span>
					        			 </a> 
					        			 <a href="<c:url value='staffDelete?stf_id=${stl.stf_id}'/>" class="btn btn-warning btn-xs" onclick="javascript:return confirm('해당 직원을 삭제하시겠습니까?');" title="Remove Position">
					        			 	<span class="glyphicon glyphicon-remove"></span>
				        			 	</a>
					        		</td>
				            	</tr>		
									
					        </c:forEach>
					    </c:otherwise> 
					</c:choose>
				  				
  				
 				</tbody>	
              </table>
             </div>
          </div>
			  
        </div>
      </div>
      <!-- /.box -->

    </section>
    <!-- /.content -->
  </div>
  	<div class="modal fade bs-modal-lg" id="my-ajax-modal" role="basic" aria-hidden="true">
	    <div class="modal-dialog modal-lg">
	        <div class="modal-content">
	        	<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
					<h4 class="modal-title" id="gridSystemModalLabel">직급추가</h4>
				</div>
				<form method="post" action="<c:url value='staffnRegist'/>" class="form-horizontal" name="frm_new" id="frm_new">
					
					<div class="modal-body">
					  <div class="form-group">
						  <label class="col-md-2 control-label">직원이름 :</label>
						  <div class="col-md-4">
						  	<input type="text" name="pst_id" id="pst_id" class="form-control required" required="required" value="pst">
						  </div>
					  </div>
					  <div class="form-group">
						  <label class="col-md-2 control-label">직급 : </label>
						  <select class="col-md-10" name="pst_name" id="pst_name" >
						  	<option value="">직급을 선택해 주세요.</option>
						  	<option value=""></option>
						  	<option value=""></option>
						  	<option value=""></option>
						  </select>
					  </div>
					</div>
					<div class="modal-footer">
					        <button type="submit" class="btn btn-success btn-light-submit">추가하기&nbsp;&nbsp;<i class="fa fa-arrow-circle-right"></i></button>
							<button type="button" class="btn default" data-dismiss="modal">닫기</button>
					</div>
				</form>
			
			</div>
		</div>
	</div>
	
	<script type="text/javascript">

	$(function() {
		//직급별 리스트만 띄우기 
	    $(document).on("change", "#position_id", function() {
	        var selPosion = $("#position_id option");
	        for(a=0; a< selPosion.length; a++){
		        var pst_val = $(this).val();
		        var stf_tb = $("#stf_tb tr");
		    	stf_tb.show();
		    	if(selPosion.eq(a).val() != ""){
			       	if(pst_val == selPosion.eq(a).val()){		       
			       		for(i=0; i< stf_tb.length; i++){
			       			if(stf_tb.eq(i).data('pstid') != pst_val){		       			
			       				stf_tb.eq(i).hide();
			       			}                           			
			       		}
			       		return 	
			       	}
		       	}else{
		       		stf_tb.show();
			    }
	        }                  
	    });
	});


	class ToCSV {
        constructor() {
	        // CSV 버튼에 이벤트 등록
	        document.querySelector('#csvDownloadButton').addEventListener('click', e => {
	            e.preventDefault()
	            this.getCSV('staffList.csv')
	        })
	    }

	    downloadCSV(csv, filename) {
	        let csvFile;
	        let downloadLink;
	
	        // 한글 처리를 해주기 위해 BOM 추가하기
	        const BOM = "\uFEFF";
	        csv = BOM + csv
	
	        // CSV 파일을 위한 Blob 만들기
	        csvFile = new Blob([csv], {type: "text/csv"})
	
	        // Download link를 위한 a 엘리먼스 생성
	        downloadLink = document.createElement("a")
	
	        // 다운받을 csv 파일 이름 지정하기
	        downloadLink.download = filename;
	
	        // 위에서 만든 blob과 링크를 연결
	        downloadLink.href = window.URL.createObjectURL(csvFile)
	
	        // 링크가 눈에 보일 필요는 없으니 숨겨줍시다.
	        downloadLink.style.display = "none"
	
	        // HTML 가장 아래 부분에 링크를 붙여줍시다.
	        document.body.appendChild(downloadLink)
	
	        // 클릭 이벤트를 발생시켜 실제로 브라우저가 '다운로드'하도록 만들어줍시다.
	        downloadLink.click()
	    }
	
	    getCSV(filename) {
	        // csv를 담기 위한 빈 Array를 만듭시다.
	        const csv = []
	        const rows = document.querySelectorAll("#staffList tr")
	
	        for (let i = 0; i < rows.length; i++) {
	            const row = [], cols = rows[i].querySelectorAll("td, th")
	
	            for (let j = 0; j < cols.length; j++)
	                row.push(cols[j].innerText)
	
	            csv.push(row.join(","))
	        }
	
	        // Download CSV
	        this.downloadCSV(csv.join("\n"), filename)
	    }
	}
	
	document.addEventListener('DOMContentLoaded', e => {
	    new ToCSV()
	});	

	</script>
  
<%-- <script src="<c:url value="/resources/js/salesHistory.js"/>"></script> --%>
<c:import url="/footer"/>