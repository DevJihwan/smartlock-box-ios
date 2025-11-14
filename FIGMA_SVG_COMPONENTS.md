# 씽크프리 앱 메인 화면 - SVG 컴포넌트

## 사용 방법
1. 각 SVG 코드를 복사
2. Figma에서 Cmd+V (붙여넣기)
3. 크기 조정 및 색상 변경 가능

---

## 1. 원형 프로그레스 바 (Circular Progress)

### 기본 상태 (69% - Yellow Warning)
```svg
<svg width="200" height="200" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Background Circle -->
  <circle cx="100" cy="100" r="85" stroke="#F3F4F6" stroke-width="15" fill="none"/>
  
  <!-- Progress Circle (69%) -->
  <circle 
    cx="100" 
    cy="100" 
    r="85" 
    stroke="#FACC15" 
    stroke-width="15" 
    fill="none"
    stroke-linecap="round"
    stroke-dasharray="534.07"
    stroke-dashoffset="165.56"
    transform="rotate(-90 100 100)"
  />
  
  <!-- Time Used -->
  <text x="100" y="85" font-family="Pretendard, -apple-system" font-size="40" font-weight="700" fill="#111827" text-anchor="middle">1h 23m</text>
  
  <!-- Divider -->
  <line x1="70" y1="100" x2="130" y2="100" stroke="#D1D5DB" stroke-width="2"/>
  
  <!-- Time Limit -->
  <text x="100" y="125" font-family="Pretendard, -apple-system" font-size="20" font-weight="500" fill="#6B7280" text-anchor="middle">2h 00m</text>
</svg>
```

### 안전 구간 (30% - Green)
```svg
<svg width="200" height="200" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="85" stroke="#F3F4F6" stroke-width="15" fill="none"/>
  <circle 
    cx="100" 
    cy="100" 
    r="85" 
    stroke="#22C55E" 
    stroke-width="15" 
    fill="none"
    stroke-linecap="round"
    stroke-dasharray="534.07"
    stroke-dashoffset="373.85"
    transform="rotate(-90 100 100)"
  />
  <text x="100" y="85" font-family="Pretendard, -apple-system" font-size="40" font-weight="700" fill="#111827" text-anchor="middle">36m</text>
  <line x1="70" y1="100" x2="130" y2="100" stroke="#D1D5DB" stroke-width="2"/>
  <text x="100" y="125" font-family="Pretendard, -apple-system" font-size="20" font-weight="500" fill="#6B7280" text-anchor="middle">2h 00m</text>
</svg>
```

### 위험 구간 (95% - Red)
```svg
<svg width="200" height="200" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="100" cy="100" r="85" stroke="#F3F4F6" stroke-width="15" fill="none"/>
  <circle 
    cx="100" 
    cy="100" 
    r="85" 
    stroke="#F43F5E" 
    stroke-width="15" 
    fill="none"
    stroke-linecap="round"
    stroke-dasharray="534.07"
    stroke-dashoffset="26.70"
    transform="rotate(-90 100 100)"
  />
  <text x="100" y="85" font-family="Pretendard, -apple-system" font-size="40" font-weight="700" fill="#111827" text-anchor="middle">1h 54m</text>
  <line x1="70" y1="100" x2="130" y2="100" stroke="#D1D5DB" stroke-width="2"/>
  <text x="100" y="125" font-family="Pretendard, -apple-system" font-size="20" font-weight="500" fill="#6B7280" text-anchor="middle">2h 00m</text>
</svg>
```

---

## 2. 토글 스위치 (Toggle Switch)

### OFF 상태
```svg
<svg width="280" height="60" viewBox="0 0 280 60" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Track -->
  <rect width="280" height="60" rx="30" fill="#F3F4F6"/>
  
  <!-- Thumb (Left position) -->
  <g filter="url(#shadow)">
    <circle cx="30" cy="30" r="26" fill="#FFFFFF"/>
  </g>
  
  <!-- Label -->
  <text x="140" y="38" font-family="Pretendard, -apple-system" font-size="16" font-weight="600" fill="#6B7280" text-anchor="middle">OFF</text>
  
  <!-- Shadow filter -->
  <defs>
    <filter id="shadow" x="-4" y="-2" width="60" height="64" filterUnits="userSpaceOnUse">
      <feGaussianBlur stdDeviation="2" result="blur"/>
      <feOffset dx="0" dy="2" result="offsetBlur"/>
      <feFlood flood-color="#000000" flood-opacity="0.1"/>
      <feComposite in2="offsetBlur" operator="in"/>
      <feMerge>
        <feMergeNode/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>
</svg>
```

