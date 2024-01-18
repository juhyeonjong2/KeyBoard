<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="allkeyboard.vo.ProductView" %>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="java.util.ArrayList"%>
<%
	request.setCharacterEncoding("UTF-8");

	
	String brand = request.getParameter("brand");
	String type = request.getParameter("type");

	ArrayList<ProductView> productList = new ArrayList<ProductView>(); 
	
	DBManager db = new DBManager();
	if(db.connect()){
		
		/* String sql = "SELECT P.pno as pno, P.pname as pname, P.price as price, P.brand as brand, " 
		           + " P.description as description, P.inventory as inventory, "
				   + " A.pfrealname as realanme, A.pforeignname as systemname "
		  		   + " FROM product P "
		  		   + " LEFT JOIN productattach A "
		  		   + " ON P.pno = A.pno"
				   + " WHERE A.pfidx = 0 AND P.delyn ='n'"; */
		// pfidx =0 인것만 가져오는 방법을 모르겠어서 루프 두번돌림. 위처럼하면 pfidx=0이 없으면 검색이 아예안됨.
				   
		String sql = "SELECT pno, pname, price, brand, type, description, inventory FROM product WHERE delyn='n'";
		
		if(brand!=null && !brand.equals("")){
			sql += " AND brand=?";
			
			if(type!=null && !type.equals("")){
				sql += " AND type=?";
			}
		}
		
		db.prepare(sql);
		
		if(brand!=null && !brand.equals("")){
			db.setString(brand);
			
			if(type!=null && !type.equals("")){
				db.setString(type);
			}
		}
		
		if(db.read())
		{
			while(db.getNext()){
				ProductView product = new ProductView();
				product.setPno(db.getInt("pno"));
				product.setPname(db.getString("pname"));
				product.setPrice(db.getInt("price"));
				product.setBrand(db.getString("brand"));
				//product.setType(db.getString("type"));
				product.setDescription(db.getString("description"));
				product.setInventory(db.getInt("inventory"));
				/* product.setRealFileName(db.getString("realanme"));
				product.setForeignFileName(db.getString("systemname")); */
				productList.add(product);
			}
		}
		
		sql = "SELECT pfrealname, pforeignname FROM productattach WHERE pno=? AND pfidx=0 ";
		for(ProductView product : productList){
			if(db.prepare(sql).setInt(product.getPno()).read()){
				if(db.getNext()){
					product.setRealFileName(db.getString("pfrealname"));
					product.setForeignFileName(db.getString("pforeignname"));
					System.out.println("read r: " + db.getString("pfrealname") );
					System.out.println("read f: " + db.getString("pforeignname") );
				}
			}
		}
		
	 	db.disconnect();
	 	
	 	if(brand == null || brand.equals(""))
	 	{
	 		brand = "모든";
	 	}
	}
	
	int size = productList.size();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product/list.css" type="text/css" rel="stylesheet">
</head>
<body>
<%@ include file="/include/header.jsp"%>

 	<main>
		<hr id="main_line">
		<div class="is"><!--임시이름 , 밑에 마진 넣기 위해-->
                <h2 style="height: 100px;"><%=brand%> 키보드</h2>                
<%
            	
				if(size == 0)
				{
%>
				<p class="no_data">
					상품이 없습니다.
				</p>
<%
				}
				else 
				{
%>
                
                <div>
                <ul class="ul1">
<%

                	for(ProductView p : productList)
                	{
                		String saveDir = "image";
    					String foreignFileName = "noimage.png";
                		String realFileName = p.getRealFileName();
                		
                		if(realFileName == null || realFileName.equals("")){
                			realFileName = "noimage.png";
                		}
                		else {
                			saveDir = "image/product";
                			foreignFileName = p.getRealFileName();
                		} 
%>
                
                    <li>
                        <div>
                            <div>
                                <a href="view.jsp?pno=<%=p.getPno()%>">
                                    <img src="<%=request.getContextPath() +"/" + saveDir + "/" + realFileName%>" alt="<%= foreignFileName%>" >
                                </a>
                            </div>
                            <div class="listA">
                                <a href="view.jsp?pno=<%=p.getPno()%>" >
                                    <Strong><%=p.getPname()%></Strong>
                                </a>
                            </div>
                            <div class="listB"><Strong><%=p.getPrice()%></Strong>원</div>
                        </div>
                    </li>
<%
                	}
				
%>
                  
                </ul>
			</div>
        </div>
	</main>
	
 
<%@ include file="/include/footer.jsp"%>
</body>
</html>