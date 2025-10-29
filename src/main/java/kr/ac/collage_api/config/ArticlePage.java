package kr.ac.collage_api.config;

import java.util.List;

//페이징 관련 프로퍼티 + 게시글 프로퍼티
public class ArticlePage<T> {
	private int total;			//전체글 수
	private int currentPage;	// 현재 페이지 번호
	private int totalPages;		// 전체 페이지수
	private int startPage;		// 블록의 시작 번호
	private int endPage;		//블록의 종료 번호
	private String keyword = "";//검색어
	private String url = "";	//요청URL
	private List<T> content;	//select 결과 데이터
	private String pagingArea = "";	//페이징 처리

	//생성자(Constructor) : 페이징 정보를 생성
	//					전체글 수		현재 페이지 번호   한 화면 	  목록 데이터			검색어
	public ArticlePage(int total, int currentPage, int size, List<T> content, String keyword,String url) {
		//size : 한 화면에 보여질 목록의 행 수(10)
		this.total = total;
		this.currentPage = currentPage;
		this.keyword = keyword;
		this.content = content;
		this.url = url;
		
		//전체글 수가 0이면?
		if(total==0) {
			totalPages = 0; //전체 페이지 수
			startPage = 0; //블록 시작번호
			endPage = 0; //블록 종료번호
		}else{//글이 있다면
			//전체 페이지 수 = 전체글 수 / 한 화면에 보여질 목록의 행 수
			//3 = 31 / 10
			totalPages = total / size;	//3.1 -> 3
			
			//나머지가 있다면, 페이지를 1 증가
			// 31    % 10
			if(total % size > 0) {//나머지1
				totalPages++;	//3 -> 4페이지
			}
			
			//페이지 블록시작번호를 구하는 공식
			// 블록시작번호 = 현재페이지 / 블록크기 * 블록크기 + 1
			startPage = currentPage / 5 * 5 + 1; //1
			
			//현재페이지 % 블록크기 => 0일 때 보정	
			if(currentPage % 5 == 0) {
				startPage -= 5;
			}			
			
			//블록종료번호 = 블록시작번호 + (블록크기 - 1)
			//[1][2][3][다음]
			endPage = startPage + (5 - 1); 
			
			//블록종료번호 > 전체페이지수
			if(endPage > totalPages) {
				endPage = totalPages;
			}
		}//end if	
		
		//비동기 처리일 경우 pagingArea 가 필요 없음!
		if (this.url != null || !this.url.isEmpty() ) {
		pagingArea += "<ul class='pagination pagination-sm m-0 justify-content-center'>";
		
        if(this.startPage > 5) {
        	pagingArea += "<li class='page-item'><a class='page-link' href='"+this.url+"?currentPage="+(this.startPage-5)+"&keyword="+this.keyword+"'>«</a></li>";
        }//end if
        
        for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {
        	pagingArea += "<li class='page-item'><a class='page-link' href='"+this.url+"?currentPage="+pNo+"&keyword="+this.keyword+"'>"+pNo+"</a></li>";
        }//end for
        
        if(this.endPage < this.totalPages) {
        	pagingArea += "<li class='page-item'><a class='page-link' href='"+this.url+"currentPage="+(this.startPage+5)+"&keyword="+this.keyword+"'>»</a></li>";
        }//end if
      
        pagingArea += "</ul>";
		}
		
	}//end 생성자

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(int totalPages) {
		this.totalPages = totalPages;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public List<T> getContent() {
		return content;
	}

	public void setContent(List<T> content) {
		this.content = content;
	}

	public String getPagingArea() {
		return pagingArea;
	}

	public void setPagingArea(String pagingArea) {
		this.pagingArea = pagingArea;
	}

	@Override
	public String toString() {
		return "ArticlePage [total=" + total + ", currentPage=" + currentPage + ", totalPages=" + totalPages
				+ ", startPage=" + startPage + ", endPage=" + endPage + ", keyword=" + keyword + ", url=" + url
				+ ", content=" + content + ", pagingArea=" + pagingArea + "]";
	}
	
	
	
}







