## Project
> 전국 와인 지도로 시작하여 
> 전국 와알못들이 와잘알이 되도록 하는 앱입니다 
> 프로젝트 기간 : 2022.12 ~ 2022.02
<br>

## Team member

|수진 와인|문어 와인|
|:-:|:-:|
|<img src="" width=200>|<img src="" width=200>|
|[@sudingcream](https://github.com/sudingcream)|[@gjansdyd](https://github.com/gjansdyd)|

## Coding Convention

<details>
<summary> 한 사람이 짠 것처럼 보이게 하는 마법 🤸🏻‍♀️ </summary>
<div markdown="1">

## **임포트**
모듈 임포트는 알파벳 순으로 정렬합니다. 내장 프레임워크를 먼저 임포트하고, 빈 줄로 구분하여 서드파티 프레임워크를 임포트합니다.

```swift
import UIKit

import RxCocoa
import RxSwift
```

### UpperCamelCase

- class
- struct
- extension
- protocol
- enum

### lowerCamelCase

- function
- method
- instance

### **IBAction**

onClick + 동사원형 + 목적어 

ex) onClickStartButton

## **MARK 주석**

**// MARK: - Properties**

**// MARK: - @IBOutlet Properties**

**// MARK: - @IBAction Properties**

**// MARK: - View Life Cycle**

**// MARK: - Extensions**

**// MARK: - UITableViewDataSource**

**// MARK: - UITableViewDelegate** 프로토콜들 Extension 으로 빼기

// TODO: -

// FIXME: -

### **기타 규칙**
- `viewDidLoad()`에서는 **함수호출만**
- 함수는 `extension`에 정의하고 정리
    - `extension`은 목적에 따라 분류

</div>
</details>
<br>


## 아키텍처 및 디자인 패턴
* RxSwift + MVVM 
* Code + Storyboard로 UI 구현 

<br>



