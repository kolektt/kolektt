# Kolektt API 문서

## 1. 개요

이 문서는 Kolektt 애플리케이션에서 사용되는 API들의 상세 명세를 제공합니다.

## 2. Discogs API

### 2.1 기본 정보

- Base URL: `https://api.discogs.com`
- 인증: OAuth 1.0a
- 요청 제한: 분당 60회

### 2.2 엔드포인트

#### 2.2.1 검색 API

```http
GET /database/search
```

**파라미터:**
- `q`: 검색어 (필수)
- `type`: 검색 타입 (release, master, artist, label)
- `page`: 페이지 번호
- `per_page`: 페이지당 결과 수

**응답 예시:**
```json
{
  "pagination": {
    "page": 1,
    "pages": 10,
    "per_page": 50,
    "items": 500
  },
  "results": [
    {
      "id": 12345,
      "title": "Album Title",
      "year": 2020,
      "cover_image": "https://example.com/cover.jpg",
      "genre": ["Rock", "Pop"],
      "style": ["Alternative", "Indie"]
    }
  ]
}
```

#### 2.2.2 릴리스 상세 정보

```http
GET /releases/{id}
```

**파라미터:**
- `id`: 릴리스 ID (필수)

**응답 예시:**
```json
{
  "id": 12345,
  "title": "Album Title",
  "artists": [
    {
      "name": "Artist Name",
      "id": 67890
    }
  ],
  "labels": [
    {
      "name": "Label Name",
      "id": 54321
    }
  ],
  "year": 2020,
  "genres": ["Rock", "Pop"],
  "styles": ["Alternative", "Indie"],
  "tracklist": [
    {
      "position": "1",
      "title": "Track 1",
      "duration": "3:45"
    }
  ],
  "images": [
    {
      "type": "primary",
      "uri": "https://example.com/cover.jpg",
      "width": 500,
      "height": 500
    }
  ]
}
```

## 3. Supabase API

### 3.1 기본 정보

- Base URL: `https://[project-ref].supabase.co`
- 인증: JWT 토큰
- 데이터베이스: PostgreSQL

### 3.2 테이블 구조

#### 3.2.1 users

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 3.2.2 collections

```sql
CREATE TABLE collections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  discogs_id INTEGER,
  title TEXT NOT NULL,
  artist TEXT,
  year INTEGER,
  genre TEXT[],
  condition TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 3.3 REST API

#### 3.3.1 컬렉션 조회

```http
GET /rest/v1/collections?select=*
```

**헤더:**
- `Authorization: Bearer {jwt_token}`
- `apikey: {supabase_key}`

**응답 예시:**
```json
[
  {
    "id": "uuid",
    "user_id": "uuid",
    "discogs_id": 12345,
    "title": "Album Title",
    "artist": "Artist Name",
    "year": 2020,
    "genre": ["Rock", "Pop"],
    "condition": "Mint",
    "created_at": "2023-01-01T00:00:00Z",
    "updated_at": "2023-01-01T00:00:00Z"
  }
]
```

#### 3.3.2 컬렉션 추가

```http
POST /rest/v1/collections
```

**헤더:**
- `Authorization: Bearer {jwt_token}`
- `apikey: {supabase_key}`
- `Content-Type: application/json`

**요청 본문:**
```json
{
  "discogs_id": 12345,
  "title": "Album Title",
  "artist": "Artist Name",
  "year": 2020,
  "genre": ["Rock", "Pop"],
  "condition": "Mint"
}
```

## 4. 이미지 인식 API

### 4.1 기본 정보

- 제공자: Google ML Kit
- 기능: 이미지 라벨링, 텍스트 인식
- 요청 제한: 일일 1000회

### 4.2 엔드포인트

#### 4.2.1 이미지 라벨링

```http
POST /v1/images:annotate
```

**헤더:**
- `Authorization: Bearer {api_key}`
- `Content-Type: application/json`

**요청 본문:**
```json
{
  "requests": [
    {
      "image": {
        "content": "base64_encoded_image"
      },
      "features": [
        {
          "type": "LABEL_DETECTION",
          "maxResults": 10
        }
      ]
    }
  ]
}
```

**응답 예시:**
```json
{
  "responses": [
    {
      "labelAnnotations": [
        {
          "description": "album cover",
          "score": 0.95
        },
        {
          "description": "music",
          "score": 0.85
        }
      ]
    }
  ]
}
```

## 5. 에러 처리

### 5.1 HTTP 상태 코드

- 200: 성공
- 400: 잘못된 요청
- 401: 인증 실패
- 403: 권한 없음
- 404: 리소스 없음
- 429: 요청 제한 초과
- 500: 서버 에러

### 5.2 에러 응답 형식

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "에러 메시지",
    "details": {
      "field": "상세 정보"
    }
  }
}
```

## 6. 보안

### 6.1 인증

- JWT 토큰 사용
- 토큰 만료 시간: 1시간
- 리프레시 토큰 지원

### 6.2 데이터 보안

- HTTPS 통신
- 민감 정보 암호화
- API 키 보안 관리

## 7. 레이트 리미팅

### 7.1 Discogs API

- 분당 60회 요청
- 일일 1000회 요청

### 7.2 Supabase

- 초당 100회 요청
- 월간 100만회 요청

