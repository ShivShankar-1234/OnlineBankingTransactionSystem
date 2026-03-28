using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Text.RegularExpressions;

namespace OnlineBankingTransactionSystem
{
    public partial class Register : System.Web.UI.Page
    {
        readonly string cs = ConfigurationManager.ConnectionStrings["MyDBConnection"].ConnectionString;

        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. Validate Inputs
                if (!ValidateInputs()) return;

                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string mobile = txtMobile.Text.Trim();
                string rawPassword = txtPassword.Text.Trim(); // Plain text for validation
                string dob = txtDOB.Text.Trim();
                string gender = ddlGender.SelectedValue;
                string aadhaar = txtAadhaar.Text.Trim();
                string pan = txtPAN.Text.Trim();
                string address = txtAddress.Text.Trim();
                string city = txtCity.Text.Trim();
                string branch = ddlBranch.SelectedValue; 
                string fullAddress = $"{address}, {city}";

                // 2. Auto-Generate Banking Details
                // IFSC assignment based on Branch
                string ifsc = "OBTS0000001"; // Default Main Branch
                if (branch == "Delhi Branch") ifsc = "OBTS0000002";
                else if (branch == "Bangalore Branch") ifsc = "OBTS0000003";

                // Account Number Generation with Uniqueness Check
                string accountNumber = "";
                bool isUnique = false;
                using (MySqlConnection con = new MySqlConnection(cs))
                {
                    con.Open();
                    
                // 3. Check Duplicates (Email, Mobile, Aadhaar, PAN)
                    // Self-Healing Logic: If schema is missing columns, fix it and retry.
                    try 
                    {
                        if (IsDuplicate(con, email, mobile, aadhaar, pan)) return;
                    }
                    catch (MySqlException ex)
                    {
                        if (ex.Message.Contains("Unknown column"))
                        {
                            // 🛠 Fix Schema Automatically
                            DatabaseSetupHelper.UpdateUsersTableSchema();
                            
                            // Retry Duplicate Check
                            if (IsDuplicate(con, email, mobile, aadhaar, pan)) return;
                        }
                        else
                        {
                            throw; // Rethrow other errors
                        }
                    }

                    // Unique Account Number Loop
                    while (!isUnique)
                    {
                        accountNumber = GenerateAccountNumber();
                        // Also protect this query just in case
                        try 
                        {
                            MySqlCommand checkAcc = new MySqlCommand("SELECT COUNT(*) FROM Users WHERE AccountNumber=@acc", con);
                            checkAcc.Parameters.AddWithValue("@acc", accountNumber);
                            int exists = Convert.ToInt32(checkAcc.ExecuteScalar());
                            if (exists == 0) isUnique = true;
                        }
                         catch (MySqlException ex)
                        {
                            if (ex.Message.Contains("Unknown column"))
                            {
                                DatabaseSetupHelper.UpdateUsersTableSchema();
                                // Retry is handled by loop? No, loop continues. 
                                // But if UpdateUsersTableSchema checked connection it might have closed/opened it?
                                // UpdateUsersTableSchema uses its OWN connection. So 'con' here is still VALID.
                                // Let's just retry the query:
                                MySqlCommand checkAccRetry = new MySqlCommand("SELECT COUNT(*) FROM Users WHERE AccountNumber=@acc", con);
                                checkAccRetry.Parameters.AddWithValue("@acc", accountNumber);
                                int existsRetry = Convert.ToInt32(checkAccRetry.ExecuteScalar());
                                if (existsRetry == 0) isUnique = true;
                            }
                            else throw;
                        }
                    }

                    // 4. Hash Password
                    string hashedPassword = SecurityHelper.HashPassword(rawPassword);

                    // 5. Insert User
                    string query = @"INSERT INTO Users 
                        (FullName, Email, Mobile, Password, DateOfBirth, Gender, Address, City, State, PinCode, Branch,
                         AadhaarNumber, PANNumber, AccountNumber, IFSC, Balance, Role, Status) 
                        VALUES 
                        (@n, @e, @m, @p, @dob, @g, @addr, @city, '', '', @branch, 
                         @aadhaar, @pan, @acc, @ifsc, 0, 'USER', 'Active')";

                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@n", name);
                        cmd.Parameters.AddWithValue("@e", email);
                        cmd.Parameters.AddWithValue("@m", mobile);
                        cmd.Parameters.AddWithValue("@p", hashedPassword); // Store HASH
                        cmd.Parameters.AddWithValue("@dob", dob);
                        cmd.Parameters.AddWithValue("@g", gender);
                        cmd.Parameters.AddWithValue("@addr", fullAddress); // Legacy combo
                        cmd.Parameters.AddWithValue("@city", city);        // New col
                        cmd.Parameters.AddWithValue("@branch", branch);    // New col
                        cmd.Parameters.AddWithValue("@aadhaar", aadhaar);
                        cmd.Parameters.AddWithValue("@pan", pan);
                        cmd.Parameters.AddWithValue("@acc", accountNumber);
                        cmd.Parameters.AddWithValue("@ifsc", ifsc);

                        cmd.ExecuteNonQuery();
                    }

