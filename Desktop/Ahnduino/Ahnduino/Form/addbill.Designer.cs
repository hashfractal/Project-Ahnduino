namespace Ahnduino
{
    partial class addbill
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.metroLabel1 = new MetroFramework.Controls.MetroLabel();
            this.metroLabel2 = new MetroFramework.Controls.MetroLabel();
            this.metroComboBoxmonth = new MetroFramework.Controls.MetroComboBox();
            this.metroLabel3 = new MetroFramework.Controls.MetroLabel();
            this.metroTextBoxppm = new MetroFramework.Controls.MetroTextBox();
            this.metroButton1 = new MetroFramework.Controls.MetroButton();
            this.metroTextBoxyear = new MetroFramework.Controls.MetroTextBox();
            this.SuspendLayout();
            // 
            // metroLabel1
            // 
            this.metroLabel1.AutoSize = true;
            this.metroLabel1.Location = new System.Drawing.Point(32, 84);
            this.metroLabel1.Name = "metroLabel1";
            this.metroLabel1.Size = new System.Drawing.Size(24, 20);
            this.metroLabel1.TabIndex = 1;
            this.metroLabel1.Text = "년";
            // 
            // metroLabel2
            // 
            this.metroLabel2.AutoSize = true;
            this.metroLabel2.Location = new System.Drawing.Point(32, 131);
            this.metroLabel2.Name = "metroLabel2";
            this.metroLabel2.Size = new System.Drawing.Size(24, 20);
            this.metroLabel2.TabIndex = 2;
            this.metroLabel2.Text = "월";
            // 
            // metroComboBoxmonth
            // 
            this.metroComboBoxmonth.FormattingEnabled = true;
            this.metroComboBoxmonth.ItemHeight = 24;
            this.metroComboBoxmonth.Items.AddRange(new object[] {
            "01",
            "02",
            "03",
            "04",
            "05",
            "06",
            "07",
            "08",
            "09",
            "10",
            "11",
            "12"});
            this.metroComboBoxmonth.Location = new System.Drawing.Point(62, 121);
            this.metroComboBoxmonth.Name = "metroComboBoxmonth";
            this.metroComboBoxmonth.Size = new System.Drawing.Size(60, 30);
            this.metroComboBoxmonth.TabIndex = 4;
            this.metroComboBoxmonth.UseSelectable = true;
            // 
            // metroLabel3
            // 
            this.metroLabel3.AutoSize = true;
            this.metroLabel3.Location = new System.Drawing.Point(2, 175);
            this.metroLabel3.Name = "metroLabel3";
            this.metroLabel3.Size = new System.Drawing.Size(54, 20);
            this.metroLabel3.TabIndex = 5;
            this.metroLabel3.Text = "관리비";
            // 
            // metroTextBoxppm
            // 
            // 
            // 
            // 
            this.metroTextBoxppm.CustomButton.Image = null;
            this.metroTextBoxppm.CustomButton.Location = new System.Drawing.Point(73, 1);
            this.metroTextBoxppm.CustomButton.Name = "";
            this.metroTextBoxppm.CustomButton.Size = new System.Drawing.Size(29, 29);
            this.metroTextBoxppm.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
            this.metroTextBoxppm.CustomButton.TabIndex = 1;
            this.metroTextBoxppm.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
            this.metroTextBoxppm.CustomButton.UseSelectable = true;
            this.metroTextBoxppm.CustomButton.Visible = false;
            this.metroTextBoxppm.Lines = new string[0];
            this.metroTextBoxppm.Location = new System.Drawing.Point(62, 164);
            this.metroTextBoxppm.MaxLength = 32767;
            this.metroTextBoxppm.Name = "metroTextBoxppm";
            this.metroTextBoxppm.PasswordChar = '\0';
            this.metroTextBoxppm.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.metroTextBoxppm.SelectedText = "";
            this.metroTextBoxppm.SelectionLength = 0;
            this.metroTextBoxppm.SelectionStart = 0;
            this.metroTextBoxppm.ShortcutsEnabled = true;
            this.metroTextBoxppm.Size = new System.Drawing.Size(103, 31);
            this.metroTextBoxppm.TabIndex = 6;
            this.metroTextBoxppm.UseSelectable = true;
            this.metroTextBoxppm.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            this.metroTextBoxppm.WaterMarkFont = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Pixel);
            // 
            // metroButton1
            // 
            this.metroButton1.Location = new System.Drawing.Point(114, 223);
            this.metroButton1.Name = "metroButton1";
            this.metroButton1.Size = new System.Drawing.Size(75, 23);
            this.metroButton1.TabIndex = 7;
            this.metroButton1.Text = "추가";
            this.metroButton1.UseSelectable = true;
            this.metroButton1.Click += new System.EventHandler(this.metroButton1_Click);
            // 
            // metroTextBoxyear
            // 
            // 
            // 
            // 
            this.metroTextBoxyear.CustomButton.Image = null;
            this.metroTextBoxyear.CustomButton.Location = new System.Drawing.Point(45, 1);
            this.metroTextBoxyear.CustomButton.Name = "";
            this.metroTextBoxyear.CustomButton.Size = new System.Drawing.Size(29, 29);
            this.metroTextBoxyear.CustomButton.Style = MetroFramework.MetroColorStyle.Blue;
            this.metroTextBoxyear.CustomButton.TabIndex = 1;
            this.metroTextBoxyear.CustomButton.Theme = MetroFramework.MetroThemeStyle.Light;
            this.metroTextBoxyear.CustomButton.UseSelectable = true;
            this.metroTextBoxyear.CustomButton.Visible = false;
            this.metroTextBoxyear.Lines = new string[0];
            this.metroTextBoxyear.Location = new System.Drawing.Point(62, 84);
            this.metroTextBoxyear.MaxLength = 32767;
            this.metroTextBoxyear.Name = "metroTextBoxyear";
            this.metroTextBoxyear.PasswordChar = '\0';
            this.metroTextBoxyear.ScrollBars = System.Windows.Forms.ScrollBars.None;
            this.metroTextBoxyear.SelectedText = "";
            this.metroTextBoxyear.SelectionLength = 0;
            this.metroTextBoxyear.SelectionStart = 0;
            this.metroTextBoxyear.ShortcutsEnabled = true;
            this.metroTextBoxyear.Size = new System.Drawing.Size(75, 31);
            this.metroTextBoxyear.TabIndex = 8;
            this.metroTextBoxyear.UseSelectable = true;
            this.metroTextBoxyear.WaterMarkColor = System.Drawing.Color.FromArgb(((int)(((byte)(109)))), ((int)(((byte)(109)))), ((int)(((byte)(109)))));
            this.metroTextBoxyear.WaterMarkFont = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Italic, System.Drawing.GraphicsUnit.Pixel);
            // 
            // addbill
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(199, 254);
            this.Controls.Add(this.metroTextBoxyear);
            this.Controls.Add(this.metroButton1);
            this.Controls.Add(this.metroTextBoxppm);
            this.Controls.Add(this.metroLabel3);
            this.Controls.Add(this.metroComboBoxmonth);
            this.Controls.Add(this.metroLabel2);
            this.Controls.Add(this.metroLabel1);
            this.Name = "addbill";
            this.Style = MetroFramework.MetroColorStyle.Black;
            this.Text = "고지서 추가";
            this.Load += new System.EventHandler(this.addbill_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private MetroFramework.Controls.MetroLabel metroLabel1;
        private MetroFramework.Controls.MetroLabel metroLabel2;
        public MetroFramework.Controls.MetroComboBox metroComboBoxmonth;
        private MetroFramework.Controls.MetroLabel metroLabel3;
        public MetroFramework.Controls.MetroTextBox metroTextBoxppm;
        private MetroFramework.Controls.MetroButton metroButton1;
        public MetroFramework.Controls.MetroTextBox metroTextBoxyear;
    }
}