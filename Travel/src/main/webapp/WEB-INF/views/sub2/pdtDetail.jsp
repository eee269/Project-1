<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="../include/header.jsp"%>


<script>
	function update() {
		if(confirm('상품 수정을 진행하시겠습니까?') == true) {
			$('#up-form').submit();
		} else {
			return false;
		}
	}
	
	function del() {
		if(confirm('상품을 정말 삭제하시겠습니까?') == true) {
			var action = "<c:url value='/pdt/delete/" + ${pdt.pdt_id } + "'/>";
			$('#up-form').attr('action', action);
			$('#up-form').submit();
		} else {
			return false;
		}
	}
</script>


<div class="content-wrapper">
	<!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>Product Detail</h1>
      <ol class="breadcrumb">
        <li><a href="<c:url value='/main' />"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="<c:url value='/pdt/list' />"><i class="fa fa-dashboard"></i> Product List</a></li>
        <li class="active">Product Detail</li>
      </ol>
    </section>
	<!-- Default box -->
	<div class="box">
		<div id="my_all">
			<div class="table-responsive no-padding">
				<form action="<c:url value='/pdt/update/${pdt.pdt_id }'/>" method="post" id="up-form">
					<table class="table table-striped table-responsive tbl_narrow" id="table">
						<!-- 테이블에 들어갈 행 추가 -->
						<tr>
							<td rowspan="3"><img alt="상품이미지 태그하기" src="" height="300px"></td>
							<td><label>상&nbsp;&nbsp;품&nbsp;&nbsp;명</label></td>
							<td>${pdt.pdt_name }</td>
						</tr>
						<tr>
							<td><label>카테고리 명</label></td>
							<td>${ctg.ctg_name }</td>
						</tr>
						<tr>
							<td><label>상품 가격</label></td>
							<td>${pdt.pdt_cost }</td>
						</tr>
						
						<!-- 들어가는 재료 기입 -->
						<tr>
							<td colspan="3"><label>사용 재료</label></td>
						</tr>
						<tr>
							<th>재료명</th>
							<th>1회 사용량</th>
							<th>Detail</th>
						</tr>
						
						<tr>
							<td>stock name</td>
							<td>stock usage</td>
							<td>stock detail</td>
						</tr>
					</table>
					
					<div id="add-new-btn">
						<label for="expiry_date" class="col-sm-2 control-label"></label>
						<div class="col-xs-6 col-sm-2">
							<input type="button" class="form-control btn btn-success btn-sm btn-submit"
								value="UPDATE" onclick="update()" >
						</div>
						<div class="col-xs-6 col-sm-2">
							<input type="button" class="form-control btn btn-danger btn-sm"
								value="DELETE" onclick="del()" >
						</div>
					</div>
				</form>
						
			</div>
		</div>
	</div>
</div>




<%@ include file="../include/footer.jsp"%>

</body>
</html>