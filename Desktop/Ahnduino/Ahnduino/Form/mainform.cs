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
	
	public partial class mainform : MetroFramework.Forms.MetroForm
	{
		FireBase FireBase = new FireBase();
		public mainform()
		{
			InitializeComponent();

			foreach (string i in FireBase.getChatList())
			{
				listboxchat.Items.Add(i);
			}
			
			
		}
	}
}
