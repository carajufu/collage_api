package kr.ac.collage_api.security;

import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;

@Component
public class AdminHandoverCodeStore {
	// 코드 의도: ADMIN 핸드오버용 1회용 코드 발급·검증
	private final ConcurrentHashMap<String, Entry> store = new ConcurrentHashMap<>();
	
	private static record Entry(String acntId, long expEpoch) {}
	
	public String issue(String acntId){ 
		String c=UUID.randomUUID().toString(); 
		store.put(c, new Entry(acntId, System.currentTimeMillis()+120_000)); 
		return c; }
	
	public String consume(String code){ 
		var e=store.remove(code); 
		if(e==null||e.expEpoch()<System.currentTimeMillis()) 
			return null; return e.acntId(); }
}