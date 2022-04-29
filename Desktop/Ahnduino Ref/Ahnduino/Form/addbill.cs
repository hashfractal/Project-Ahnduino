 using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Google.Cloud.Firestore;

namespace Ahnduino
{
	public partial class addbill : MetroFramework.Forms.MetroForm
	{
		public addbill()
		{
			InitializeComponent();
		}

		private void metroButton1_Click(object sender, EventArgs e)
		{
			Close();
		}
	}
}
