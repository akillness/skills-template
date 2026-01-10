---
name: kling-ai
description: Generate images and videos using Kling AI API. Use when creating AI-generated images from text prompts, converting images to videos, or generating videos from text descriptions.
tags: [ai, image-generation, video-generation, kling, text-to-image, text-to-video, image-to-video]
platforms: [Claude, ChatGPT, Gemini]
---

# Kling AI - Image & Video Generation

## When to use this skill
- Generating images from text prompts (Text-to-Image)
- Creating videos from text descriptions (Text-to-Video)
- Animating static images into videos (Image-to-Video)
- Producing high-quality AI video content (up to 1080p, 30fps)
- Building applications with AI-generated media

## Instructions

### Step 1: Authentication Setup

Kling AI uses JWT (JSON Web Tokens) for authentication.

**Required credentials**:
- Access Key (AK) - Public identifier
- Secret Key (SK) - Private signing key

**Get credentials**: [app.klingai.com/global/dev](https://app.klingai.com/global/dev)

**Generate JWT token (Python)**:
```python
import jwt
import time

def generate_kling_token(access_key: str, secret_key: str) -> str:
    """Generate JWT token for Kling AI API."""
    headers = {
        "alg": "HS256",
        "typ": "JWT"
    }
    payload = {
        "iss": access_key,
        "exp": int(time.time()) + 1800,  # 30 minutes
        "nbf": int(time.time()) - 5
    }
    return jwt.encode(payload, secret_key, algorithm="HS256", headers=headers)

# Usage
access_key = "YOUR_ACCESS_KEY"
secret_key = "YOUR_SECRET_KEY"
token = generate_kling_token(access_key, secret_key)
```

**Headers for all requests**:
```python
headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}
```

### Step 2: Text-to-Image Generation

**Endpoint**: `POST https://api.klingai.com/v1/images/generations`

**Request**:
```python
import requests

def generate_image(prompt: str, token: str) -> dict:
    """Generate image from text prompt."""
    url = "https://api.klingai.com/v1/images/generations"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    data = {
        "model_name": "kling-v1",
        "prompt": prompt,
        "negative_prompt": "blur, distortion, low quality",
        "n": 1,
        "aspect_ratio": "16:9",  # 16:9, 9:16, 1:1, 4:3, 3:4, 3:2, 2:3
        "image_fidelity": 0.5,   # 0-1
        "callback_url": ""       # Optional webhook
    }
    response = requests.post(url, json=data, headers=headers)
    return response.json()

# Usage
result = generate_image(
    prompt="A futuristic cityscape at sunset, cinematic lighting, ultra-realistic",
    token=token
)
task_id = result["data"]["task_id"]
```

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model_name` | string | Yes | `kling-v1` |
| `prompt` | string | Yes | Image description (max 500 chars) |
| `negative_prompt` | string | No | Elements to avoid |
| `n` | integer | No | Number of images (1-9, default 1) |
| `aspect_ratio` | string | No | `16:9`, `9:16`, `1:1`, `4:3`, `3:4` |
| `image_fidelity` | float | No | 0-1, default 0.5 |
| `callback_url` | string | No | Webhook for completion |

### Step 3: Text-to-Video Generation

**Endpoint**: `POST https://api.klingai.com/v1/videos/text2video`

**Request**:
```python
def generate_video_from_text(prompt: str, token: str, duration: int = 5) -> dict:
    """Generate video from text prompt."""
    url = "https://api.klingai.com/v1/videos/text2video"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    data = {
        "model_name": "kling-v1",           # kling-v1, kling-v1-5, kling-v1-6
        "prompt": prompt,
        "negative_prompt": "blur, distortion",
        "duration": duration,                # 5 or 10 seconds
        "aspect_ratio": "16:9",             # 16:9, 9:16, 1:1
        "mode": "std",                       # std (standard) or pro
        "cfg_scale": 0.5,                    # 0-1
        "camera_control": {
            "type": "simple",
            "config": {
                "horizontal": 0,             # -10 to 10
                "vertical": 0,               # -10 to 10
                "zoom": 0,                   # -10 to 10
                "tilt": 0,                   # -10 to 10
                "pan": 0,                    # -10 to 10
                "roll": 0                    # -10 to 10
            }
        },
        "callback_url": ""
    }
    response = requests.post(url, json=data, headers=headers)
    return response.json()

# Usage
result = generate_video_from_text(
    prompt="A dragon flying over mountains at sunset, epic cinematic shot",
    token=token,
    duration=5
)
task_id = result["data"]["task_id"]
```

**Camera control presets**:
```python
camera_presets = {
    "zoom_in": {"zoom": 5},
    "zoom_out": {"zoom": -5},
    "pan_left": {"horizontal": -5},
    "pan_right": {"horizontal": 5},
    "tilt_up": {"vertical": 5},
    "tilt_down": {"vertical": -5},
    "dolly_forward": {"zoom": 3, "vertical": 2},
    "orbit_right": {"horizontal": 5, "pan": 3}
}
```

### Step 4: Image-to-Video Generation

**Endpoint**: `POST https://api.klingai.com/v1/videos/image2video`

**Request**:
```python
import base64

def generate_video_from_image(
    image_path: str,
    prompt: str,
    token: str,
    duration: int = 5
) -> dict:
    """Animate an image into a video."""
    url = "https://api.klingai.com/v1/videos/image2video"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    # Load and encode image
    with open(image_path, "rb") as f:
        image_base64 = base64.b64encode(f.read()).decode()
    
    data = {
        "model_name": "kling-v1",
        "image": image_base64,              # Base64 or URL
        "image_tail": "",                   # Optional: end frame image
        "prompt": prompt,
        "negative_prompt": "blur, distortion",
        "duration": duration,
        "mode": "std",
        "cfg_scale": 0.5,
        "callback_url": ""
    }
    response = requests.post(url, json=data, headers=headers)
    return response.json()

# Usage
result = generate_video_from_image(
    image_path="portrait.jpg",
    prompt="Person smiling and waving at camera",
    token=token
)
```

**With URL instead of base64**:
```python
data = {
    "model_name": "kling-v1",
    "image": "https://example.com/image.jpg",
    "prompt": "The subject slowly turns their head",
    "duration": 5
}
```

### Step 5: Check Task Status (Polling)

All generation tasks are asynchronous. Poll for completion:

**Endpoint**: `GET https://api.klingai.com/v1/videos/text2video/{task_id}`

```python
import time

def poll_task_status(task_id: str, token: str, task_type: str = "text2video") -> dict:
    """Poll task status until completion."""
    url = f"https://api.klingai.com/v1/videos/{task_type}/{task_id}"
    headers = {"Authorization": f"Bearer {token}"}
    
    while True:
        response = requests.get(url, headers=headers)
        result = response.json()
        status = result["data"]["task_status"]
        
        print(f"Status: {status}")
        
        if status == "succeed":
            return result
        elif status == "failed":
            raise Exception(f"Task failed: {result['data'].get('task_status_msg')}")
        
        time.sleep(10)  # Poll every 10 seconds

# Usage
result = poll_task_status(task_id, token)
video_url = result["data"]["task_result"]["videos"][0]["url"]
print(f"Video URL: {video_url}")
```

**Task status values**:
| Status | Description |
|--------|-------------|
| `submitted` | Task queued |
| `processing` | Currently generating |
| `succeed` | Completed successfully |
| `failed` | Generation failed |

### Step 6: Download Generated Media

```python
def download_media(url: str, output_path: str) -> None:
    """Download generated image or video."""
    response = requests.get(url, stream=True)
    with open(output_path, "wb") as f:
        for chunk in response.iter_content(chunk_size=8192):
            f.write(chunk)
    print(f"Downloaded: {output_path}")

# Usage
download_media(video_url, "output.mp4")
```

## Examples

### Example 1: Complete Text-to-Video Workflow

```python
import jwt
import time
import requests

class KlingClient:
    BASE_URL = "https://api.klingai.com/v1"
    
    def __init__(self, access_key: str, secret_key: str):
        self.access_key = access_key
        self.secret_key = secret_key
    
    def _get_token(self) -> str:
        headers = {"alg": "HS256", "typ": "JWT"}
        payload = {
            "iss": self.access_key,
            "exp": int(time.time()) + 1800,
            "nbf": int(time.time()) - 5
        }
        return jwt.encode(payload, self.secret_key, algorithm="HS256", headers=headers)
    
    def _headers(self) -> dict:
        return {
            "Authorization": f"Bearer {self._get_token()}",
            "Content-Type": "application/json"
        }
    
    def text_to_video(self, prompt: str, duration: int = 5, mode: str = "std") -> str:
        """Generate video and return URL."""
        # Create task
        response = requests.post(
            f"{self.BASE_URL}/videos/text2video",
            json={
                "model_name": "kling-v1",
                "prompt": prompt,
                "duration": duration,
                "mode": mode,
                "aspect_ratio": "16:9"
            },
            headers=self._headers()
        )
        task_id = response.json()["data"]["task_id"]
        
        # Poll for completion
        while True:
            result = requests.get(
                f"{self.BASE_URL}/videos/text2video/{task_id}",
                headers=self._headers()
            ).json()
            
            status = result["data"]["task_status"]
            if status == "succeed":
                return result["data"]["task_result"]["videos"][0]["url"]
            elif status == "failed":
                raise Exception("Generation failed")
            
            time.sleep(10)

# Usage
client = KlingClient("YOUR_ACCESS_KEY", "YOUR_SECRET_KEY")
video_url = client.text_to_video(
    prompt="A majestic eagle soaring through clouds at golden hour",
    duration=5
)
print(f"Generated video: {video_url}")
```

### Example 2: Batch Image Generation

```python
def batch_generate_images(prompts: list, token: str) -> list:
    """Generate multiple images in parallel."""
    import concurrent.futures
    
    results = []
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        futures = {
            executor.submit(generate_image, prompt, token): prompt
            for prompt in prompts
        }
        
        for future in concurrent.futures.as_completed(futures):
            prompt = futures[future]
            try:
                result = future.result()
                results.append({"prompt": prompt, "task_id": result["data"]["task_id"]})
            except Exception as e:
                results.append({"prompt": prompt, "error": str(e)})
    
    return results

# Usage
prompts = [
    "A serene Japanese garden with cherry blossoms",
    "A cyberpunk street scene at night",
    "An underwater coral reef teeming with life"
]
tasks = batch_generate_images(prompts, token)
```

### Example 3: Image-to-Video with Motion Control

```python
def animate_portrait(image_url: str, token: str) -> str:
    """Animate a portrait with subtle motion."""
    url = "https://api.klingai.com/v1/videos/image2video"
    
    response = requests.post(
        url,
        json={
            "model_name": "kling-v1",
            "image": image_url,
            "prompt": "Subtle head movement, natural blinking, gentle smile",
            "negative_prompt": "distortion, unnatural movement, glitch",
            "duration": 5,
            "mode": "pro",  # Higher quality for portraits
            "cfg_scale": 0.7
        },
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
    )
    
    task_id = response.json()["data"]["task_id"]
    return poll_task_status(task_id, token, "image2video")

# Usage
result = animate_portrait("https://example.com/portrait.jpg", token)
```

### Example 4: Video with Camera Movement

```python
def cinematic_video(prompt: str, camera_motion: str, token: str) -> str:
    """Generate video with specific camera movement."""
    camera_configs = {
        "epic_reveal": {"zoom": -5, "vertical": 3},
        "dramatic_push": {"zoom": 5},
        "orbit_subject": {"horizontal": 7, "pan": 3},
        "crane_up": {"vertical": 5, "zoom": 2},
        "dolly_back": {"zoom": -3, "horizontal": 2}
    }
    
    config = camera_configs.get(camera_motion, {})
    
    response = requests.post(
        "https://api.klingai.com/v1/videos/text2video",
        json={
            "model_name": "kling-v1-6",
            "prompt": prompt,
            "duration": 10,
            "mode": "pro",
            "aspect_ratio": "16:9",
            "camera_control": {
                "type": "simple",
                "config": {
                    "horizontal": config.get("horizontal", 0),
                    "vertical": config.get("vertical", 0),
                    "zoom": config.get("zoom", 0),
                    "tilt": config.get("tilt", 0),
                    "pan": config.get("pan", 0),
                    "roll": config.get("roll", 0)
                }
            }
        },
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json"
        }
    )
    
    task_id = response.json()["data"]["task_id"]
    return poll_task_status(task_id, token)

# Usage
video_url = cinematic_video(
    prompt="Ancient temple emerging from jungle mist",
    camera_motion="epic_reveal",
    token=token
)
```

## Model Comparison

### Video Models

| Model | Resolution | Duration | Quality | Cost |
|-------|------------|----------|---------|------|
| `kling-v1` (std) | 720p | 5-10s | Good | $ |
| `kling-v1` (pro) | 1080p | 5-10s | Better | $$ |
| `kling-v1-5` (std) | 720p | 5-10s | Good | $ |
| `kling-v1-5` (pro) | 1080p | 5-10s | Better | $$ |
| `kling-v1-6` (std) | 720p | 5-10s | Great | $$ |
| `kling-v1-6` (pro) | 1080p | 5-10s | Excellent | $$$ |

### Image Models

| Model | Max Resolution | Quality |
|-------|----------------|---------|
| `kling-v1` | 1024x1024 | Standard |
| `kling-v1` (2k) | 2048x2048 | High |

## Pricing Reference

| Feature | Standard Mode | Pro Mode |
|---------|---------------|----------|
| 5s video | ~$0.14 | ~$0.49 |
| 10s video | ~$0.28 | ~$0.98 |
| Image | ~$0.01 | - |

## Best practices

1. **Prompt quality**: Be specific and descriptive. Include style keywords like "cinematic", "photorealistic", "4K"
2. **Negative prompts**: Always include to avoid common artifacts: "blur, distortion, low quality, watermark"
3. **Start with standard mode**: Test with `std` mode first, upgrade to `pro` for final output
4. **Use 5-second videos**: More cost-effective for testing; use 10s only when needed
5. **Handle rate limits**: Implement exponential backoff for retries
6. **Cache tokens**: Reuse JWT tokens within their validity period (30 min recommended)
7. **Webhook for production**: Use `callback_url` instead of polling in production environments

## Common pitfalls

- **Token expiration**: JWT tokens expire. Regenerate before making requests if expired
- **Prompt length**: Text-to-image max 500 chars, text-to-video max 2500 chars
- **Image format**: Image-to-video supports JPEG, PNG. Max size varies by model
- **Polling too fast**: Don't poll faster than every 5-10 seconds to avoid rate limits
- **Missing negative prompt**: Always include to prevent common artifacts
- **Wrong aspect ratio**: Match aspect ratio to your use case (16:9 for landscape, 9:16 for portrait)

## Error Handling

```python
class KlingAPIError(Exception):
    pass

def handle_kling_response(response: requests.Response) -> dict:
    """Handle API response with proper error handling."""
    data = response.json()
    
    if response.status_code == 401:
        raise KlingAPIError("Authentication failed. Check your credentials.")
    elif response.status_code == 429:
        raise KlingAPIError("Rate limit exceeded. Wait and retry.")
    elif response.status_code >= 400:
        error_msg = data.get("message", "Unknown error")
        raise KlingAPIError(f"API Error: {error_msg}")
    
    if data.get("code") != 0:
        raise KlingAPIError(f"Request failed: {data.get('message')}")
    
    return data
```

## References

- [Kling AI Developer Portal](https://app.klingai.com/global/dev)
- [API Documentation](https://app.klingai.com/global/dev/document-api/apiReference)
- [Python SDK (Community)](https://github.com/TechWithTy/kling)
- [Pricing Guide](https://klingaiprompt.com/blog/kling-ai-api-pricing/)
