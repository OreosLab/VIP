import smtplib
import traceback
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from jinja2 import FileSystemLoader, Environment, Template

from . import settings


class EmailPoster(object):
    """
    邮件发送基础类

    """

    @staticmethod
    def get_template():
        loader = FileSystemLoader('templates')
        env = Environment(loader=loader)
        template = env.get_template("default.html")
        return template

    def send(self, data: dict):
        payload = data.get("payload", {})
        if payload:
            template = self.get_template()
            content = template.render(payload=payload)
        else:
            content = data.get('body', '')
        subject = data.get('subject', '')
        mail_to = data.get('to', [])
        mail_from = data.get('from', settings.MAIL_ADDRESS)
        self._send(content, subject, mail_from, mail_to)

    @staticmethod
    def _send(content: str, subject: str, mail_from: str, mail_to: list):
        msg_root = MIMEMultipart('related')
        msg_text = MIMEText(content, 'html', 'utf-8')
        msg_root.attach(msg_text)
        msg_root['Subject'] = subject
        msg_root['From'] = mail_from
        msg_root['To'] = ";".join(mail_to)

        try:
            smtp = smtplib.SMTP_SSL(settings.MAIL_HOST, settings.MAIL_PORT)
            # smtp.set_debuglevel(1)
            smtp.ehlo()
            smtp.login(settings.MAIL_USER, settings.MAIL_PW)
            smtp.sendmail(settings.MAIL_ADDRESS, mail_to, msg_root.as_string())
            smtp.quit()
        except Exception as e:
            print(traceback.format_exc(e))
