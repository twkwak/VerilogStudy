# Register File 설계 (SystemVerilog)

SystemVerilog를 이용하여 32-bit 레지스터 4개로 구성된 Register File을 설계하고,  
self-checking Testbench를 통해 동작을 검증한 프로젝트입니다.

---

## 1. 프로젝트 개요

- 프로젝트 목적:  
  AXI-Lite Slave 설계를 진행하기 전에, 레지스터 기반 설계와 주소 디코드 구조를 명확히 이해하기 위함

- 설계 대상:  
  32-bit Register File (4 entries)

- 사용 언어 / 툴:  
  SystemVerilog, Vivado (Behavioral Simulation)

- 설계 수준:  
  RTL 설계 및 Behavioral Simulation

본 프로젝트에서는 레지스터 write/read의 기본 동작과  
byte address 기반 주소 디코드를 직접 구현하고 검증하는 것을 목표로 하였습니다.

---

## 2. 설계 배경 및 목표

AXI 인터페이스를 바로 구현하기 전에,  
레지스터 파일의 동작 원리와 주소 처리 방식을 먼저 정리할 필요가 있다고 판단하여 본 프로젝트를 진행했습니다.

특히 다음 개념을 중점적으로 학습하고자 했습니다.

- byte address 기반 주소 디코드
- 순차 논리(write)와 조합 논리(read)의 분리
- 동기식 reset의 동작 방식
- assertion 기반 self-checking 검증 흐름

---

## 3. 전체 구조

본 설계는 단일 Register File 모듈을 중심으로 구성되어 있습니다.

- 입력 주소(`addr`)를 기반으로 레지스터 인덱스 디코드
- write enable과 유효 주소 조건에서 레지스터 값 갱신
- read enable 조건에서 해당 레지스터 값 출력

데이터 흐름과 제어 흐름을 단순하게 유지하여  
레지스터 동작의 본질에 집중할 수 있도록 설계하였습니다.

---

## 4. 파일 구조

reg-file-sv/
├── rtl/
│ └── reg_file.sv - Register File RTL 설계
├── tb/
│ └── tb_reg_file.sv - Self-checking Testbench
├── sim/
│ ├── waveform.png - 시뮬레이션 파형
│ └── sim_result.txt - 시뮬레이션 결과 요약
└── README.md


---

## 5. 주요 설계 포인트

### 5.1 핵심 모듈

**reg_file.sv**

- 32-bit 레지스터 4개로 구성
- `addr[3:2]`를 이용해 레지스터 인덱스 산출
- `addr_valid` 신호로 유효하지 않은 주소 접근 차단
- write는 `always_ff`, read는 `always_comb`로 분리 구현

### 5.2 설계 시 고려사항

- reset은 항상 최우선으로 동작하도록 구성
- write 동작은 `we && addr_valid` 조건에서만 수행
- read 동작은 `re && addr_valid` 조건에서만 유효
- 유효하지 않은 주소 read 시 0 반환 정책 적용

---

## 6. 검증 방법

Vivado XSim을 사용하여 Behavioral Simulation을 수행하였습니다.

Testbench는 task와 assertion을 활용한 self-checking 방식으로 구성하였으며,
다음 항목들을 검증하였습니다.

- reset 이후 모든 레지스터 초기화 여부
- write 이후 read 동작의 정상 여부
- 유효하지 않은 주소 접근 시 write 차단 여부
- invalid read 시 0 반환 여부

파형을 직접 확인하지 않아도 PASS/FAIL을 판단할 수 있도록 구성하였습니다.

---

## 7. 결과 및 의의

- 모든 테스트 시나리오에서 정상 동작 확인
- 레지스터 설계와 주소 디코드에 대한 이해도 향상
- write/read 경로 분리 설계의 중요성 체감
- assertion 기반 검증 흐름에 대한 경험 확보

AXI-Lite Slave 설계를 위한 기초 구조를 명확히 정리할 수 있었습니다.

---
