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
	public partial class billselect : Form
	{
		FireBase FireBase = new FireBase();

		List<Bill> bills = new List<Bill>();
		public billselect()
		{
			InitializeComponent();
		}

		private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
		{
			pictureBox1.ImageLocation = FireBase.Getimage(textBox1.Text + comboBox1.Text);
			if (bills.Find( x => x.Date == comboBox1.Text).Pay)
            {
				radioButtontrue.Checked = true;
				radioButtonfalse.Checked = false;
            }
			else
            {
				radioButtontrue.Checked = false;
				radioButtonfalse.Checked = true;
            }
		}

		private void button1_Click(object sender, EventArgs e)
		{
			bills = FireBase.GetBillList(textBox1.Text);
			comboBox1.Items.Clear();

			foreach (Bill bill in bills)
				comboBox1.Items.Add(bill.Date);
			comboBox1.SelectedIndex = comboBox1.Items.Count - 1;
		}

		private void billselect_Load(object sender, EventArgs e)
		{

		}

        private void radioButtontrue_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void radioButtonfalse_CheckedChanged(object sender, EventArgs e)
        {

        }
    }
}
