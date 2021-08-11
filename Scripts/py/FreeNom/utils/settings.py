import os

# qq mail
MAIL_ADDRESS = os.getenv("MAIL_ADDRESS", "")
MAIL_HOST = os.getenv("SMTP_HOST", "smtp.qq.com")
MAIL_PW= os.getenv("MAIL_PW", "")
MAIL_PORT = int(os.getenv("SMTP_PORT", 465))
MAIL_TO = os.getenv("MAIL_TO", "")
MAIL_USER = os.getenv("MAIL_USER", "")


# free nom
FN_ID = os.getenv("FN_ID", "")
FN_PW = os.getenv("FN_PW", "")