### ON 상태
```svg
<svg width="280" height="60" viewBox="0 0 280 60" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Track (Blue) -->
  <rect width="280" height="60" rx="30" fill="#34AADC"/>
  
  <!-- Thumb (Right position) -->
  <g filter="url(#shadow)">
    <circle cx="250" cy="30" r="26" fill="#FFFFFF"/>
  </g>
  
  <!-- Label -->
  <text x="140" y="38" font-family="Pretendard, -apple-system" font-size="16" font-weight="600" fill="#FFFFFF" text-anchor="middle">ON</text>
  
  <!-- Shadow filter -->
  <defs>
    <filter id="shadow" x="220" y="2" width="60" height="64" filterUnits="userSpaceOnUse">
      <feGaussianBlur stdDeviation="2" result="blur"/>
      <feOffset dx="0" dy="2" result="offsetBlur"/>
      <feFlood flood-color="#000000" flood-opacity="0.1"/>
      <feComposite in2="offsetBlur" operator="in"/>
      <feMerge>
        <feMergeNode/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>
</svg>
```

---

## 3. 시간대 카드 (Time Slot Card)

```svg
<svg width="345" height="140" viewBox="0 0 345 140" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Card Background -->
  <rect width="345" height="140" rx="16" fill="#FFFFFF"/>
  <rect width="345" height="140" rx="16" stroke="#E5E7EB" stroke-width="1"/>
  
  <!-- Clock Icon -->
  <circle cx="30" cy="30" r="16" stroke="#6B7280" stroke-width="2" fill="none"/>
  <path d="M30 22 L30 30 L35 35" stroke="#6B7280" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <!-- Title -->
  <text x="60" y="38" font-family="Pretendard, -apple-system" font-size="20" font-weight="600" fill="#111827">제어 시간대</text>
  
  <!-- Time Display -->
  <text x="172.5" y="85" font-family="Pretendard, -apple-system" font-size="28" font-weight="600" fill="#111827" text-anchor="middle">오전 9:00 ~ 오후 6:00</text>
  
  <!-- Limit Text -->
  <text x="172.5" y="115" font-family="Pretendard, -apple-system" font-size="17" font-weight="400" fill="#6B7280" text-anchor="middle">2시간 제한</text>
</svg>
```

---

## 4. 상태 배너 (Status Banner)

### 경고 배너 (Warning)
```svg
<svg width="345" height="64" viewBox="0 0 345 64" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="345" height="64" rx="12" fill="#FEF3C7"/>
  
  <!-- Warning Icon -->
  <circle cx="28" cy="32" r="12" fill="#F59E0B"/>
  <text x="28" y="38" font-family="system-ui" font-size="18" font-weight="700" fill="#FFFFFF" text-anchor="middle">!</text>
  
  <!-- Message -->
  <text x="52" y="36" font-family="Pretendard, -apple-system" font-size="16" font-weight="600" fill="#92400E">37분 후 잠금됩니다</text>
</svg>
```

### 성공 배너 (Success)
```svg
<svg width="345" height="64" viewBox="0 0 345 64" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="345" height="64" rx="12" fill="#D1FAE5"/>
  
  <!-- Success Icon -->
  <circle cx="28" cy="32" r="12" fill="#10B981"/>
  <path d="M22 32 L26 36 L34 28" stroke="#FFFFFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
  
  <!-- Message -->
  <text x="52" y="36" font-family="Pretendard, -apple-system" font-size="16" font-weight="600" fill="#065F46">안전 구간입니다</text>
</svg>
```

### 위험 배너 (Danger)
```svg
<svg width="345" height="64" viewBox="0 0 345 64" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="345" height="64" rx="12" fill="#FEE2E2"/>
  
  <!-- Danger Icon -->
  <circle cx="28" cy="32" r="12" fill="#EF4444"/>
  <text x="28" y="38" font-family="system-ui" font-size="18" font-weight="700" fill="#FFFFFF" text-anchor="middle">!</text>
  
  <!-- Message -->
  <text x="52" y="36" font-family="Pretendard, -apple-system" font-size="16" font-weight="600" fill="#991B1B">⚠️ 곧 잠금됩니다!</text>
</svg>
```

---

## 5. 메인 화면 전체 레이아웃 (Complete Layout)

