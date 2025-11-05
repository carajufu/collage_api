package kr.ac.collage_api;

import org.eclipse.tags.shaded.org.apache.bcel.classfile.InnerClass;

public class test {

	private String name1 = "변수1";
	private String name2 = "변수2";
	public void method() {
		InnerClass c = new InnerClass();
		c.method2();
	}
		public class InnerClass {
			private String name = "변수3";
			String name2 = "변수4";
			public void method2() {
				String name = "변수5";
				
				InnerClass name2 = new InnerClass();
				System.out.print("변수5");
				
				
			}
		}
		
	public static void main(String[] args) {
		
	}
}
