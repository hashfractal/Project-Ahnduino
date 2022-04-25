namespace Ahnduino
{
    partial class mainform
    {
        /// <summary>
        /// 필수 디자이너 변수입니다.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 사용 중인 모든 리소스를 정리합니다.
        /// </summary>
        /// <param name="disposing">관리되는 리소스를 삭제해야 하면 true이고, 그렇지 않으면 false입니다.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form 디자이너에서 생성한 코드

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다. 
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마세요.
        /// </summary>
        private void InitializeComponent()
        {
			this.listboxchat = new System.Windows.Forms.ListBox();
			this.SuspendLayout();
			// 
			// listboxchat
			// 
			this.listboxchat.FormattingEnabled = true;
			this.listboxchat.ItemHeight = 15;
			this.listboxchat.Location = new System.Drawing.Point(686, 62);
			this.listboxchat.Name = "listboxchat";
			this.listboxchat.Size = new System.Drawing.Size(288, 454);
			this.listboxchat.TabIndex = 0;
			// 
			// mainform
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(986, 534);
			this.Controls.Add(this.listboxchat);
			this.Margin = new System.Windows.Forms.Padding(3, 2, 3, 2);
			this.Name = "mainform";
			this.Padding = new System.Windows.Forms.Padding(23, 75, 23, 25);
			this.Style = MetroFramework.MetroColorStyle.Black;
			this.ResumeLayout(false);

        }

		#endregion

		private System.Windows.Forms.ListBox listboxchat;
	}
}

