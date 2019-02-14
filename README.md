# Testing

Install MacOS (preferably via VMWare Fusion) and setup remote login:

```bash
sudo systemsetup -getremotelogin
sudo systemsetup -setremotelogin on
ipconfig getifaddr en0
```

Run Bootscript Script:
```bash
bash <(curl -s https://d47zm3.me/bootstrap)
```
