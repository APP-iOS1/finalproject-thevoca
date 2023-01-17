# 앱 기능 상세 정리

<aside>
💡 지원 기기 : 아이패드(메인), 아이폰(서브)
</aside>

## 단어장 추가 및 삭제

- 단어장 추가
  - 단어장 이름 입력 및 어떤 언어를 사용할지 선택
- 단어장 삭제
  - 단어장 메뉴에서 관리 버튼을 누르고 왼쪽으로 스와이프하여 삭제
  - 단어장 메뉴에서 길게 눌러 뜨는 컨텍스트 메뉴에서 삭제

## 단어 추가 및 삭제

- 단어 추가
  - 단어가 추가될 단어장에서 진행가능
  - 단순 추가 : 우상단 추가 버튼을 눌러서 나오는 창에서 단어와 뜻, 언어마다의 옵션을 선택하고 추가
  - 외부 파일로 추가 : csv 파일을 import하여 추가(파일 형식은 언어마다 제공되어야 함)
- 단어 삭제
  - 단어를 길게 눌러 뜨는 컨텍스트 메뉴에서 삭제
  - 단어를 길게 눌러 뜨는 컨텍스트 메뉴에서 `선택`을 고르고 여러개의 단어를 체크하여 한번에 삭제
  - 왼쪽으로 스와이프하여 삭제 → 제스처를 오해할 수 있어서 선택 뷰에서만 가능하게 할지 고려 필요

## 시험

- 시험 전에 사용자가 우상단 랜덤 정렬 버튼을 통해 단어의 순서를 랜덤으로 정렬가능
- 3가지의 시험 모드가 제공됨
  - 단어시험(단어가 가려짐)
  - 의미시험(의미가 가려짐)
  - 받아쓰기 - 아이패드에서만 가능(TTS를 듣고 직접 단어와 뜻, 혹은 둘중 하나를 써야함)
- 기본적인 시험 방법 : 가려진 단어나 의미는 해당 줄을 탭하면 내용이 보여짐
- 아이패드에서 애플펜슬로 시험보기
  - 애플펜슬로 시험보기 모드에서는 애플펜슬로 답을 직접 쓰면 필기 인식이 되어서 답이 써지고, 채점되는 방식
  - 필기 인식률이 필체에 따라 다를 수 있으므로 바로 채점하기와 확인 후 채점하기를 설정 가능
- 시험 결과 처리
  - 단어별 정답 맞춘 횟수를 카운트하여 정답이었던 횟수가 일정이상(ex. 5회)이면 외운 단어로 분류
  - 반대로 틀린 횟수를 카운트하여 많이 틀렸던 단어 혹은 외우기 어려웠던 단어로 분류하여 모아보기 제공

## 암기 여부 체크

- 사용자가 직접 암기여부를 체크 가능
- 아직 암기하지 못한 단어만 모아서 보여주기

## 기타

- 단어장의 데이터는 iCloud에 저장되어 기기간의 연동을 제공
- 단어를 읽어주는 기능(TTS) 지원

## 추가 참고 의견

- 다른 사용자가 만들어놓은 단어장을 다운로드 받아서 사용가능(단어장 공유) by. 유승태 (22.11.28 추가)
- 단어장 기본 화면에서 단어가 보여지는 뷰를 오른쪽으로 스와이프 하여 최근 5번의 시험결과를 순서대로 나열하여 볼 수 있도록 함 ex) ❌ ✅ ✅ ❌ ✅  by. 유승태 (22.11.28 추가)
- 잘 안 외워졌던 단어들을 차트화해서 시각적으로 보여주기 by. 고정민 (22.11.28 추가)
- 단어를 추가하는 방식 : OCR로 단어를 추가 by. 고정민 (22.11.28 추가)
  → OCR의 다중언어 인식에 대한 확인 필요
- 단어장 및 마이노트가 보여지는게 굿노트 노트처럼 노트북 형태로 보여지면 좋을 것 같음 by. 박성민(22.12.01 추가)
- 등록한 단어 뿐 아니라 사전API와 연동한 검색기능 강화도 필요하다고 생각됨 by. 박성민(22.12.01 추가)