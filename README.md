# MacOS Catalina Edition Setup

Idempotent Setup For MacOS.

### Testing

- Install MacOS
- Setup Remote Login

```bash
sudo systemsetup -getremotelogin
sudo systemsetup -setremotelogin on
ipconfig getifaddr en0
```

Run Bootstrap Script:
```bash
bash <(curl -s https://d47zm3.me/bootstrap)
```
