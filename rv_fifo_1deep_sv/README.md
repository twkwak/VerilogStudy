# Ready / Valid Handshake 기반 1-Depth FIFO

한 줄 요약  
Ready / Valid Handshake의 본질을 이해하기 위해 1-depth FIFO를 설계하고,  
랜덤 backpressure 환경에서 self-checking 테스트벤치로 검증한 미니 프로젝트

---

## 1. 프로젝트 개요

- 프로젝트 목적:  
  AXI/AXI-Lite 인터페이스의 핵심 개념인 ready/valid handshake를 정확히 이해하고,  
  backpressure 상황에서 데이터 안정성과 valid 유지 규칙을 체득하기 위함

- 설계 대상:  
  Ready / Valid Handshake 기반 1-depth FIFO (Single Entry Buffer)

- 사용 언어 / 툴:  
  SystemVerilog, Vivado

- 설계 수준:  
  RTL

본 프로젝트에서는 AXI 진입 전 필수 개념인 ready/valid 프로토콜을  
가장 단순한 1-depth FIFO 구조로 구현하여,  
데이터 전송의 본질을 명확히 이해하는 것을 목표로 하였다.

---

## 2. 설계 배경 및 목표

- 프로젝트를 진행하게 된 배경  
  AXI 프로토콜 학습 과정에서 신호의 개수보다  
  ready/valid handshake 자체를 이해하는 것이 더 중요하다고 판단하여 시작함

- 학습 또는 구현하고자 한 핵심 개념  
  - ready / valid handshake의 의미  
  - backpressure 발생 시 동작  
  - valid 유지 규칙  
  - 데이터 안정성 보장

- 중점적으로 다룬 설계 요소  
  - push / pop 이벤트 정의  
  - stall 상황에서의 데이터 고정  
  - handshake 기반 데이터 이동 모델링

---

## 3. 전체 구조

본 설계는 단일 데이터 엔트리를 가지는 FIFO 구조로 구성되어 있다.

- 주요 구성 블록  
  - storage : 데이터 1개를 저장하는 레지스터  
  - full    : FIFO에 유효 데이터 존재 여부를 나타내는 상태 플래그

- 데이터 흐름  
  - in_valid & in_ready  → push 발생 (데이터 입력)  
  - out_valid & out_ready → pop 발생 (데이터 출력)

- 제어 흐름  
  - full 상태에 따라 in_ready / out_valid 결정  
  - push / pop 이벤트에 따라 상태 갱신

---

## 4. 파일 구조

파일명 - 역할 설명

rv_fifo_1deep.sv  
- Ready / Valid Handshake 기반 1-depth FIFO RTL 설계

tb_rv_fifo_1deep.sv  
- 랜덤 backpressure 환경에서 검증하는 self-checking 테스트벤치

---

## 5. 주요 설계 포인트

### 5.1 핵심 모듈

- rv_fifo_1deep  
  - Ready / Valid Handshake 규칙을 만족하는 단일 엔트리 FIFO  
  - full 플래그를 기준으로 입력/출력 handshake 제어  
  - push / pop 이벤트를 통해 데이터 이동을 명확히 모델링

### 5.2 설계 시 고려사항

- 제어 신호 설계  
  - in_ready = ~full  
  - out_valid = full  

- 데이터 경로 구성  
  - storage 레지스터는 full=1일 때만 의미를 가짐  
  - stall 상황에서 데이터가 변경되지 않도록 설계

- 타이밍 및 동기화  
  - push / pop은 조합논리로 정의  
  - 상태(full, storage)는 always_ff 기반으로 동기화

---

## 6. 검증 방법

- 시뮬레이션 환경  
  - Vivado Behavioral Simulation

- 테스트 방식  
  - 랜덤 in_valid 생성  
  - 랜덤 out_ready 생성(backpressure 유도)  
  - Reference model을 이용한 자동 비교

- 검증 포인트  
  - stall(out_valid=1, out_ready=0) 시 데이터 안정성  
  - valid 유지 규칙 위반 여부  
  - push / pop 이벤트 정합성

---

## 7. 결과 및 의의

- 구현 결과 요약  
  - 랜덤 backpressure 환경에서 모든 테스트 PASS  
  - 데이터 안정성 및 valid 유지 규칙 검증 완료

- 프로젝트를 통해 얻은 점  
  - ready/valid를 FIFO의 push/pop 이벤트로 해석하는 사고 습득  
  - AXI 채널을 독립적인 FIFO로 바라보는 관점 확립

- 설계적으로 성장한 부분  
  - 프로토콜 기반 설계 사고  
  - self-checking 테스트벤치 작성 경험  
  - assertion을 이용한 자동 검증 경험

---
