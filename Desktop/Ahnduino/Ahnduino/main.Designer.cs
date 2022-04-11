namespace Ahnduino
{
	partial class main
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
			this.문의_큐 = new System.Windows.Forms.ListBox();
			this.manageuser = new System.Windows.Forms.Button();
			this.managebuilding = new System.Windows.Forms.Button();
			this.게시판 = new System.Windows.Forms.ListBox();
			this.채팅 = new System.Windows.Forms.ListBox();
			this.SuspendLayout();
			// 
			// 문의_큐
			// 
			this.문의_큐.FormattingEnabled = true;
			this.문의_큐.ItemHeight = 12;
			this.문의_큐.Location = new System.Drawing.Point(12, 12);
			this.문의_큐.Name = "문의_큐";
			this.문의_큐.Size = new System.Drawing.Size(270, 304);
			this.문의_큐.TabIndex = 0;
			this.문의_큐.SelectedIndexChanged += new System.EventHandler(this.listBox1_SelectedIndexChanged);
			// 
			// manageuser
			// 
			this.manageuser.Location = new System.Drawing.Point(12, 660);
			this.manageuser.Name = "manageuser";
			this.manageuser.Size = new System.Drawing.Size(93, 23);
			this.manageuser.TabIndex = 1;
			this.manageuser.Text = "사용자 관리";
			this.manageuser.UseVisualStyleBackColor = true;
			// 
			// managebuilding
			// 
			this.managebuilding.Location = new System.Drawing.Point(111, 660);
			this.managebuilding.Name = "managebuilding";
			this.managebuilding.Size = new System.Drawing.Size(75, 23);
			this.managebuilding.TabIndex = 2;
			this.managebuilding.Text = "건물 관리";
			this.managebuilding.UseVisualStyleBackColor = true;
			// 
			// 게시판
			// 
			this.게시판.FormattingEnabled = true;
			this.게시판.ItemHeight = 12;
			this.게시판.Location = new System.Drawing.Point(288, 12);
			this.게시판.Name = "게시판";
			this.게시판.Size = new System.Drawing.Size(270, 640);
			this.게시판.TabIndex = 3;
			// 
			// 채팅
			// 
			this.채팅.FormattingEnabled = true;
			this.채팅.ItemHeight = 12;
			this.채팅.Location = new System.Drawing.Point(12, 322);
			this.채팅.Name = "채팅";
			this.채팅.Size = new System.Drawing.Size(270, 328);
			this.채팅.TabIndex = 4;
			// 
			// main
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(1070, 695);
			this.Controls.Add(this.채팅);
			this.Controls.Add(this.게시판);
			this.Controls.Add(this.managebuilding);
			this.Controls.Add(this.manageuser);
			this.Controls.Add(this.문의_큐);
			this.Name = "main";
			this.Text = "Form1";
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.ListBox 문의_큐;
		private System.Windows.Forms.Button manageuser;
		private System.Windows.Forms.Button managebuilding;
		private System.Windows.Forms.ListBox 게시판;
		private System.Windows.Forms.ListBox 채팅;
	}
}

