# kling-ai

> Generate images and videos using Kling AI API. Use when creating AI-generated images from text prompts, converting images to videos, or generating ...

## When to use this skill
• Generating images from text prompts (Text-to-Image)
• Creating videos from text descriptions (Text-to-Video)
• Animating static images into videos (Image-to-Video)
• Producing high-quality AI video content (up to 1080p, 30fps)
• Building applications with AI-generated media

## Instructions
▶ S1: Authentication Setup
Kling AI uses JWT (JSON Web Tokens) for authentication.
**Required credentials**:
• Access Key (AK) - Public identifier
• Secret Key (SK) - Private signing key
**Get credentials**: [app.klingai.com/global/dev](https://app.klingai.com/global/dev)
**Generate JWT token (Python)**:
**Headers for all requests**:
▶ S2: Text-to-Image Generation
**Endpoint**: `POST https://api.klingai.com/v1/images/generations`
**Request**:
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
▶ S3: Text-to-Video Generation
**Endpoint**: `POST https://api.klingai.com/v1/videos/text2video`
**Request**:
**Camera control presets**:
▶ S4: Image-to-Video Generation
**Endpoint**: `POST https://api.klingai.com/v1/videos/image2video`
**Request**:
**With URL instead of base64**:
▶ S5: Check Task Status (Polling)
All generation tasks are asynchronous. Poll for completion:
**Endpoint**: `GET https://api.klingai.com/v1/videos/text2video/{task_id}`
**Task status values**:
| Status | Description |
|--------|-------------|
| `submitted` | Task queued |
| `processing` | Currently generating |
| `succeed` | Completed successfully |
| `failed` | Generation failed |
▶ S6: Download Generated Media

## Best practices
1. Prompt quality
2. Negative prompts
3. Start with standard mode
4. Use 5-second videos
5. Handle rate limits
