#  Ready / Valid Handshake 기반 1-Depth FIFO

##  프로젝트 개요
본 프로젝트는 AXI / AXI-Lite 인터페이스의 핵심 개념인 ready/valid handshake를 이해하기 위한 미니 프로젝트이다.  
신호 개수나 복잡한 버스 구조가 아닌, 데이터 전송의 본질(backpressure, 데이터 안정성, valid 유지 규칙)에 집중하였다.

AXI 진입 전 반드시 이해해야 하는 개념을 1-depth FIFO(single-entry buffer) 형태로 구현하고,  
랜덤 backpressure 환경에서 self-checking 테스트벤치로 검증하였다.

---

##  프로젝트 목표
- ready / valid handshake의 본질적인 동작 원리 이해
- backpressure 발생 시 데이터 안정성 보장
- valid 신호의 유지 규칙 체득
- AXI 채널을 FIFO 관점에서 해석하는 사고 방식 습득

---

##  설계 사양

### 인터페이스
입력/출력 신호 구성은 다음과 같다.

    in_valid   : 입력 데이터 유효 신호
    in_ready   : FIFO 입력 가능 신호
    in_data    : 입력 데이터 (32-bit)

    out_valid  : 출력 데이터 유효 신호
    out_ready  : 소비자 준비 신호
    out_data   : 출력 데이터 (32-bit)

### 내부 상태
- full  
  FIFO에 유효한 데이터가 존재하는지 나타내는 플래그
- storage  
  1개의 데이터(word)를 저장하는 레지스터

### Handshake 이벤트 정의
- push = in_valid & in_ready  
- pop  = out_valid & out_ready  

push / pop 각각이 정확히 데이터 1개의 이동을 의미한다.

---

##  동작 원리

### Ready / Valid 규칙
- in_ready = ~full  
  → FIFO가 비어 있을 때만 입력 허용
- out_valid = full  
  → FIFO에 데이터가 있을 때만 출력 유효

### 핵심 설계 포인트
- out_valid = 1 이고 out_ready = 0 인 동안  
  → out_data는 절대 변경되면 안 됨
- out_valid는 데이터가 소비(pop)될 때까지  
  → 반드시 유지되어야 함

이 규칙들은 AXI 프로토콜의 요구사항과 완전히 동일하다.

---

##  검증(Testbench) 전략

### Testbench 특징
- Self-checking 구조
- 랜덤 backpressure (out_ready 랜덤 제어)
- 랜덤 입력 트래픽 (in_valid 랜덤 생성)
- Reference model 기반 자동 비교
- Assertion을 이용한 프로토콜 위반 검출

### 검증 항목
- stall 상황에서 데이터 안정성
- stall 상황에서 valid 유지 규칙

위반 발생 시 즉시 시뮬레이션을 종료하도록 구성하였다.

---

##  프로젝트를 통해 얻은 핵심 인사이트
- ready/valid는 신호 묶음이 아니라 FIFO의 push/pop 이벤트
- 데이터의 의미는 값이 아니라 valid 신호가 결정
- backpressure 처리는 옵션이 아니라 필수
- AXI 채널은 각각 독립적인 FIFO로 해석 가능

---
