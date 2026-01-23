# Register File (SystemVerilog)

SystemVerilog로 32-bit 레지스터 4개를 가지는 간단한 Register File을 구현한 프로젝트입니다.  
AXI-Lite Slave 설계를 진행하기 전에, 주소 디코드와 레지스터 write/read 동작의 기본 구조를 이해하기 위해 먼저 진행했습니다.

---

## 구현 내용
- 32-bit 레지스터 4개 (reg0 ~ reg3)
- Byte address 기반 주소 디코드
- 동기식(active-low) reset
- write는 always_ff, read는 always_comb로 분리 구현
- 유효하지 않은 주소 접근은 무시하도록 처리

---

## Register Map

| Address | Register |
|--------|----------|
| 0x00 | reg0 |
| 0x04 | reg1 |
| 0x08 | reg2 |
| 0x0C | reg3 |

---

## 설계 메모
- 주소는 레지스터 번호가 아니라 **byte address** 기준으로 처리
- `addr[3:2]`를 이용해 레지스터 인덱스를 계산
- `addr_valid` 신호로 잘못된 주소 접근을 차단
- reset은 항상 최우선으로 동작하도록 구성

---

## 검증
Self-checking testbench를 작성하여 다음을 확인했습니다.

- reset 이후 모든 레지스터 값이 0으로 초기화되는지
- write 후 read 시 정상적으로 값이 읽히는지
- 유효하지 않은 주소 접근 시 write가 발생하지 않는지
- invalid read 시 0이 반환되는지

assert를 사용해 파형을 직접 보지 않아도 PASS/FAIL을 확인할 수 있도록 했습니다.

---

## 시뮬레이션
- Vivado XSim (Behavioral Simulation)
- 모든 테스트 시나리오 PASS  
- 파형과 간단한 결과 요약은 `sim/` 디렉토리에 정리했습니다.

---

## 다음 계획
이 Register File을 기반으로 ready/valid handshaking을 먼저 연습한 뒤,  
AXI-Lite Slave 인터페이스로 확장할 예정입니다.