### 7.3 이미지 인식 API

- 일일 1000회 요청
- 분당 100회 요청

## 8. 버전 관리

- API 버전: v1
- 호환성 유지 기간: 1년
- 새로운 버전 출시 시 3개월 전 미리 알림

# English below

# Kolektt API Documentation

## 1. Overview

This document provides detailed specifications for the APIs used in the Kolektt application.

## 2. Discogs API

### 2.1 Basic Information

- Base URL: `https://api.discogs.com`
- Authentication: OAuth 1.0a
- Rate Limit: 60 requests per minute

### 2.2 Endpoints

#### 2.2.1 Search API

```http
GET /database/search
```

**Parameters:**
- `q`: Search query (required)
- `type`: Search type (release, master, artist, label)
- `page`: Page number
- `per_page`: Results per page

**Response Example:**
```json
{
  "pagination": {
    "page": 1,
    "pages": 10,
    "per_page": 50,
    "items": 500
  },
  "results": [
    {
      "id": 12345,
      "title": "Album Title",
      "year": 2020,
      "cover_image": "https://example.com/cover.jpg",
      "genre": ["Rock", "Pop"],
      "style": ["Alternative", "Indie"]
    }
  ]
}
```

#### 2.2.2 Release Details

```http
GET /releases/{id}
```

**Parameters:**
- `id`: Release ID (required)

**Response Example:**
```json
{
  "id": 12345,
  "title": "Album Title",
  "artists": [
    {
      "name": "Artist Name",
      "id": 67890
    }
  ],
  "labels": [
    {
      "name": "Label Name",
      "id": 54321
    }
  ],
  "year": 2020,
  "genres": ["Rock", "Pop"],
  "styles": ["Alternative", "Indie"],
  "tracklist": [
    {
      "position": "1",
      "title": "Track 1",
      "duration": "3:45"
    }
  ],
  "images": [
    {
      "type": "primary",
      "uri": "https://example.com/cover.jpg",
      "width": 500,
      "height": 500
    }
  ]
}
```

## 3. Supabase API

### 3.1 Basic Information

- Base URL: `https://[project-ref].supabase.co`
- Authentication: JWT token
- Database: PostgreSQL

### 3.2 Table Structure

#### 3.2.1 users

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 3.2.2 collections

```sql
CREATE TABLE collections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  discogs_id INTEGER,
  title TEXT NOT NULL,
  artist TEXT,
  year INTEGER,
  genre TEXT[],
  condition TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 3.3 REST API

#### 3.3.1 Collection Query

```http
GET /rest/v1/collections?select=*
```

**Headers:**
- `Authorization: Bearer {jwt_token}`
- `apikey: {supabase_key}`

**Response Example:**
```json
[
  {
    "id": "uuid",
    "user_id": "uuid",
    "discogs_id": 12345,
    "title": "Album Title",
    "artist": "Artist Name",
    "year": 2020,
    "genre": ["Rock", "Pop"],
    "condition": "Mint",
    "created_at": "2023-01-01T00:00:00Z",
    "updated_at": "2023-01-01T00:00:00Z"
  }
]
```

#### 3.3.2 Collection Addition

```http
POST /rest/v1/collections
```

**Headers:**
- `Authorization: Bearer {jwt_token}`
- `apikey: {supabase_key}`
- `Content-Type: application/json`

**Request Body:**
```json
{
  "discogs_id": 12345,
  "title": "Album Title",
  "artist": "Artist Name",
  "year": 2020,
  "genre": ["Rock", "Pop"],
  "condition": "Mint"
}
```

## 4. Image Recognition API

### 4.1 Basic Information

- Provider: Google ML Kit
- Features: Image labeling, text recognition
- Rate Limit: 1000 requests per day

### 4.2 Endpoints

#### 4.2.1 Image Labeling

```http
POST /v1/images:annotate
```

**Headers:**
- `Authorization: Bearer {api_key}`
- `Content-Type: application/json`

**Request Body:**
```json
{
  "requests": [
    {
      "image": {
        "content": "base64_encoded_image"
      },
      "features": [
        {
          "type": "LABEL_DETECTION",
          "maxResults": 10
        }
      ]
    }
  ]
}
```

**Response Example:**
```json
{
  "responses": [
    {
      "labelAnnotations": [
        {
          "description": "album cover",
          "score": 0.95
        },
        {
          "description": "music",
          "score": 0.85
        }
      ]
    }
  ]
}
```

## 5. Error Handling

### 5.1 HTTP Status Codes

- 200: Success
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 429: Too Many Requests
- 500: Server Error

### 5.2 Error Response Format

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Error message",
    "details": {
      "field": "Detailed information"
    }
  }
}
```

## 6. Security

### 6.1 Authentication

- JWT token usage
- Token expiration: 1 hour
- Refresh token support

### 6.2 Data Security

- HTTPS communication
- Sensitive data encryption
- API key security management

## 7. Rate Limiting

### 7.1 Discogs API

- 60 requests per minute
- 1000 requests per day

### 7.2 Supabase

- 100 requests per second
- 1 million requests per month

### 7.3 Image Recognition API

- 1000 requests per day
- 100 requests per minute

## 8. Version Management

- API Version: v1
- Compatibility Period: 1 year
- 3 months notice for new version releases 