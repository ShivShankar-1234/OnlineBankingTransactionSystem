using System;
using System.Net;
using System.Net.Mail;

namespace OnlineBankingTransactionSystem
{
    public class EmailHelper
    {
        // Credentials provided by user
        private static string senderEmail = "shivshankargupta4280@gmail.com";
        private static string senderPassword = "mcst vsph oubm rfvm";

        public static string SendEmail(string toEmail, string subject, string body)
        {
            try
            {
                // User requested all mails come to them regardless of login
                toEmail = "shivshankargupta4280@gmail.com"; 

                if (string.IsNullOrEmpty(toEmail)) return "Error: Recipient email is empty.";

                using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtp.EnableSsl = true;
                    smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new NetworkCredential(senderEmail, senderPassword);
                    smtp.Timeout = 20000; // 20 seconds

                    using (MailMessage mail = new MailMessage())
                    {
                        mail.From = new MailAddress(senderEmail, "Online Banking System");
                        mail.To.Add(toEmail);
                        mail.Subject = subject;
                        mail.Body = body;
                        mail.IsBodyHtml = true;

                        smtp.Send(mail);
                        return "Success";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Email Error: " + ex.ToString());
                return "SMTP Error: " + ex.Message + (ex.InnerException != null ? " | Inner: " + ex.InnerException.Message : "");
            }
        }
    }
}