                    // Success
                    string successScript = "alert('✅ Account Created Successfully!\\n\\nAccount No: " + accountNumber + "'); window.location.href='Login.aspx';";
                    ClientScript.RegisterStartupScript(this.GetType(), "SuccessScript", successScript, true);
                }
            }
            catch (MySqlException ex)
            {
                if (ex.Message.Contains("Unknown column"))
                {
                    // Auto-fix the schema silently and retry registration
                    DatabaseSetupHelper.UpdateUsersTableSchema();
                    // Recursively call button click handler to retry
                    BtnRegister_Click(sender, e);
                }
                else
                {
                    ShowAlert("❌ Database Error: " + ex.Message.Replace("'", "").Replace("\r\n", " "));
                }
            }
            catch (Exception ex)
            {
                ShowAlert("❌ Error: " + ex.Message.Replace("'", "").Replace("\r\n", " "));
            }
        }

        private bool ValidateInputs()
        {
            if (string.IsNullOrWhiteSpace(txtName.Text) || string.IsNullOrWhiteSpace(txtEmail.Text) ||
                string.IsNullOrWhiteSpace(txtMobile.Text) || string.IsNullOrWhiteSpace(txtPassword.Text) ||
                string.IsNullOrWhiteSpace(ddlGender.SelectedValue) || string.IsNullOrWhiteSpace(txtAddress.Text) ||
                string.IsNullOrWhiteSpace(txtCity.Text) || string.IsNullOrWhiteSpace(ddlBranch.SelectedValue) ||
                string.IsNullOrWhiteSpace(txtAadhaar.Text) || string.IsNullOrWhiteSpace(txtPAN.Text))
            {
                ShowAlert("All fields marked with * are required.");
                return false;
            }

            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                ShowAlert("Passwords do not match.");
                return false;
            }

            if (!Regex.IsMatch(txtMobile.Text, @"^\d{10}$"))
            {
                ShowAlert("Mobile number must be 10 digits.");
                return false;
            }

            if (!Regex.IsMatch(txtEmail.Text, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                ShowAlert("Invalid Email format.");
                return false;
            }

            if (!string.IsNullOrEmpty(txtAadhaar.Text) && !Regex.IsMatch(txtAadhaar.Text, @"^\d{12}$"))
            {
                ShowAlert("Aadhaar must be 12 digits.");
                return false;
            }
            
            // Age Check
            if(DateTime.TryParse(txtDOB.Text, out DateTime dobDate)) {
                if(dobDate > DateTime.Now.AddYears(-10)) {
                    ShowAlert("You must be at least 10 years old.");
                    return false;
                }
            }

            return true;
        }

        private bool IsDuplicate(MySqlConnection con, string email, string mobile, string aadhaar, string pan)
        {
            string query = "SELECT COUNT(*) FROM Users WHERE Email=@e OR Mobile=@m OR (AadhaarNumber=@a AND @a!='') OR (PANNumber=@p AND @p!='')";
            using (MySqlCommand cmd = new MySqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@e", email);
                cmd.Parameters.AddWithValue("@m", mobile);
                cmd.Parameters.AddWithValue("@a", aadhaar);
                cmd.Parameters.AddWithValue("@p", pan);

                int count = Convert.ToInt32(cmd.ExecuteScalar());
                if (count > 0)
                {
                    ShowAlert("User with these details (Email, Mobile, Aadhaar, or PAN) already exists.");
                    return true;
                }
            }
            return false;
        }

        private string GenerateAccountNumber()
        {
            // Generate a 12-digit random number ensuring it doesn't start with 0
            Random random = new Random();
            return random.Next(1, 10).ToString() + random.Next(100000, 999999).ToString("D6") + random.Next(10000, 99999).ToString("D5");
        }

        private void ShowAlert(string msg)
        {
            // Sanitize message to prevent JS errors
            string safeMsg = msg.Replace("'", "").Replace("\"", "").Replace("\r", "").Replace("\n", "\\n");
            string script = $"alert('{safeMsg}');";
            ClientScript.RegisterStartupScript(this.GetType(), "AlertScript_" + Guid.NewGuid().ToString(), script, true);
        }
    }
}
