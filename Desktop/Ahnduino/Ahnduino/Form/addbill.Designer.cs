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
			this.metroLabel2 = new MetroFramework.Controls.MetroLabel();
			this.metroComboBoxmonth = new MetroFramework.Controls.MetroComboBox();
			this.metroButton1 = new MetroFramework.Controls.MetroButton();
			this.SuspendLayout();
			// 
			// metroLabel2
			// 
			this.metroLabel2.AutoSize = true;
			this.metroLabel2.Location = new System.Drawing.Point(49, 76);
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
			this.metroComboBoxmonth.Location = new System.Drawing.Point(79, 76);
			this.metroComboBoxmonth.Name = "metroComboBoxmonth";
			this.metroComboBoxmonth.Size = new System.Drawing.Size(60, 30);
			this.metroComboBoxmonth.TabIndex = 4;
			this.metroComboBoxmonth.UseSelectable = true;
			// 
			// metroButton1
			// 
			this.metroButton1.Location = new System.Drawing.Point(79, 170);
			this.metroButton1.Name = "metroButton1";
			this.metroButton1.Size = new System.Drawing.Size(75, 23);
			this.metroButton1.TabIndex = 7;
			this.metroButton1.Text = "추가";
			this.metroButton1.UseSelectable = true;
			this.metroButton1.Click += new System.EventHandler(this.metroButton1_Click);
			// 
			// addbill
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(220, 218);
			this.Controls.Add(this.metroButton1);
			this.Controls.Add(this.metroComboBoxmonth);
			this.Controls.Add(this.metroLabel2);
			this.Name = "addbill";
			this.Style = MetroFramework.MetroColorStyle.Black;
			this.Text = "새 고지서 추가";
			this.ResumeLayout(false);
			this.PerformLayout();

        }

        #endregion
        private MetroFramework.Controls.MetroLabel metroLabel2;
        public MetroFramework.Controls.MetroComboBox metroComboBoxmonth;
        private MetroFramework.Controls.MetroButton metroButton1;
    }
}