```svg
<svg width="393" height="852" viewBox="0 0 393 852" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Background -->
  <rect width="393" height="852" fill="#FFFFFF"/>
  
  <!-- Header -->
  <text x="24" y="50" font-family="Pretendard, -apple-system" font-size="20" font-weight="700" fill="#111827">ThinkFree</text>
  <text x="345" y="50" font-family="Pretendard, -apple-system" font-size="14" font-weight="500" fill="#6B7280">KR</text>
  <text x="369" y="50" font-family="Pretendard, -apple-system" font-size="14" font-weight="400" fill="#D1D5DB">EN</text>
  
  <!-- Time Slot -->
  <circle cx="196.5" cy="120" r="16" stroke="#6B7280" stroke-width="2" fill="none"/>
  <path d="M196.5 112 L196.5 120 L201.5 125" stroke="#6B7280" stroke-width="2" stroke-linecap="round"/>
  
  <text x="196.5" y="168" font-family="Pretendard, -apple-system" font-size="28" font-weight="600" fill="#111827" text-anchor="middle">오전 9:00 ~ 오후 6:00</text>
  <text x="196.5" y="195" font-family="Pretendard, -apple-system" font-size="17" font-weight="400" fill="#6B7280" text-anchor="middle">2시간 제한</text>
  
  <!-- Divider -->
  <line x1="24" y1="225" x2="369" y2="225" stroke="#E5E7EB" stroke-width="1"/>
  
  <!-- Circular Progress Placeholder -->
  <circle cx="196.5" cy="365" r="85" stroke="#F3F4F6" stroke-width="15" fill="none"/>
  <circle cx="196.5" cy="365" r="85" stroke="#FACC15" stroke-width="15" fill="none" stroke-linecap="round" stroke-dasharray="534.07" stroke-dashoffset="165.56" transform="rotate(-90 196.5 365)"/>
  
  <text x="196.5" y="350" font-family="Pretendard, -apple-system" font-size="40" font-weight="700" fill="#111827" text-anchor="middle">1h 23m</text>
  <line x1="166.5" y1="365" x2="226.5" y2="365" stroke="#D1D5DB" stroke-width="2"/>
  <text x="196.5" y="390" font-family="Pretendard, -apple-system" font-size="20" font-weight="500" fill="#6B7280" text-anchor="middle">2h 00m</text>
  
  <text x="196.5" y="480" font-family="Pretendard, -apple-system" font-size="15" font-weight="400" fill="#6B7280" text-anchor="middle">37분 남음</text>
  
  <!-- Divider -->
  <line x1="24" y1="520" x2="369" y2="520" stroke="#E5E7EB" stroke-width="1"/>
  
  <!-- Toggle Switch Placeholder -->
  <rect x="56.5" y="560" width="280" height="60" rx="30" fill="#F3F4F6"/>
  <circle cx="86.5" cy="590" r="26" fill="#FFFFFF"/>
  <text x="196.5" y="598" font-family="Pretendard, -apple-system" font-size="16" font-weight="600" fill="#6B7280" text-anchor="middle">OFF</text>
  
  <text x="196.5" y="650" font-family="Pretendard, -apple-system" font-size="15" font-weight="500" fill="#6B7280" text-anchor="middle">제어 비활성</text>
  
  <!-- Settings Button -->
  <circle cx="184" cy="770" r="12" stroke="#6B7280" stroke-width="2" fill="none"/>
  <path d="M184 764 L184 770 M184 770 L184 776 M179 770 L189 770 M181 766 L187 774 M181 774 L187 766" stroke="#6B7280" stroke-width="1.5" stroke-linecap="round"/>
  <text x="209" y="776" font-family="Pretendard, -apple-system" font-size="17" font-weight="500" fill="#374151">설정</text>
</svg>
```

---

## 💡 사용 팁

### Figma에서 색상 변경하기
1. SVG 붙여넣기 후 선택
2. 우측 패널 Fill/Stroke에서 색상 변경
3. 디자인 시스템 색상 사용:
   - Primary Blue: #34AADC
   - Success Green: #22C55E
   - Warning Yellow: #FACC15
   - Danger Red: #F43F5E

### 애니메이션 추가 (프로토타입)
1. 토글 스위치: Smart Animate 사용
2. 프로그레스 바: stroke-dashoffset 값 변경

### 반응형 조정
- Auto Layout 적용 권장
- Constraints 설정으로 화면 크기 대응

---

**작성일**: 2025년 11월 14일  
**버전**: 1.0  
**앱**: 씽크프리 (ThinkFree)
