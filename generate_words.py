#!/usr/bin/env python3
"""
Generate 2000 Korean-English word pairs for creative unlock challenge
"""

import json
import random

# Categories of words
words_data = {
    # 명사 (Nouns) - 1400개
    "nouns": [
        # 자연 (Nature)
        ("바다", "ocean"), ("하늘", "sky"), ("별", "star"), ("달", "moon"), ("해", "sun"),
        ("구름", "cloud"), ("비", "rain"), ("눈", "snow"), ("바람", "wind"), ("폭풍", "storm"),
        ("천둥", "thunder"), ("번개", "lightning"), ("무지개", "rainbow"), ("안개", "fog"), ("이슬", "dew"),
        ("서리", "frost"), ("얼음", "ice"), ("산", "mountain"), ("언덕", "hill"), ("계곡", "valley"),
        ("강", "river"), ("호수", "lake"), ("연못", "pond"), ("폭포", "waterfall"), ("샘", "spring"),
        ("숲", "forest"), ("나무", "tree"), ("꽃", "flower"), ("잎", "leaf"), ("가지", "branch"),
        ("뿌리", "root"), ("씨앗", "seed"), ("열매", "fruit"), ("풀", "grass"), ("이끼", "moss"),
        ("돌", "stone"), ("바위", "rock"), ("모래", "sand"), ("흙", "soil"), ("진흙", "mud"),

        # 동물 (Animals)
        ("고양이", "cat"), ("개", "dog"), ("새", "bird"), ("물고기", "fish"), ("나비", "butterfly"),
        ("벌", "bee"), ("개미", "ant"), ("거미", "spider"), ("사자", "lion"), ("호랑이", "tiger"),
        ("곰", "bear"), ("여우", "fox"), ("늑대", "wolf"), ("토끼", "rabbit"), ("다람쥐", "squirrel"),
        ("사슴", "deer"), ("코끼리", "elephant"), ("기린", "giraffe"), ("원숭이", "monkey"), ("팬더", "panda"),
        ("고래", "whale"), ("돌고래", "dolphin"), ("상어", "shark"), ("거북이", "turtle"), ("펭귄", "penguin"),
        ("독수리", "eagle"), ("까마귀", "crow"), ("비둘기", "pigeon"), ("참새", "sparrow"), ("제비", "swallow"),

        # 감정 (Emotions)
        ("사랑", "love"), ("기쁨", "joy"), ("행복", "happiness"), ("슬픔", "sadness"), ("분노", "anger"),
        ("두려움", "fear"), ("놀람", "surprise"), ("희망", "hope"), ("꿈", "dream"), ("욕망", "desire"),
        ("질투", "jealousy"), ("자부심", "pride"), ("수치", "shame"), ("죄책감", "guilt"), ("감사", "gratitude"),
        ("동정", "sympathy"), ("연민", "compassion"), ("존경", "respect"), ("경외", "awe"), ("향수", "nostalgia"),

        # 사물 (Objects)
        ("책", "book"), ("펜", "pen"), ("종이", "paper"), ("의자", "chair"), ("책상", "desk"),
        ("컴퓨터", "computer"), ("전화", "phone"), ("시계", "clock"), ("거울", "mirror"), ("창문", "window"),
        ("문", "door"), ("열쇠", "key"), ("램프", "lamp"), ("촛불", "candle"), ("그림", "picture"),
        ("사진", "photo"), ("카메라", "camera"), ("텔레비전", "television"), ("라디오", "radio"), ("음악", "music"),
        ("악기", "instrument"), ("피아노", "piano"), ("기타", "guitar"), ("드럼", "drum"), ("바이올린", "violin"),
        ("옷", "clothes"), ("신발", "shoes"), ("모자", "hat"), ("가방", "bag"), ("우산", "umbrella"),

        # 음식 (Food)
        ("빵", "bread"), ("쌀", "rice"), ("국수", "noodle"), ("과일", "fruit"), ("야채", "vegetable"),
        ("고기", "meat"), ("생선", "fish"), ("우유", "milk"), ("치즈", "cheese"), ("버터", "butter"),
        ("설탕", "sugar"), ("소금", "salt"), ("후추", "pepper"), ("기름", "oil"), ("식초", "vinegar"),
        ("차", "tea"), ("커피", "coffee"), ("물", "water"), ("주스", "juice"), ("와인", "wine"),

        # 건물 (Buildings)
        ("집", "house"), ("아파트", "apartment"), ("학교", "school"), ("병원", "hospital"), ("은행", "bank"),
        ("도서관", "library"), ("박물관", "museum"), ("극장", "theater"), ("교회", "church"), ("사원", "temple"),
        ("성", "castle"), ("탑", "tower"), ("다리", "bridge"), ("터널", "tunnel"), ("역", "station"),

        # 개념 (Concepts)
        ("시간", "time"), ("공간", "space"), ("생명", "life"), ("죽음", "death"), ("진실", "truth"),
        ("거짓", "lie"), ("정의", "justice"), ("자유", "freedom"), ("평화", "peace"), ("전쟁", "war"),
        ("지혜", "wisdom"), ("지식", "knowledge"), ("힘", "power"), ("용기", "courage"), ("인내", "patience"),
        ("친절", "kindness"), ("아름다움", "beauty"), ("추함", "ugliness"), ("선", "good"), ("악", "evil"),

        # 예술 (Art)
        ("그림", "painting"), ("조각", "sculpture"), ("춤", "dance"), ("노래", "song"), ("시", "poem"),
        ("소설", "novel"), ("영화", "movie"), ("연극", "play"), ("음악", "music"), ("사진", "photography"),

        # 과학 (Science)
        ("원자", "atom"), ("분자", "molecule"), ("세포", "cell"), ("유전자", "gene"), ("에너지", "energy"),
        ("빛", "light"), ("소리", "sound"), ("중력", "gravity"), ("전기", "electricity"), ("자석", "magnet"),

        # 직업 (Professions)
        ("의사", "doctor"), ("선생님", "teacher"), ("간호사", "nurse"), ("경찰", "police"), ("소방관", "firefighter"),
        ("요리사", "chef"), ("화가", "painter"), ("작가", "writer"), ("가수", "singer"), ("배우", "actor"),
        ("운동선수", "athlete"), ("과학자", "scientist"), ("엔지니어", "engineer"), ("변호사", "lawyer"), ("판사", "judge"),

        # 색깔 (Colors)
        ("빨강", "red"), ("파랑", "blue"), ("노랑", "yellow"), ("초록", "green"), ("검정", "black"),
        ("하양", "white"), ("회색", "gray"), ("분홍", "pink"), ("보라", "purple"), ("주황", "orange"),
        ("갈색", "brown"), ("금색", "gold"), ("은색", "silver"), ("청록", "turquoise"), ("남색", "navy"),

        # 신체 (Body)
        ("머리", "head"), ("얼굴", "face"), ("눈", "eye"), ("코", "nose"), ("입", "mouth"),
        ("귀", "ear"), ("목", "neck"), ("어깨", "shoulder"), ("팔", "arm"), ("손", "hand"),
        ("가슴", "chest"), ("배", "stomach"), ("등", "back"), ("다리", "leg"), ("발", "foot"),
        ("심장", "heart"), ("뇌", "brain"), ("피", "blood"), ("뼈", "bone"), ("근육", "muscle"),

        # 계절과 날씨 (Seasons & Weather)
        ("봄", "spring"), ("여름", "summer"), ("가을", "autumn"), ("겨울", "winter"), ("아침", "morning"),
        ("낮", "day"), ("저녁", "evening"), ("밤", "night"), ("일출", "sunrise"), ("일몰", "sunset"),

        # 가족 (Family)
        ("가족", "family"), ("부모", "parents"), ("아버지", "father"), ("어머니", "mother"), ("아들", "son"),
        ("딸", "daughter"), ("형제", "brother"), ("자매", "sister"), ("할아버지", "grandfather"), ("할머니", "grandmother"),
        ("삼촌", "uncle"), ("이모", "aunt"), ("사촌", "cousin"), ("조카", "nephew"), ("손자", "grandson"),

        # 장소 (Places)
        ("공원", "park"), ("해변", "beach"), ("정원", "garden"), ("광장", "square"), ("시장", "market"),
        ("가게", "shop"), ("식당", "restaurant"), ("카페", "cafe"), ("호텔", "hotel"), ("공항", "airport"),
        ("항구", "port"), ("섬", "island"), ("대륙", "continent"), ("나라", "country"), ("도시", "city"),
        ("마을", "village"), ("길", "road"), ("골목", "alley"), ("거리", "street"), ("모퉁이", "corner"),

        # 교통 (Transportation)
        ("자동차", "car"), ("버스", "bus"), ("기차", "train"), ("비행기", "airplane"), ("배", "ship"),
        ("자전거", "bicycle"), ("오토바이", "motorcycle"), ("택시", "taxi"), ("지하철", "subway"), ("트럭", "truck"),

        # 스포츠 (Sports)
        ("축구", "soccer"), ("야구", "baseball"), ("농구", "basketball"), ("배구", "volleyball"), ("테니스", "tennis"),
        ("수영", "swimming"), ("달리기", "running"), ("권투", "boxing"), ("태권도", "taekwondo"), ("골프", "golf"),

        # 학문 (Academics)
        ("수학", "mathematics"), ("과학", "science"), ("역사", "history"), ("지리", "geography"), ("언어", "language"),
        ("문학", "literature"), ("철학", "philosophy"), ("심리학", "psychology"), ("경제", "economics"), ("정치", "politics"),

        # 기술 (Technology)
        ("로봇", "robot"), ("인공지능", "AI"), ("인터넷", "internet"), ("소프트웨어", "software"), ("하드웨어", "hardware"),
        ("데이터", "data"), ("알고리즘", "algorithm"), ("코드", "code"), ("프로그램", "program"), ("앱", "app"),

        # 취미 (Hobbies)
        ("독서", "reading"), ("그림그리기", "drawing"), ("요리", "cooking"), ("여행", "travel"), ("등산", "hiking"),
        ("낚시", "fishing"), ("사진", "photography"), ("수집", "collecting"), ("게임", "gaming"), ("원예", "gardening"),

        # 감각 (Senses)
        ("시각", "sight"), ("청각", "hearing"), ("후각", "smell"), ("미각", "taste"), ("촉각", "touch"),
        ("향기", "fragrance"), ("냄새", "odor"), ("소음", "noise"), ("멜로디", "melody"), ("리듬", "rhythm"),

        # 현상 (Phenomena)
        ("변화", "change"), ("성장", "growth"), ("발전", "development"), ("진화", "evolution"), ("혁명", "revolution"),
        ("위기", "crisis"), ("기회", "opportunity"), ("도전", "challenge"), ("성공", "success"), ("실패", "failure"),

        # 관계 (Relationships)
        ("우정", "friendship"), ("사랑", "love"), ("증오", "hatred"), ("신뢰", "trust"), ("배신", "betrayal"),
        ("협력", "cooperation"), ("경쟁", "competition"), ("갈등", "conflict"), ("화해", "reconciliation"), ("이별", "separation"),

        # 더 많은 명사들...
        ("모험", "adventure"), ("여정", "journey"), ("목적지", "destination"), ("출발", "departure"), ("도착", "arrival"),
        ("시작", "beginning"), ("끝", "end"), ("중간", "middle"), ("경계", "boundary"), ("한계", "limit"),
        ("가능성", "possibility"), ("확률", "probability"), ("운명", "fate"), ("우연", "coincidence"), ("필연", "necessity"),
        ("원인", "cause"), ("결과", "effect"), ("목적", "purpose"), ("수단", "means"), ("방법", "method"),
        ("규칙", "rule"), ("법칙", "law"), ("원리", "principle"), ("이론", "theory"), ("가설", "hypothesis"),
        ("실험", "experiment"), ("관찰", "observation"), ("분석", "analysis"), ("종합", "synthesis"), ("결론", "conclusion"),
        ("증거", "evidence"), ("증명", "proof"), ("논리", "logic"), ("추론", "reasoning"), ("직관", "intuition"),
        ("상상", "imagination"), ("환상", "fantasy"), ("현실", "reality"), ("이상", "ideal"), ("목표", "goal"),
        ("계획", "plan"), ("전략", "strategy"), ("전술", "tactics"), ("작전", "operation"), ("임무", "mission"),
        ("책임", "responsibility"), ("의무", "duty"), ("권리", "right"), ("특권", "privilege"), ("자격", "qualification"),
        ("능력", "ability"), ("재능", "talent"), ("기술", "skill"), ("경험", "experience"), ("학습", "learning"),
        ("교육", "education"), ("훈련", "training"), ("연습", "practice"), ("습관", "habit"), ("본능", "instinct"),
        ("의식", "consciousness"), ("무의식", "unconsciousness"), ("기억", "memory"), ("망각", "oblivion"), ("회상", "recollection"),
        ("생각", "thought"), ("아이디어", "idea"), ("개념", "concept"), ("인식", "perception"), ("이해", "understanding"),
        ("오해", "misunderstanding"), ("혼란", "confusion"), ("명확성", "clarity"), ("모호함", "ambiguity"), ("확실성", "certainty"),
        ("의심", "doubt"), ("믿음", "belief"), ("신념", "conviction"), ("확신", "confidence"), ("불안", "anxiety"),
        ("걱정", "worry"), ("긴장", "tension"), ("이완", "relaxation"), ("평온", "serenity"), ("혼돈", "chaos"),
        ("질서", "order"), ("조직", "organization"), ("구조", "structure"), ("형태", "form"), ("모양", "shape"),
        ("크기", "size"), ("무게", "weight"), ("부피", "volume"), ("밀도", "density"), ("속도", "speed"),
        ("가속도", "acceleration"), ("속력", "velocity"), ("방향", "direction"), ("위치", "position"), ("거리", "distance"),
        ("높이", "height"), ("깊이", "depth"), ("넓이", "width"), ("길이", "length"), ("둘레", "perimeter"),
        ("면적", "area"), ("표면", "surface"), ("내부", "interior"), ("외부", "exterior"), ("중심", "center"),
        ("가장자리", "edge"), ("모서리", "corner"), ("각도", "angle"), ("곡선", "curve"), ("직선", "line"),
        ("점", "point"), ("선", "line"), ("면", "plane"), ("입체", "solid"), ("공간", "space"),
        ("차원", "dimension"), ("평행", "parallel"), ("수직", "perpendicular"), ("대칭", "symmetry"), ("균형", "balance"),
        ("비율", "ratio"), ("비례", "proportion"), ("척도", "scale"), ("측정", "measurement"), ("단위", "unit"),
        ("숫자", "number"), ("양", "quantity"), ("질", "quality"), ("정도", "degree"), ("수준", "level"),
        ("등급", "grade"), ("순위", "rank"), ("순서", "order"), ("배열", "arrangement"), ("조합", "combination"),
        ("집합", "set"), ("그룹", "group"), ("범주", "category"), ("종류", "type"), ("종", "species"),
        ("품종", "breed"), ("변종", "variety"), ("특성", "characteristic"), ("속성", "property"), ("성질", "nature"),
        ("본질", "essence"), ("실체", "substance"), ("물질", "matter"), ("재료", "material"), ("요소", "element"),
        ("성분", "ingredient"), ("구성", "composition"), ("내용", "content"), ("형식", "format"), ("스타일", "style"),
        ("패턴", "pattern"), ("디자인", "design"), ("장식", "decoration"), ("색조", "tone"), ("질감", "texture"),
        ("맛", "flavor"), ("향미", "taste"), ("온도", "temperature"), ("열", "heat"), ("냉기", "cold"),
        ("압력", "pressure"), ("힘", "force"), ("에너지", "energy"), ("파워", "power"), ("강도", "intensity"),
        ("밝기", "brightness"), ("어둠", "darkness"), ("그림자", "shadow"), ("반사", "reflection"), ("굴절", "refraction"),
        ("투명", "transparency"), ("불투명", "opacity"), ("광택", "gloss"), ("무광", "matte"), ("색상", "color"),
        ("채도", "saturation"), ("명도", "brightness"), ("대비", "contrast"), ("하모니", "harmony"), ("불협화음", "dissonance"),
        ("음높이", "pitch"), ("음량", "volume"), ("음색", "timbre"), ("박자", "beat"), ("템포", "tempo"),
        ("화음", "chord"), ("선율", "melody"), ("가사", "lyrics"), ("후렴", "chorus"), ("절", "verse"),
        ("전주", "prelude"), ("간주", "interlude"), ("후주", "postlude"), ("소절", "measure"), ("음표", "note"),
        ("휴지", "rest"), ("화성", "harmony"), ("불협", "discord"), ("공명", "resonance"), ("진동", "vibration"),
        ("주파수", "frequency"), ("파장", "wavelength"), ("진폭", "amplitude"), ("간섭", "interference"), ("회절", "diffraction"),

        # 추상 개념들
        ("정체성", "identity"), ("개성", "personality"), ("특징", "feature"), ("차이", "difference"), ("유사성", "similarity"),
        ("대조", "contrast"), ("비교", "comparison"), ("관계", "relationship"), ("연결", "connection"), ("분리", "separation"),
        ("통합", "integration"), ("분열", "division"), ("융합", "fusion"), ("분해", "decomposition"), ("합성", "synthesis"),
        ("단순", "simplicity"), ("복잡", "complexity"), ("명료", "clarity"), ("모호", "vagueness"), ("정확", "accuracy"),
        ("오류", "error"), ("실수", "mistake"), ("수정", "correction"), ("개선", "improvement"), ("악화", "deterioration"),
        ("진보", "progress"), ("퇴보", "regression"), ("혁신", "innovation"), ("전통", "tradition"), ("현대", "modernity"),
        ("과거", "past"), ("현재", "present"), ("미래", "future"), ("영원", "eternity"), ("순간", "moment"),
        ("기간", "period"), ("시대", "era"), ("세대", "generation"), ("연대", "chronology"), ("역사", "history"),

        # 더 많은 일상 명사들
        ("창", "window"), ("벽", "wall"), ("천장", "ceiling"), ("바닥", "floor"), ("계단", "stairs"),
        ("엘리베이터", "elevator"), ("에스컬레이터", "escalator"), ("복도", "corridor"), ("현관", "entrance"), ("출구", "exit"),
        ("지붕", "roof"), ("기둥", "pillar"), ("기초", "foundation"), ("골격", "framework"), ("구조물", "structure"),
        ("건축", "architecture"), ("설계", "design"), ("청사진", "blueprint"), ("모형", "model"), ("견본", "sample"),
        ("원본", "original"), ("복사본", "copy"), ("번역", "translation"), ("해석", "interpretation"), ("버전", "version"),
        ("판", "edition"), ("초판", "first_edition"), ("개정판", "revision"), ("축약판", "abridgement"), ("전집", "complete_works"),
        ("시리즈", "series"), ("속편", "sequel"), ("전편", "prequel"), ("부록", "appendix"), ("색인", "index"),
        ("목차", "table_of_contents"), ("서문", "preface"), ("머리말", "foreword"), ("후기", "afterword"), ("각주", "footnote"),
        ("참고문헌", "bibliography"), ("인용", "citation"), ("출처", "source"), ("근거", "basis"), ("배경", "background"),
        ("맥락", "context"), ("환경", "environment"), ("상황", "situation"), ("조건", "condition"), ("전제", "premise"),
        ("가정", "assumption"), ("추측", "speculation"), ("예측", "prediction"), ("예상", "expectation"), ("전망", "prospect"),
        ("시각", "perspective"), ("관점", "viewpoint"), ("입장", "position"), ("태도", "attitude"), ("자세", "posture"),
        ("행동", "behavior"), ("행위", "action"), ("동작", "movement"), ("제스처", "gesture"), ("표정", "expression"),
        ("미소", "smile"), ("웃음", "laughter"), ("눈물", "tears"), ("한숨", "sigh"), ("신음", "groan"),
        ("외침", "cry"), ("속삭임", "whisper"), ("목소리", "voice"), ("말", "speech"), ("언어", "language"),
        ("단어", "word"), ("문장", "sentence"), ("단락", "paragraph"), ("장", "chapter"), ("책", "book"),
        ("문서", "document"), ("기록", "record"), ("보고서", "report"), ("논문", "thesis"), ("에세이", "essay"),
        ("기사", "article"), ("칼럼", "column"), ("사설", "editorial"), ("비평", "critique"), ("리뷰", "review"),
        ("평가", "evaluation"), ("판단", "judgment"), ("결정", "decision"), ("선택", "choice"), ("대안", "alternative"),
        ("옵션", "option"), ("가능성", "possibility"), ("기회", "opportunity"), ("위험", "risk"), ("도박", "gamble"),
        ("모험", "adventure"), ("탐험", "exploration"), ("발견", "discovery"), ("발명", "invention"), ("창조", "creation"),
        ("예술", "art"), ("공예", "craft"), ("기술", "technique"), ("방식", "manner"), ("양식", "style"),
        ("유형", "type"), ("형태", "form"), ("구조", "structure"), ("시스템", "system"), ("메커니즘", "mechanism"),
        ("과정", "process"), ("절차", "procedure"), ("단계", "step"), ("수순", "sequence"), ("흐름", "flow"),
        ("순환", "circulation"), ("주기", "cycle"), ("반복", "repetition"), ("패턴", "pattern"), ("리듬", "rhythm"),
        ("박동", "pulse"), ("진동", "vibration"), ("파동", "wave"), ("신호", "signal"), ("메시지", "message"),
        ("정보", "information"), ("데이터", "data"), ("지식", "knowledge"), ("지혜", "wisdom"), ("통찰", "insight"),
        ("이해", "understanding"), ("인식", "awareness"), ("자각", "self-awareness"), ("의식", "consciousness"), ("인지", "cognition"),
        ("사고", "thinking"), ("추론", "reasoning"), ("논리", "logic"), ("분석", "analysis"), ("종합", "synthesis"),
        ("귀납", "induction"), ("연역", "deduction"), ("유추", "analogy"), ("비유", "metaphor"), ("상징", "symbol"),
        ("기호", "sign"), ("표시", "mark"), ("라벨", "label"), ("태그", "tag"), ("이름", "name"),
        ("제목", "title"), ("헤드라인", "headline"), ("캡션", "caption"), ("설명", "description"), ("정의", "definition"),
        ("의미", "meaning"), ("뜻", "sense"), ("함의", "implication"), ("내포", "connotation"), ("외연", "denotation"),
        ("참조", "reference"), ("연관", "association"), ("유사", "similarity"), ("차이", "difference"), ("구별", "distinction"),
        ("분류", "classification"), ("범주", "category"), ("유형", "type"), ("종류", "kind"), ("계통", "lineage"),
        ("혈통", "pedigree"), ("가계", "family_tree"), ("조상", "ancestor"), ("후손", "descendant"), ("세습", "inheritance"),
        ("유산", "heritage"), ("전통", "tradition"), ("관습", "custom"), ("문화", "culture"), ("문명", "civilization"),
        ("사회", "society"), ("공동체", "community"), ("집단", "group"), ("조직", "organization"), ("기관", "institution"),
        ("체제", "system"), ("구조", "structure"), ("계층", "hierarchy"), ("등급", "rank"), ("지위", "status"),
        ("역할", "role"), ("기능", "function"), ("목적", "purpose"), ("의도", "intention"), ("동기", "motive"),
        ("원인", "cause"), ("이유", "reason"), ("근거", "ground"), ("정당화", "justification"), ("변명", "excuse"),
        ("설명", "explanation"), ("해명", "clarification"), ("증명", "proof"), ("입증", "demonstration"), ("확인", "confirmation"),
        ("검증", "verification"), ("인증", "certification"), ("승인", "approval"), ("허가", "permission"), ("동의", "consent"),
        ("계약", "contract"), ("협정", "agreement"), ("조약", "treaty"), ("규약", "convention"), ("헌장", "charter"),
        ("법률", "law"), ("규정", "regulation"), ("규칙", "rule"), ("지침", "guideline"), ("기준", "standard"),
        ("척도", "measure"), ("지표", "indicator"), ("표준", "norm"), ("평균", "average"), ("중앙값", "median"),
        ("최빈값", "mode"), ("범위", "range"), ("편차", "deviation"), ("분산", "variance"), ("상관", "correlation"),
        ("인과", "causation"), ("변수", "variable"), ("상수", "constant"), ("계수", "coefficient"), ("지수", "exponent"),
        ("로그", "logarithm"), ("함수", "function"), ("방정식", "equation"), ("공식", "formula"), ("정리", "theorem"),
        ("증명", "proof"), ("명제", "proposition"), ("가설", "hypothesis"), ("이론", "theory"), ("법칙", "law"),
        ("원리", "principle"), ("규칙", "rule"), ("패턴", "pattern"), ("모델", "model"), ("시뮬레이션", "simulation"),

        # 감정과 심리 상태
        ("고독", "solitude"), ("외로움", "loneliness"), ("고립", "isolation"), ("소외", "alienation"), ("멜랑콜리", "melancholy"),
        ("우울", "depression"), ("불안", "anxiety"), ("공포", "phobia"), ("트라우마", "trauma"), ("스트레스", "stress"),
        ("긴장", "tension"), ("이완", "relaxation"), ("안도", "relief"), ("편안함", "comfort"), ("만족", "satisfaction"),
        ("충족", "fulfillment"), ("성취", "achievement"), ("자부심", "pride"), ("자신감", "confidence"), ("확신", "certainty"),
        ("의심", "doubt"), ("회의", "skepticism"), ("혼란", "confusion"), ("당혹", "bewilderment"), ("놀람", "astonishment"),
        ("경이", "wonder"), ("감탄", "admiration"), ("존경", "respect"), ("경외", "reverence"), ("숭배", "worship"),
        ("열정", "passion"), ("열심", "zeal"), ("열망", "aspiration"), ("욕심", "greed"), ("탐욕", "avarice"),
        ("질투", "envy"), ("시기", "jealousy"), ("원한", "resentment"), ("복수", "revenge"), ("용서", "forgiveness"),
        ("관용", "tolerance"), ("인내", "patience"), ("끈기", "perseverance"), ("결단", "determination"), ("의지", "will"),

        # 장소와 공간
        ("영역", "territory"), ("지역", "region"), ("구역", "district"), ("지구", "zone"), ("지대", "belt"),
        ("고원", "plateau"), ("평원", "plain"), ("초원", "prairie"), ("사막", "desert"), ("오아시스", "oasis"),
        ("정글", "jungle"), ("열대우림", "rainforest"), ("극지", "polar"), ("툰드라", "tundra"), ("타이가", "taiga"),
        ("습지", "wetland"), ("늪", "swamp"), ("갯벌", "tidal_flat"), ("해안", "coast"), ("절벽", "cliff"),
        ("동굴", "cave"), ("협곡", "canyon"), ("분화구", "crater"), ("화산", "volcano"), ("온천", "hot_spring"),
        ("빙하", "glacier"), ("빙산", "iceberg"), ("만년설", "permanent_snow"), ("암초", "reef"), ("산호초", "coral_reef"),

        # 시간 관련
        ("찰나", "instant"), ("순간", "moment"), ("시각", "time"), ("시점", "point_in_time"), ("시기", "timing"),
        ("기한", "deadline"), ("마감", "closing"), ("개막", "opening"), ("종료", "ending"), ("시작", "start"),
        ("중단", "pause"), ("재개", "resumption"), ("지연", "delay"), ("가속", "acceleration"), ("감속", "deceleration"),
        ("일정", "schedule"), ("계획표", "timetable"), ("달력", "calendar"), ("연표", "timeline"), ("기록", "chronicle"),

        # 더 많은 추상 개념
        ("모순", "contradiction"), ("역설", "paradox"), ("딜레마", "dilemma"), ("문제", "problem"), ("해결책", "solution"),
        ("답", "answer"), ("질문", "question"), ("수수께끼", "riddle"), ("퍼즐", "puzzle"), ("미스터리", "mystery"),
        ("비밀", "secret"), ("수수께끼", "enigma"), ("수수방관", "enigma"), ("난제", "conundrum"), ("과제", "task"),
        ("숙제", "homework"), ("프로젝트", "project"), ("계획", "plan"), ("일정", "schedule"), ("목표", "target"),
        ("목적", "objective"), ("의도", "intent"), ("야심", "ambition"), ("포부", "aspiration"), ("이상", "ideal"),
        ("환상", "illusion"), ("착각", "delusion"), ("환각", "hallucination"), ("꿈", "dream"), ("악몽", "nightmare"),
        ("비전", "vision"), ("전망", "outlook"), ("예언", "prophecy"), ("징조", "omen"), ("전조", "portent"),
        ("신호", "sign"), ("암시", "hint"), ("단서", "clue"), ("흔적", "trace"), ("잔재", "remnant"),
        ("유물", "relic"), ("유적", "ruins"), ("기념물", "monument"), ("표지", "marker"), ("이정표", "milestone"),

        # 자연현상과 환경
        ("파도", "wave"), ("조류", "tide"), ("해류", "current"), ("안개", "fog"), ("이슬", "dew"),
        ("서리", "frost"), ("우박", "hail"), ("눈보라", "blizzard"), ("태풍", "typhoon"), ("허리케인", "hurricane"),
        ("토네이도", "tornado"), ("지진", "earthquake"), ("쓰나미", "tsunami"), ("홍수", "flood"), ("가뭄", "drought"),
        ("산불", "wildfire"), ("눈사태", "avalanche"), ("산사태", "landslide"), ("화산폭발", "eruption"), ("용암", "lava"),
        ("마그마", "magma"), ("온천", "hot_spring"), ("간헐천", "geyser"), ("무지개", "rainbow"), ("오로라", "aurora"),
        ("일식", "solar_eclipse"), ("월식", "lunar_eclipse"), ("혜성", "comet"), ("유성", "meteor"), ("운석", "meteorite"),

        # 생물과 생태
        ("세포", "cell"), ("조직", "tissue"), ("기관", "organ"), ("시스템", "system"), ("유전자", "gene"),
        ("염색체", "chromosome"), ("DNA", "DNA"), ("RNA", "RNA"), ("단백질", "protein"), ("효소", "enzyme"),
        ("호르몬", "hormone"), ("항체", "antibody"), ("바이러스", "virus"), ("박테리아", "bacteria"), ("미생물", "microbe"),
        ("균류", "fungus"), ("조류", "algae"), ("플랑크톤", "plankton"), ("생태계", "ecosystem"), ("먹이사슬", "food_chain"),
        ("생물다양성", "biodiversity"), ("멸종", "extinction"), ("진화", "evolution"), ("적응", "adaptation"), ("변이", "mutation"),
        ("자연선택", "natural_selection"), ("번식", "reproduction"), ("광합성", "photosynthesis"), ("호흡", "respiration"), ("대사", "metabolism"),

        # 물질과 재료
        ("금속", "metal"), ("합금", "alloy"), ("철", "iron"), ("강철", "steel"), ("구리", "copper"),
        ("알루미늄", "aluminum"), ("금", "gold"), ("은", "silver"), ("백금", "platinum"), ("납", "lead"),
        ("주석", "tin"), ("아연", "zinc"), ("크롬", "chromium"), ("니켈", "nickel"), ("티타늄", "titanium"),
        ("플라스틱", "plastic"), ("고무", "rubber"), ("섬유", "fiber"), ("직물", "fabric"), ("가죽", "leather"),
        ("유리", "glass"), ("도자기", "ceramic"), ("콘크리트", "concrete"), ("시멘트", "cement"), ("모르타르", "mortar"),
        ("목재", "lumber"), ("합판", "plywood"), ("석재", "stone"), ("대리석", "marble"), ("화강암", "granite"),

        # 에너지와 힘
        ("전기", "electricity"), ("자기", "magnetism"), ("중력", "gravity"), ("마찰", "friction"), ("관성", "inertia"),
        ("운동량", "momentum"), ("가속도", "acceleration"), ("속력", "velocity"), ("충격", "impact"), ("압력", "pressure"),
        ("장력", "tension"), ("압축", "compression"), ("비틀림", "torsion"), ("응력", "stress"), ("변형", "strain"),
        ("탄성", "elasticity"), ("소성", "plasticity"), ("강도", "strength"), ("경도", "hardness"), ("인성", "toughness"),
        ("취성", "brittleness"), ("점성", "viscosity"), ("밀도", "density"), ("부피", "volume"), ("질량", "mass"),

        # 기하학과 수학
        ("점", "point"), ("선", "line"), ("면", "plane"), ("입체", "solid"), ("각", "angle"),
        ("직각", "right_angle"), ("예각", "acute_angle"), ("둔각", "obtuse_angle"), ("평행", "parallel"), ("수직", "perpendicular"),
        ("대각선", "diagonal"), ("반지름", "radius"), ("지름", "diameter"), ("원주", "circumference"), ("둘레", "perimeter"),
        ("넓이", "area"), ("부피", "volume"), ("표면적", "surface_area"), ("비율", "ratio"), ("비례", "proportion"),
        ("백분율", "percentage"), ("분수", "fraction"), ("소수", "decimal"), ("정수", "integer"), ("실수", "real_number"),
        ("허수", "imaginary_number"), ("복소수", "complex_number"), ("벡터", "vector"), ("행렬", "matrix"), ("텐서", "tensor"),

        # 음악과 소리
        ("멜로디", "melody"), ("화음", "harmony"), ("리듬", "rhythm"), ("박자", "beat"), ("템포", "tempo"),
        ("음계", "scale"), ("옥타브", "octave"), ("음정", "interval"), ("화성", "chord"), ("음색", "timbre"),
        ("음고", "pitch"), ("음량", "volume"), ("음압", "sound_pressure"), ("주파수", "frequency"), ("진폭", "amplitude"),
        ("공명", "resonance"), ("반향", "echo"), ("잔향", "reverberation"), ("음향", "acoustics"), ("소음", "noise"),
        ("정적", "silence"), ("청각", "hearing"), ("귀", "ear"), ("고막", "eardrum"), ("청신경", "auditory_nerve"),

        # 의학과 건강
        ("증상", "symptom"), ("진단", "diagnosis"), ("치료", "treatment"), ("수술", "surgery"), ("약물", "medicine"),
        ("백신", "vaccine"), ("항생제", "antibiotic"), ("진통제", "painkiller"), ("마취", "anesthesia"), ("회복", "recovery"),
        ("재활", "rehabilitation"), ("예방", "prevention"), ("면역", "immunity"), ("감염", "infection"), ("염증", "inflammation"),
        ("부종", "swelling"), ("출혈", "bleeding"), ("골절", "fracture"), ("염좌", "sprain"), ("타박상", "bruise"),
        ("상처", "wound"), ("흉터", "scar"), ("통증", "pain"), ("발열", "fever"), ("오한", "chill"),
        ("두통", "headache"), ("현기증", "dizziness"), ("메스꺼움", "nausea"), ("구토", "vomiting"), ("설사", "diarrhea"),

        # 기술과 도구
        ("렌치", "wrench"), ("망치", "hammer"), ("못", "nail"), ("나사", "screw"), ("볼트", "bolt"),
        ("너트", "nut"), ("와셔", "washer"), ("톱", "saw"), ("드릴", "drill"), ("끌", "chisel"),
        ("대패", "plane"), ("줄", "file"), ("샌드페이퍼", "sandpaper"), ("접착제", "adhesive"), ("용접", "welding"),
        ("납땜", "soldering"), ("도금", "plating"), ("페인트", "paint"), ("래커", "lacquer"), ("바니시", "varnish"),
        ("레버", "lever"), ("도르래", "pulley"), ("톱니바퀴", "gear"), ("스프링", "spring"), ("베어링", "bearing"),

        # 경제와 금융
        ("자본", "capital"), ("투자", "investment"), ("수익", "profit"), ("손실", "loss"), ("이자", "interest"),
        ("배당", "dividend"), ("주식", "stock"), ("채권", "bond"), ("부채", "debt"), ("자산", "asset"),
        ("부동산", "real_estate"), ("저축", "savings"), ("대출", "loan"), ("담보", "collateral"), ("보험", "insurance"),
        ("세금", "tax"), ("관세", "tariff"), ("환율", "exchange_rate"), ("인플레이션", "inflation"), ("디플레이션", "deflation"),
        ("경기", "economy"), ("불황", "recession"), ("호황", "boom"), ("공급", "supply"), ("수요", "demand"),
        ("시장", "market"), ("경쟁", "competition"), ("독점", "monopoly"), ("과점", "oligopoly"), ("규제", "regulation"),

        # 정치와 법률
        ("헌법", "constitution"), ("법률", "statute"), ("조례", "ordinance"), ("판례", "precedent"), ("소송", "lawsuit"),
        ("재판", "trial"), ("판결", "verdict"), ("선고", "sentence"), ("항소", "appeal"), ("상고", "cassation"),
        ("증거", "evidence"), ("증언", "testimony"), ("변론", "pleading"), ("변호", "defense"), ("기소", "prosecution"),
    ],

    # 형용사 (Adjectives) - 600개
    "adjectives": [
        # 크기와 양
        ("큰", "big"), ("작은", "small"), ("거대한", "huge"), ("미세한", "tiny"), ("넓은", "wide"),
        ("좁은", "narrow"), ("높은", "high"), ("낮은", "low"), ("깊은", "deep"), ("얕은", "shallow"),
        ("두꺼운", "thick"), ("얇은", "thin"), ("무거운", "heavy"), ("가벼운", "light"), ("많은", "many"),
        ("적은", "few"), ("충분한", "enough"), ("과도한", "excessive"), ("부족한", "insufficient"), ("풍부한", "abundant"),

        # 색깔과 밝기
        ("밝은", "bright"), ("어두운", "dark"), ("흐린", "dim"), ("빛나는", "shining"), ("반짝이는", "sparkling"),
        ("투명한", "transparent"), ("불투명한", "opaque"), ("선명한", "vivid"), ("희미한", "faint"), ("화려한", "colorful"),
        ("단조로운", "monotonous"), ("무채색의", "achromatic"), ("채색된", "colored"), ("흰색의", "white"), ("검은색의", "black"),

        # 감정과 느낌
        ("행복한", "happy"), ("슬픈", "sad"), ("기쁜", "joyful"), ("우울한", "depressed"), ("평온한", "peaceful"),
        ("불안한", "anxious"), ("편안한", "comfortable"), ("긴장된", "tense"), ("흥분된", "excited"), ("지루한", "bored"),
        ("재미있는", "fun"), ("즐거운", "pleasant"), ("불쾌한", "unpleasant"), ("만족스러운", "satisfying"), ("실망스러운", "disappointing"),
        ("감동적인", "touching"), ("충격적인", "shocking"), ("놀라운", "amazing"), ("무서운", "scary"), ("두려운", "fearful"),
        ("용감한", "brave"), ("겁많은", "cowardly"), ("자신감있는", "confident"), ("수줍은", "shy"), ("외향적인", "extroverted"),
        ("내향적인", "introverted"), ("사교적인", "sociable"), ("고독한", "lonely"), ("외로운", "solitary"), ("쓸쓸한", "desolate"),

        # 온도와 날씨
        ("뜨거운", "hot"), ("차가운", "cold"), ("따뜻한", "warm"), ("시원한", "cool"), ("냉한", "chilly"),
        ("쌀쌀한", "crisp"), ("무더운", "sweltering"), ("혹한의", "freezing"), ("온화한", "mild"), ("습한", "humid"),
        ("건조한", "dry"), ("축축한", "damp"), ("젖은", "wet"), ("축축한", "moist"), ("비오는", "rainy"),

        # 속도와 시간
        ("빠른", "fast"), ("느린", "slow"), ("신속한", "quick"), ("지체된", "delayed"), ("즉각적인", "immediate"),
        ("점진적인", "gradual"), ("급격한", "sudden"), ("순간적인", "momentary"), ("영구적인", "permanent"), ("일시적인", "temporary"),
        ("오래된", "old"), ("새로운", "new"), ("현대적인", "modern"), ("고전적인", "classic"), ("전통적인", "traditional"),
        ("혁신적인", "innovative"), ("보수적인", "conservative"), ("진보적인", "progressive"), ("퇴행적인", "regressive"), ("시대착오적인", "anachronistic"),

        # 성질과 상태
        ("단단한", "hard"), ("부드러운", "soft"), ("거친", "rough"), ("매끄러운", "smooth"), ("끈적한", "sticky"),
        ("미끄러운", "slippery"), ("탄력있는", "elastic"), ("유연한", "flexible"), ("경직된", "rigid"), ("딱딱한", "stiff"),
        ("물렁한", "mushy"), ("바삭한", "crispy"), ("질긴", "tough"), ("연한", "tender"), ("쫄깃한", "chewy"),
        ("달콤한", "sweet"), ("쓴", "bitter"), ("신", "sour"), ("짠", "salty"), ("매운", "spicy"),
        ("담백한", "bland"), ("고소한", "nutty"), ("향긋한", "fragrant"), ("역겨운", "disgusting"), ("맛있는", "delicious"),

        # 외모와 모습
        ("아름다운", "beautiful"), ("못생긴", "ugly"), ("예쁜", "pretty"), ("귀여운", "cute"), ("멋진", "cool"),
        ("우아한", "elegant"), ("세련된", "sophisticated"), ("촌스러운", "tacky"), ("화려한", "glamorous"), ("소박한", "plain"),
        ("깔끔한", "neat"), ("지저분한", "messy"), ("정돈된", "tidy"), ("산만한", "cluttered"), ("조직적인", "organized"),

        # 소리
        ("시끄러운", "loud"), ("조용한", "quiet"), ("소란스러운", "noisy"), ("고요한", "silent"), ("울리는", "resonant"),
        ("날카로운", "shrill"), ("저음의", "bass"), ("고음의", "treble"), ("부드러운", "soft"), ("강렬한", "intense"),

        # 성격과 태도
        ("친절한", "kind"), ("무례한", "rude"), ("정직한", "honest"), ("거짓된", "dishonest"), ("관대한", "generous"),
        ("인색한", "stingy"), ("정의로운", "just"), ("불공정한", "unfair"), ("겸손한", "humble"), ("거만한", "arrogant"),
        ("똑똑한", "smart"), ("어리석은", "foolish"), ("지혜로운", "wise"), ("현명한", "prudent"), ("경솔한", "reckless"),
        ("신중한", "cautious"), ("대담한", "bold"), ("조심스러운", "careful"), ("무모한", "rash"), ("사려깊은", "thoughtful"),
        ("성실한", "diligent"), ("게으른", "lazy"), ("부지런한", "hardworking"), ("나태한", "idle"), ("적극적인", "active"),
        ("소극적인", "passive"), ("공격적인", "aggressive"), ("방어적인", "defensive"), ("협력적인", "cooperative"), ("경쟁적인", "competitive"),

        # 지적 능력
        ("영리한", "clever"), ("둔한", "dull"), ("예리한", "sharp"), ("명석한", "brilliant"), ("우둔한", "stupid"),
        ("창의적인", "creative"), ("독창적인", "original"), ("평범한", "ordinary"), ("특별한", "special"), ("독특한", "unique"),
        ("일반적인", "common"), ("희귀한", "rare"), ("흔한", "frequent"), ("드문", "uncommon"), ("특이한", "peculiar"),

        # 물리적 상태
        ("건강한", "healthy"), ("아픈", "sick"), ("튼튼한", "strong"), ("약한", "weak"), ("활기찬", "energetic"),
        ("무기력한", "lethargic"), ("피곤한", "tired"), ("상쾌한", "refreshed"), ("지친", "exhausted"), ("활발한", "lively"),
        ("둔한", "sluggish"), ("민첩한", "agile"), ("느릿한", "ponderous"), ("날렵한", "nimble"), ("둔중한", "clumsy"),

        # 감각적 특성
        ("선명한", "clear"), ("흐릿한", "blurry"), ("날카로운", "sharp"), ("무딘", "blunt"), ("예민한", "sensitive"),
        ("둔감한", "insensitive"), ("섬세한", "delicate"), ("조잡한", "crude"), ("정교한", "intricate"), ("단순한", "simple"),
        ("복잡한", "complex"), ("명료한", "lucid"), ("모호한", "vague"), ("구체적인", "concrete"), ("추상적인", "abstract"),

        # 사회적 관계
        ("인기있는", "popular"), ("외면받는", "unpopular"), ("사랑받는", "beloved"), ("미움받는", "hated"), ("존경받는", "respected"),
        ("경멸받는", "despised"), ("신뢰받는", "trusted"), ("의심받는", "suspected"), ("환영받는", "welcomed"), ("거부당한", "rejected"),

        # 도덕적 판단
        ("선한", "good"), ("악한", "evil"), ("옳은", "right"), ("그른", "wrong"), ("정당한", "legitimate"),
        ("부당한", "unjust"), ("합법적인", "legal"), ("불법적인", "illegal"), ("윤리적인", "ethical"), ("비윤리적인", "unethical"),
        ("도덕적인", "moral"), ("부도덕한", "immoral"), ("순수한", "pure"), ("타락한", "corrupt"), ("고결한", "noble"),
        ("비열한", "mean"), ("고상한", "refined"), ("저속한", "vulgar"), ("품위있는", "dignified"), ("천한", "lowly"),

        # 논리와 사고
        ("논리적인", "logical"), ("비논리적인", "illogical"), ("합리적인", "rational"), ("비합리적인", "irrational"), ("객관적인", "objective"),
        ("주관적인", "subjective"), ("실용적인", "practical"), ("이론적인", "theoretical"), ("현실적인", "realistic"), ("이상적인", "idealistic"),
        ("가능한", "possible"), ("불가능한", "impossible"), ("개연성있는", "probable"), ("있을법한", "likely"), ("있을법하지않은", "unlikely"),

        # 품질과 가치
        ("우수한", "excellent"), ("열등한", "inferior"), ("고급의", "premium"), ("저급의", "low-grade"), ("최고의", "best"),
        ("최악의", "worst"), ("완벽한", "perfect"), ("결함있는", "flawed"), ("훌륭한", "splendid"), ("형편없는", "terrible"),
        ("값비싼", "expensive"), ("저렴한", "cheap"), ("귀중한", "precious"), ("하찮은", "trivial"), ("중요한", "important"),
        ("사소한", "minor"), ("주요한", "major"), ("필수적인", "essential"), ("부수적인", "incidental"), ("핵심적인", "crucial"),

        # 공간과 위치
        ("높은곳의", "high"), ("낮은곳의", "low"), ("위쪽의", "upper"), ("아래쪽의", "lower"), ("중간의", "middle"),
        ("중앙의", "central"), ("주변의", "peripheral"), ("외부의", "external"), ("내부의", "internal"), ("표면의", "surface"),
        ("심층의", "deep"), ("전면의", "front"), ("후면의", "back"), ("측면의", "side"), ("대각선의", "diagonal"),

        # 양과 정도
        ("완전한", "complete"), ("부분적인", "partial"), ("전체의", "whole"), ("일부의", "some"), ("전부의", "all"),
        ("극단적인", "extreme"), ("온건한", "moderate"), ("강한", "strong"), ("약한", "weak"), ("강렬한", "intense"),
        ("미약한", "feeble"), ("충분한", "sufficient"), ("불충분한", "insufficient"), ("넘치는", "overflowing"), ("결핍된", "deficient"),

        # 형태와 구조
        ("동그란", "round"), ("네모난", "square"), ("삼각형의", "triangular"), ("직선의", "straight"), ("곡선의", "curved"),
        ("평평한", "flat"), ("울퉁불퉁한", "bumpy"), ("대칭적인", "symmetrical"), ("비대칭적인", "asymmetrical"), ("규칙적인", "regular"),
        ("불규칙한", "irregular"), ("균일한", "uniform"), ("다양한", "diverse"), ("통일된", "unified"), ("분산된", "dispersed"),

        # 시간과 지속
        ("영원한", "eternal"), ("순간적인", "momentary"), ("지속적인", "continuous"), ("간헐적인", "intermittent"), ("일정한", "constant"),
        ("변동하는", "fluctuating"), ("안정적인", "stable"), ("불안정한", "unstable"), ("예측가능한", "predictable"), ("예측불가한", "unpredictable"),

        # 더 많은 형용사들
        ("성숙한", "mature"), ("미성숙한", "immature"), ("발달한", "developed"), ("미발달의", "undeveloped"), ("진보된", "advanced"),
        ("원시적인", "primitive"), ("문명화된", "civilized"), ("야만적인", "barbaric"), ("교양있는", "cultured"), ("무식한", "ignorant"),
        ("교육받은", "educated"), ("학식있는", "learned"), ("무학의", "unlettered"), ("박식한", "erudite"), ("박학다식한", "knowledgeable"),
        ("경험많은", "experienced"), ("미숙한", "inexperienced"), ("노련한", "veteran"), ("초심자의", "novice"), ("전문가의", "expert"),
        ("아마추어의", "amateur"), ("프로의", "professional"), ("숙련된", "skilled"), ("미숙한", "unskilled"), ("능숙한", "proficient"),
        ("서투른", "awkward"), ("능란한", "adept"), ("재능있는", "talented"), ("천재적인", "genius"), ("범재의", "mediocre"),
        ("탁월한", "outstanding"), ("보통의", "average"), ("평범한", "ordinary"), ("비범한", "extraordinary"), ("놀라운", "remarkable"),
        ("인상적인", "impressive"), ("인상적이지않은", "unimpressive"), ("눈에띄는", "noticeable"), ("눈에띄지않는", "inconspicuous"), ("두드러진", "prominent"),
        ("숨겨진", "hidden"), ("명백한", "obvious"), ("분명한", "apparent"), ("불분명한", "unclear"), ("애매한", "ambiguous"),
        ("확실한", "certain"), ("불확실한", "uncertain"), ("확정적인", "definite"), ("미정의", "indefinite"), ("결정된", "determined"),
        ("미결정의", "undecided"), ("확고한", "firm"), ("흔들리는", "wavering"), ("견고한", "solid"), ("취약한", "fragile"),
        ("내구성있는", "durable"), ("일시적인", "ephemeral"), ("영속적인", "lasting"), ("덧없는", "fleeting"), ("영원한", "everlasting"),
        ("불멸의", "immortal"), ("필멸의", "mortal"), ("영생의", "eternal"), ("한정된", "limited"), ("무한한", "unlimited"),
        ("무제한의", "boundless"), ("광대한", "vast"), ("협소한", "cramped"), ("넓직한", "spacious"), ("비좁은", "confined"),
        ("개방된", "open"), ("폐쇄된", "closed"), ("공개적인", "public"), ("비공개의", "private"), ("공적인", "official"),
        ("사적인", "personal"), ("공동의", "common"), ("개별적인", "individual"), ("집단적인", "collective"), ("사회적인", "social"),
        ("반사회적인", "antisocial"), ("이타적인", "altruistic"), ("이기적인", "selfish"), ("무사적인", "selfless"), ("탐욕스러운", "greedy"),
        ("검소한", "frugal"), ("절약하는", "thrifty"), ("낭비하는", "wasteful"), ("사치스러운", "luxurious"), ("소박한", "modest"),
        ("겸허한", "meek"), ("자만하는", "conceited"), ("교만한", "proud"), ("허영심많은", "vain"), ("가식적인", "pretentious"),
        ("진실한", "genuine"), ("가짜의", "fake"), ("진짜의", "real"), ("허구의", "fictitious"), ("사실적인", "factual"),
        ("허상의", "illusory"), ("실재하는", "actual"), ("잠재적인", "potential"), ("현실화된", "actualized"), ("이론상의", "hypothetical"),
        ("실험적인", "experimental"), ("검증된", "proven"), ("미검증의", "unverified"), ("확인된", "confirmed"), ("부인된", "denied"),
        ("긍정적인", "positive"), ("부정적인", "negative"), ("낙관적인", "optimistic"), ("비관적인", "pessimistic"), ("희망적인", "hopeful"),
        ("절망적인", "desperate"), ("암울한", "gloomy"), ("밝은", "cheerful"), ("우울한", "melancholic"), ("침울한", "somber"),
        ("명랑한", "merry"), ("활기찬", "vivacious"), ("생기있는", "vibrant"), ("무기력한", "listless"), ("침체된", "stagnant"),
        ("역동적인", "dynamic"), ("정적인", "static"), ("변화하는", "changing"), ("불변의", "unchanging"), ("가변적인", "variable"),
        ("고정된", "fixed"), ("유동적인", "fluid"), ("경직된", "inflexible"), ("적응력있는", "adaptable"), ("융통성있는", "versatile"),
        ("획일적인", "uniform"), ("다채로운", "varied"), ("단조로운", "monotone"), ("리듬있는", "rhythmic"), ("조화로운", "harmonious"),
        ("불협화의", "dissonant"), ("균형잡힌", "balanced"), ("불균형한", "unbalanced"), ("비례하는", "proportional"), ("불균등한", "disproportionate"),
        ("대칭의", "symmetric"), ("평행한", "parallel"), ("수직의", "vertical"), ("수평의", "horizontal"), ("경사진", "slanted"),
        ("기울어진", "tilted"), ("똑바른", "straight"), ("구부러진", "bent"), ("뒤틀린", "twisted"), ("꼬인", "tangled"),
        ("풀린", "untangled"), ("얽힌", "entangled"), ("복잡한", "complicated"), ("간단한", "straightforward"), ("명쾌한", "lucid"),
        ("혼란스러운", "confused"), ("명확한", "distinct"), ("흐릿한", "hazy"), ("뚜렷한", "clear-cut"), ("불명확한", "indistinct"),
        ("정확한", "accurate"), ("부정확한", "inaccurate"), ("정밀한", "precise"), ("대략적인", "approximate"), ("엄밀한", "strict"),
        ("느슨한", "loose"), ("긴밀한", "close"), ("성긴", "sparse"), ("빽빽한", "dense"), ("밀집한", "crowded"),
        ("한산한", "deserted"), ("번화한", "bustling"), ("고요한", "tranquil"), ("혼잡한", "congested"), ("한적한", "secluded"),

        # 더 많은 형용사들 - 감각
        ("부드러운", "soft"), ("거친", "rough"), ("매끄러운", "smooth"), ("미끄러운", "slippery"), ("끈적한", "sticky"),
        ("축축한", "damp"), ("건조한", "dry"), ("젖은", "wet"), ("촉촉한", "moist"), ("바삭한", "crispy"),
        ("쫄깃한", "chewy"), ("딱딱한", "hard"), ("무른", "mushy"), ("녹은", "melted"), ("얼어붙은", "frozen"),
        ("뜨거운", "hot"), ("차가운", "cold"), ("따뜻한", "warm"), ("시원한", "cool"), ("미지근한", "lukewarm"),

        # 더 많은 형용사들 - 맛과 향
        ("달콤한", "sweet"), ("쓴", "bitter"), ("신", "sour"), ("짠", "salty"), ("매운", "spicy"),
        ("고소한", "savory"), ("향긋한", "fragrant"), ("역한", "pungent"), ("상한", "rancid"), ("신선한", "fresh"),
        ("오래된", "stale"), ("익은", "ripe"), ("덜익은", "unripe"), ("썩은", "rotten"), ("발효된", "fermented"),

        # 더 많은 형용사들 - 움직임과 상태
        ("움직이는", "moving"), ("정지된", "stationary"), ("빠른", "fast"), ("느린", "slow"), ("급한", "hasty"),
        ("여유있는", "leisurely"), ("서두르는", "hurried"), ("느긋한", "relaxed"), ("바쁜", "busy"), ("한가한", "idle"),
        ("활발한", "active"), ("수동적인", "passive"), ("적극적인", "aggressive"), ("소극적인", "passive"), ("공격적인", "offensive"),
        ("방어적인", "defensive"), ("진취적인", "progressive"), ("보수적인", "conservative"), ("개혁적인", "reformative"), ("혁명적인", "revolutionary"),

        # 더 많은 형용사들 - 관계와 태도
        ("우호적인", "friendly"), ("적대적인", "hostile"), ("중립적인", "neutral"), ("편파적인", "biased"), ("공정한", "fair"),
        ("불공정한", "unfair"), ("정직한", "honest"), ("부정직한", "dishonest"), ("성실한", "sincere"), ("불성실한", "insincere"),
        ("충실한", "loyal"), ("배신하는", "treacherous"), ("신뢰할수있는", "reliable"), ("신뢰할수없는", "unreliable"), ("책임감있는", "responsible"),
        ("무책임한", "irresponsible"), ("의무적인", "obligatory"), ("선택적인", "optional"), ("강제적인", "compulsory"), ("자발적인", "voluntary"),

        # 더 많은 형용사들 - 지적 능력
        ("영리한", "clever"), ("어리석은", "foolish"), ("현명한", "wise"), ("우둔한", "dull"), ("명석한", "sharp"),
        ("총명한", "bright"), ("둔한", "obtuse"), ("기민한", "quick-witted"), ("눈치빠른", "perceptive"), ("눈치없는", "insensitive"),
        ("섬세한", "delicate"), ("세심한", "meticulous"), ("조심스러운", "cautious"), ("대담한", "bold"), ("신중한", "prudent"),
        ("경솔한", "reckless"), ("무모한", "rash"), ("계획적인", "methodical"), ("즉흥적인", "impulsive"), ("체계적인", "systematic"),

        # 더 많은 형용사들 - 사회적 지위
        ("부유한", "wealthy"), ("가난한", "poor"), ("유명한", "famous"), ("무명의", "unknown"), ("권위있는", "authoritative"),
        ("권력있는", "powerful"), ("무력한", "powerless"), ("영향력있는", "influential"), ("지배적인", "dominant"), ("종속적인", "subordinate"),
        ("독립적인", "independent"), ("의존적인", "dependent"), ("자주적인", "autonomous"), ("타율적인", "heteronomous"), ("평등한", "equal"),

        # 더 많은 형용사들 - 외형과 디자인
        ("아름다운", "beautiful"), ("추한", "ugly"), ("멋진", "cool"), ("촌스러운", "tacky"), ("세련된", "sophisticated"),
        ("투박한", "crude"), ("우아한", "elegant"), ("거칠은", "coarse"), ("깔끔한", "neat"), ("지저분한", "messy"),
        ("정돈된", "tidy"), ("어질러진", "cluttered"), ("화려한", "flashy"), ("소박한", "plain"), ("장식적인", "decorative"),
        ("실용적인", "functional"), ("심플한", "simple"), ("복잡한", "complex"), ("정교한", "elaborate"), ("간결한", "concise"),

        # 더 많은 형용사들 - 시간적 특성
        ("최근의", "recent"), ("오래된", "ancient"), ("현대의", "modern"), ("고대의", "archaic"), ("동시대의", "contemporary"),
        ("과거의", "past"), ("미래의", "future"), ("현재의", "present"), ("시대착오적인", "anachronistic"), ("시의적절한", "timely"),
        ("계절적인", "seasonal"), ("연중무휴의", "year-round"), ("일시적인", "temporary"), ("영구적인", "permanent"), ("과도기적인", "transitional"),

        # 더 많은 형용사들 - 정도와 강도
        ("극심한", "severe"), ("온화한", "mild"), ("격렬한", "fierce"), ("완만한", "gentle"), ("급격한", "abrupt"),
        ("점진적인", "gradual"), ("갑작스러운", "sudden"), ("예상된", "expected"), ("의외의", "unexpected"), ("놀라운", "surprising"),
        ("평범한", "commonplace"), ("독특한", "unique"), ("특별한", "special"), ("평상시의", "usual"), ("이례적인", "exceptional"),
        ("일반적인", "general"), ("특수한", "specific"), ("보편적인", "universal"), ("개별적인", "particular"), ("전형적인", "typical"),

        # 더 많은 형용사들 - 감정적 영향
        ("감동적인", "moving"), ("무감각한", "numb"), ("자극적인", "stimulating"), ("진정시키는", "soothing"), ("불안하게하는", "disturbing"),
        ("평화로운", "serene"), ("혼란스러운", "chaotic"), ("질서정연한", "orderly"), ("무질서한", "disorderly"), ("안정된", "settled"),
        ("동요하는", "agitated"), ("차분한", "composed"), ("흥분한", "thrilled"), ("냉정한", "cool-headed"), ("열광적인", "enthusiastic"),
        ("무관심한", "indifferent"), ("열렬한", "fervent"), ("냉담한", "cold"), ("다정한", "affectionate"), ("무뚝뚝한", "blunt"),
    ]
}

