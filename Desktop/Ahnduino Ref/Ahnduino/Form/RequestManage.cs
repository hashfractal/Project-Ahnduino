using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Ahnduino
{
	public partial class RequestManage : MetroFramework.Forms.MetroForm
	{
		Request Request;
		public RequestManage(Request request)
		{
			InitializeComponent();
			Request = request;
		}

		private void metroListView1_SelectedIndexChanged(object sender, EventArgs e)
		{

		}

		private void metroTextBox1_Click(object sender, EventArgs e)
		{

		}
	}
}
