namespace Ahnduino
{
    partial class billselect
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
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.button1 = new System.Windows.Forms.Button();
            this.radioButtonfalse = new System.Windows.Forms.RadioButton();
            this.radioButtontrue = new System.Windows.Forms.RadioButton();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            this.SuspendLayout();
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(11, 12);
            this.textBox1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(100, 25);
            this.textBox1.TabIndex = 0;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Location = new System.Drawing.Point(215, 12);
            this.pictureBox1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(600, 700);
            this.pictureBox1.TabIndex = 1;
            this.pictureBox1.TabStop = false;
            // 
            // comboBox1
            // 
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(11, 42);
            this.comboBox1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(197, 23);
            this.comboBox1.TabIndex = 2;
            this.comboBox1.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(118, 12);
            this.button1.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(91, 25);
            this.button1.TabIndex = 3;
            this.button1.Text = "검색";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // radioButtonfalse
            // 
            this.radioButtonfalse.AutoSize = true;
            this.radioButtonfalse.Location = new System.Drawing.Point(34, 115);
            this.radioButtonfalse.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.radioButtonfalse.Name = "radioButtonfalse";
            this.radioButtonfalse.Size = new System.Drawing.Size(58, 19);
            this.radioButtonfalse.TabIndex = 5;
            this.radioButtonfalse.TabStop = true;
            this.radioButtonfalse.Text = "미납";
            this.radioButtonfalse.UseVisualStyleBackColor = true;
            this.radioButtonfalse.CheckedChanged += new System.EventHandler(this.radioButtonfalse_CheckedChanged);
            // 
            // radioButtontrue
            // 
            this.radioButtontrue.AutoSize = true;
            this.radioButtontrue.Location = new System.Drawing.Point(118, 115);
            this.radioButtontrue.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.radioButtontrue.Name = "radioButtontrue";
            this.radioButtontrue.Size = new System.Drawing.Size(58, 19);
            this.radioButtontrue.TabIndex = 6;
            this.radioButtontrue.TabStop = true;
            this.radioButtontrue.Text = "완납";
            this.radioButtontrue.UseVisualStyleBackColor = true;
            this.radioButtontrue.CheckedChanged += new System.EventHandler(this.radioButtontrue_CheckedChanged);
            // 
            // billselect
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(820, 720);
            this.Controls.Add(this.radioButtontrue);
            this.Controls.Add(this.radioButtonfalse);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.comboBox1);
            this.Controls.Add(this.pictureBox1);
            this.Controls.Add(this.textBox1);
            this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
            this.Name = "billselect";
            this.Text = "bill";
            this.Load += new System.EventHandler(this.billselect_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.PictureBox pictureBox1;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.RadioButton radioButtonfalse;
        private System.Windows.Forms.RadioButton radioButtontrue;
    }
}