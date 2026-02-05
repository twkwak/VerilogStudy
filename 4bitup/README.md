# 4-bit Microprocessor Design (Verilog)

본 프로젝트는 컴퓨터 구조 및 CPU 설계 강의 자료를 기반으로  
Verilog HDL을 사용하여 4비트 마이크로프로세서를 직접 설계 및 구현한 개인 프로젝트입니다.

단순한 모듈 구현이 아닌, 명령어의 Fetch–Decode–Execute 흐름과  
제어 신호 및 데이터 경로의 관계를 이해하고 RTL 수준에서 구현하는 것을 목표로 했습니다.

---

## 프로젝트 개요

- Processor Width: 4-bit  
- Architecture: 단일 사이클 기반 마이크로프로세서  
- Language: Verilog HDL  
- Design Level: RTL  

---

## 전체 구조

프로세서는 다음과 같은 주요 블록으로 구성됩니다.

- Program Counter (PC)
- Instruction ROM
- Instruction Decoder
- Control Block / Control Signal Generator
- ALU
- Accumulator (ACC)
- Register Modules
- Peripheral Logic (7-segment display)

상위 모듈에서 각 서브모듈을 연결하여 하나의 프로세서로 동작하도록 구성했습니다.

---

## 파일 구조

```text
acc.v              - Accumulator
alu.v              - Arithmetic Logic Unit
aluNacc.v          - ALU + ACC 결합 모듈
control_block.v    - 전체 제어 로직
control_signal.v   - 제어 신호 생성
decoder.v          - Instruction Decoder
pc.v               - Program Counter
reg4.v             - 4-bit Register
reg8.v             - 8-bit Register
shreg.v            - Shift Register
ringCounter.v      - Ring Counter

fa.v               - Full Adder
ha.v               - Half Adder
mx4to1.v           - 4:1 Multiplexer
hex2dec.v          - Hex to Decimal 변환

rom.coe            - Instruction Memory 초기화 파일

seg7x8.v           - 7-Segment Display 제어

processor.v        - Processor Core
prog_module.v      - Program 관련 모듈
top_processor.v    - Top Module
```

---

## Instruction Flow

1. Fetch  
   - Program Counter가 ROM 주소를 가리킴  
   - 명령어를 Instruction Memory에서 읽음  

2. Decode  
   - Decoder가 opcode를 해석  
   - Control Signal 생성  

3. Execute  
   - ALU 연산 수행  
   - Accumulator 및 Register 업데이트  
   - PC 증가 또는 분기  

---

## 주요 설계 포인트

### Control Signal 분리
- 명령어 해석과 제어 신호 생성을 분리하여 설계
- Datapath와 Control Logic의 역할을 명확히 구분

### ALU와 Accumulator 구조
- ALU와 ACC를 독립적으로 설계 후 결합
- 연산 결과 흐름을 명확히 파악 가능

### 모듈 단위 설계
- 가산기, MUX, 레지스터 등 최소 단위부터 구현
- 조합 논리 → 순차 논리 → 상위 모듈 순으로 단계적 설계

---

## 시뮬레이션 및 검증

- 각 서브 모듈 단위로 기능 검증 수행
- ROM 초기화 파일을 통해 간단한 프로그램 실행 확인
- 실행 결과를 7-segment display로 출력하여 동작 확인

---

## 사용 기술

- Verilog HDL
- RTL Design
- CPU Architecture
- Combinational Logic
- Sequential Logic

---

## 프로젝트 의의

- CPU 내부 동작을 이론이 아닌 RTL 코드로 직접 구현
- 제어 신호와 데이터 경로의 관계를 실제 설계를 통해 이해
- 이후 SoC, CPU, RTL 설계 학습을 위한 기반 프로젝트

---

## 향후 개선 방향

- Multi-cycle 구조 확장
- Instruction Set 확장
- Pipeline 구조 도입
- Testbench 고도화

---

## 참고

본 프로젝트는 강의 자료를 기반으로 학습 목적으로 진행되었으며,  
모든 Verilog 코드는 직접 작성 및 구조 설계를 수행했습니다.