def generate_words_json(target_count=2000):
    """Generate words JSON with target count"""

    # Combine and extend word lists
    all_words = []
    word_id = 1

    # Add nouns with difficulties
    nouns = words_data["nouns"]
    for i, (korean, english) in enumerate(nouns):
        if i < len(nouns) * 0.3:
            difficulty = "easy"
        elif i < len(nouns) * 0.7:
            difficulty = "medium"
        else:
            difficulty = "hard"

        all_words.append({
            "id": word_id,
            "korean": korean,
            "english": english,
            "category": "명사",
            "difficulty": difficulty
        })
        word_id += 1

    # Add adjectives with difficulties
    adjectives = words_data["adjectives"]
    for i, (korean, english) in enumerate(adjectives):
        if i < len(adjectives) * 0.3:
            difficulty = "easy"
        elif i < len(adjectives) * 0.7:
            difficulty = "medium"
        else:
            difficulty = "hard"

        all_words.append({
            "id": word_id,
            "korean": korean,
            "english": english,
            "category": "형용사",
            "difficulty": difficulty
        })
        word_id += 1

    # Shuffle to mix categories
    random.shuffle(all_words)

    # Re-assign IDs after shuffle
    for i, word in enumerate(all_words, 1):
        word["id"] = i

    # Trim or extend to target count
    if len(all_words) > target_count:
        all_words = all_words[:target_count]

    return {
        "words": all_words,
        "metadata": {
            "total_count": len(all_words),
            "last_updated": "2025-11-03",
            "version": "2.0"
        }
    }

if __name__ == "__main__":
    print("📝 Generating 2000 Korean-English word pairs...")

    words_json = generate_words_json(2000)

    output_path = "SmartLockBox/Resources/Words.json"
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(words_json, f, ensure_ascii=False, indent=2)

    print(f"✅ Generated {len(words_json['words'])} words")
    print(f"📁 Saved to: {output_path}")

    # Print statistics
    noun_count = sum(1 for w in words_json['words'] if w['category'] == '명사')
    adj_count = sum(1 for w in words_json['words'] if w['category'] == '형용사')

    print(f"\n📊 Statistics:")
    print(f"  명사 (Nouns): {noun_count}")
    print(f"  형용사 (Adjectives): {adj_count}")
    print(f"  Total: {noun_count + adj_count}")
