<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:import url="/header"/>
<link rel="stylesheet" href="<c:url value="/resources/css/salesHistory.css"/>">

<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>판매내역</h1>
      <ol class="breadcrumb">
        <li><a href="https://activepos.net/active/index.php"><i class="fa fa-dashboard"></i> Home</a></li>
        <li class="active">판매내역</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
	      <!-- Default box -->
      <div class="box">
	  	<div class="box-header with-border">
          <h3 class="box-title"></h3>
          <div class="box-tools pull-right"><a id="csvDownloadButton" class="btn btn-success btn-sm">CSV 내보내기</a> <a href="<c:url value="sales"/>" class="btn btn-success btn-sm"><i class="fa fa-plus"></i> 주문받기</a></div>
        </div>
		<script>
		function print_opt()
		{
			var URL = 'sales_print.php?txt_search='+$('#txt_search').val()+'&from='+$('#from').val()+'&to='+$('#to').val()+'&branch_id='+$('#branch_id').val()+'&cust_id='+$('#cust_id').val()+'&user_id='+$('#user_id').val()+'&pstatus='+$('#pstatus').val();
			print_sub(URL,800,600);
		}
		</script>
        <div class="box-body">
  	       <div id="my_all">
			<form name="frm_filter" id="frm_filter" method="get" action="<c:url value="/salesHistory"/>" class="form-horizontal">
			<input type="hidden" name="search" value="on">
			<div class="form-group">
				<div class="col-md-2"><input type="date" name="begin_date" id="begin_date" value="${param.begin_date }" class="form-control txtdate" ></div>
			  	<div class="col-md-2"><input type="date" name="end_date" id="end_date" value="${param.end_date }" class="form-control txtdate" ></div>
			  	<div class="col-md-2"><input type="number" name="min_price" id="min_price" value="${param.min_price }" min="0" class="form-control" placeholder="최소금액"></div>
			  	<div class="col-md-2"><input type="number" name="max_price" id="max_price" value="${param.max_price }" min="0" class="form-control" placeholder="최대금액"></div>
			  	<div class="col-md-2"><input type="text" name="memo_search" id="memo_search" value="${param.memo_search }" class="form-control" placeholder="메모를 입력하세요"></div>
			</div>
			
			<div class="form-group">
              <div class="col-md-3">
              <input type="text" name="phone_search" id="phone_search" value="${param.phone_search }" class="form-control" placeholder="고객 전화번호 '-' 빼고 입력하세요"></div>
			  <div class="col-md-3">
			  	<select name="pmt_search" id="pmt_search" class="form-control select2" style="width:100%;">
					<option value="">결제타입</option>
					<option value="현금" <c:if test="${param.pmt_search eq '현금' }">selected</c:if>>현금</option>
					<option value="카드" <c:if test="${param.pmt_search eq '카드' }">selected</c:if>>카드</option>
				</select>
			  </div>
              <div class="col-md-2">
				<select name="staff_search" id="staff_search" class="form-control">
					<option value="">판매자</option>
					<c:forEach var="list" items="${staffList }">
					<option value="${list.stf_id }" <c:if test="${param.staff_search == list.stf_id }">selected</c:if>>${list.stf_name}</option>
					</c:forEach>
				</select>
			  </div>
			  <div class="col-md-2">
				<select name="cancel_search" id="cancel_search" class="form-control">
					<option value="">상태</option>
					<option value="0" <c:if test="${param.cancel_search == 0 }">selected</c:if>>판매완료</option>
					<option value="1" <c:if test="${param.cancel_search == 1 }">selected</c:if>>판매취소</option>
				</select>
			  </div>
			  <div class="col-md-1">
              	<button name="btn_filter" class="btn btn-primary form-control">필터</button>
              </div>
              <div class="col-md-1">
              	<input class="btn btn-warning form-control" type="reset" value="초기화" onclick="location.href='<c:url value="${path }"/>?size=${param.size }&page=${param.page }'">
              </div>
          </div>	
        </form>
		<script>
		$(document).ready(function(){
			$(document).on('click','.ord_memo',function(){
				var ord_id = $(this).attr('id').replaceAll('memo','');
				var memo = $(this).html();
				$(this).attr('class','ord_memo_writing')
				$('.ord_memo').attr('class','ord_memo_wait');
				$(this).html('<input type="text" id="memo_form'+ord_id+'" class="form-control ord_memo_form" name="ord_memo" value="'+memo+'">')
				$("#ord_memo_form").focus();
			})

			$(document).on('blur','.ord_memo_form',function(){
				var ord_id = $(this).attr('id').replaceAll('memo_form','');
				var memo = $(this).val();
				$.ajax('<c:url value="/updateMemo"/>',{
					data:{
						ord_id:ord_id,
						ord_memo:memo
						},
					success:function(data) {
						if(data=="success"){
							$('.ord_memo_writing').html(memo);
							$('.ord_memo_writing').attr('class','ord_memo');
							$('.ord_memo_wait').attr('class','ord_memo');
						} else {
							alert('작성에 실패했습니다.')
						}
				}
			})

			})
		})
			
		</script>
        <div class="table-responsive no-padding">
          <table id="historyTable" class="table table-striped table-responsive tbl_narrow table-bordered">
            <thead>
                <tr id="tr_top">
                  <th width="5%">#</th>
                    <th width="15%">판매날짜</th>
					<th width="10%">판매자</th>
					<th width="10%">판매금액</th>
					<th width="10%">결제타입</th>
					<th width="10%">할인</th>
					<th width="10%">전화번호</th>
					<th width="10%">상태</th>
                    <th width="10%">상세보기</th>
                    <th class="text-right" width="10%">메모</th>
                </tr>
  				</thead>
  				<tbody>
  				<c:choose>
	  				<c:when test="${list != null}">
		  				<c:forEach var="list" items="${list }">
		  				<tr>
						<td>${list.ord_id }</td>
						<td><fmt:formatDate value="${list.ord_date }" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>${list.stf_name }</td>
						<td>${list.ord_total }</td>
						<td>${list.pmt_name }</td>
						<td>${ord_discount }</td>
						<td>${list.pot_id }</td>
						<td><c:choose><c:when test="${list.ord_cancel == 0}">판매완료</c:when><c:otherwise>판매취소</c:otherwise></c:choose></td>
						<td>상세보기</td>
						<td class="text-right ord_memo" style="cursor: pointer" width="10%" id="memo${list.ord_id }">${list.ord_memo }</td>
						</tr>
		  				</c:forEach>
	  				</c:when>
	  				<c:otherwise>
			  			<tr>
						<td colspan="10">
							판매내역이 없습니다				
						</td>
						</tr>
	  				</c:otherwise>
  				</c:choose>
  				</tbody>
				</table>
             </div>
             <div style="margin-right: 10px; margin-top: 10px;">
             
             <div class="col-md-2">
             <c:set var="path" value="${requestScope['javax.servlet.forward.servlet_path']}" /> 
				<ul class="pagination" style="padding: 0px; margin: 0px;">
					
					<c:if test="${pageBean.pageNum > 1 }">
					<li><a href="<c:url value="${path }?page=1&size=${param.size }"/><c:if test="${param.search eq 'on' }">
					&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=&
					</c:if>" title="First Page">
						<span class="glyphicon glyphicon-fast-backward"></span></a></li>
					</c:if>
					
					<c:if test="${pageBean.pageNum > 1 }">
					<li><a href="<c:url value="${path }?page=${pageBean.pageNum - 1 }&size=${param.size }"/><c:if test="${param.search eq 'on' }">
					&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=&
					</c:if>" title="Previous Page">
						<span class="glyphicon glyphicon-backward"></span></a></li>
					</c:if>
					
					<li><select onchange="location.href='<c:url value="${path }?page="/>'+this.value+'&size=${param.size }<c:if test="${param.search eq 'on' }">&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=</c:if>'">
					<option value=${pageBean.pageNum }>Page: ${pageBean.pageNum } of ${pageBean.endPage }</option>
					<c:forEach var="count" begin="1" end="${pageBean.endPage }" step="1">
					<option value="${count }">Page: ${count }</option>
					</c:forEach>
					</select></li>
					
					<c:if test="${pageBean.pageNum < pageBean.endPage }">
					<li><a href="<c:url value="${path }?page=${pageBean.pageNum + 1 }&size=${param.size }"/><c:if test="${param.search eq 'on' }">
					&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=&
					</c:if>" title="Next Page">
						<span class="glyphicon glyphicon-forward"></span></a></li>
					</c:if>
					
					<c:if test="${pageBean.pageNum < pageBean.endPage }">
					<li><a href="<c:url value="${path }?page=${pageBean.endPage }&size=${param.size }"/><c:if test="${param.search eq 'on' }">
					&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=&
					</c:if>" title="Last Page">
						<span class="glyphicon glyphicon-fast-forward"></span></a></li>
					</c:if>
				</ul>
			</div>
			
			<div class="col-md-4">
			<button class="btn btn-info" onclick="location.href='<c:url value="${path }"/>?size=20<c:if test="${param.search eq 'on' }">&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=</c:if>'">20개</button>
			<button class="btn btn-info" onclick="location.href='<c:url value="${path }"/>?size=30<c:if test="${param.search eq 'on' }">&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=</c:if>'">30개</button>
			<button class="btn btn-info" onclick="location.href='<c:url value="${path }"/>?size=50<c:if test="${param.search eq 'on' }">&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=</c:if>'">50개</button>
			<button class="btn btn-info" onclick="location.href='<c:url value="${path }"/>?size=100<c:if test="${param.search eq 'on' }">&search=on&begin_date=${param.begin_date}&end_date=${param.end_date}&memo_search=${param.memo_search}&phone_search=${param.phone_search}&pmt_search=${param.pmt_search}&staff_search=${param.staff_search}&cancel_search=${param.cancel_search}&btn_filter=</c:if>'">100개</button>

			</div>
			
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
        <div class="modal-content"></div>
    </div>
</div>

<script src="<c:url value="/resources/js/salesHistory.js"/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/js/DataTables/datatables.min.css?ver=1"/>"/>
<script type="text/javascript" src="<c:url value="/resources/js/DataTables/datatables.min.js"/>"></script>
<c:import url="/footer"/>
